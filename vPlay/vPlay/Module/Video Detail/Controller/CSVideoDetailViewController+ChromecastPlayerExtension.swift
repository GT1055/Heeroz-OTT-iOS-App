//
//  CSVideoDetailViewController+ChromecastPlayerExtension.swift
//  vPlay
//
//  Created by user on 22/02/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import GoogleCast
extension CSVideoDetailViewController {
    /// Go to  Subscription
    @IBAction func moveToSubscription(_ sender: UIButton) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.performSegue(withIdentifier: "SubscriptionPage", sender: nil)
    }
    //Cast playbutton
    @IBAction func playNowButton(_ sender: UIButton) {
        hideCastOpitions()
        if isPremiumVideo == 1 && !LibraryAPI.sharedInstance.isUserSubscibed() {
            self.performSegue(withIdentifier: "SubscriptionPage", sender: nil)
            return
        } else {
            loadMedia()
            self.loadSelectedItem(byAppending: false) }
    }
    //Add to queue button
    @IBAction func addToQueueButton(_ sender: UIButton) {
        hideCastOpitions()
        if isPremiumVideo == 1 && !LibraryAPI.sharedInstance.isUserSubscibed() {
            self.performSegue(withIdentifier: "SubscriptionPage", sender: nil)
            return
        } else {
            self.loadSelectedItem(byAppending: true) }
    }
    func chromecastIntialise() {
        alertOptions.isHidden = true
        backgroundAlertview.isHidden = true
        castMediaController.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backgroundAlertview.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
        let cast = GCKCastContext.sharedInstance().castState
        backgroundLabel.isHidden = cast == .connected ? false : true
        if GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession() {
            if let device: GCKDevice = GCKCastContext.sharedInstance().discoveryManager.device(at: 0) {
                self.castLabel.text = "Playing on \(String(describing: device.friendlyName!))" }
        }
    }
    // You can present the instructions on how to use Google Cast on
    // the first time the user uses you app
    @objc func castDeviceDidChange(_ notification: Notification) {
        if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
            GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce() }
    }
    // Switch to local while disabled chromecast
    func switchToLocalPlayback() {
        if self.playbackMode == .local {
            return
        }
        if self.playbackMode == .remote {
            playerView.seek(TimeInterval(castMediaController.lastKnownStreamPosition))
        }
        self.castSession?.remoteMediaClient?.remove(self)
        self.castSession = nil
        self.playbackMode = .local
    }
    // Switch to remote after enable chromecast
    func switchToRemotePlayback() {
        if self.playbackMode == .remote {
            return
        }
        if self.sessionManager.currentSession is GCKCastSession {
            self.castSession = (self.sessionManager.currentSession as? GCKCastSession)
        }
        loadMedia()
        // If we were playing locally, load the local media on the remote player
        if self.playbackMode == .local {
            builder.mediaInformation = self.mediaInfo
            builder.autoplay = false
            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build()
            self.castSession?.remoteMediaClient?.queueLoad(
                [item], start: 0,
                playPosition: UserDefaults.standard.value(forKey: "Timeinterval") as? TimeInterval ?? 0,
                repeatMode: .all, customData: nil)
        }
        self.playerView.pause()
        self.loadSelectedItem(byAppending: true)
        self.castSession?.remoteMediaClient?.add(self)
        self.playbackMode = .remote
    }
    // MARK: - GCKSessionManagerListener
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        DispatchQueue.main.async {
            if let device: GCKDevice = GCKCastContext.sharedInstance().discoveryManager.device(at: 0) {
                self.castLabel.text = "Playing on \(String(describing: device.friendlyName!))"
            }
            self.showToastMessageTop(message: NSLocalizedString("Video Casting is Connected", comment: "Success"))
        }
        self.switchToRemotePlayback()
        backgroundLabel.isHidden = false
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        self.switchToRemotePlayback()
        playerView.pause()
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        DispatchQueue.main.async {
            LibraryAPI.sharedInstance.currentController
                .showToastMessageTop(message: NSLocalizedString("The Casting session has ended.", comment: "Success"))
        }
        self.switchToLocalPlayback()
        playerView.play()
        backgroundLabel.isHidden = true
        hideCastOpitions()
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        playerView.play()
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToResumeSession session: GCKSession, withError error: Error?) {
        self.switchToLocalPlayback()
        playerView.play()
    }
    // MARK: - GCKRemoteMediaClientListener
    func remoteMediaClient(_ player: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        self.mediaInfo = mediaStatus?.mediaInformation
    }
    /**
     * Loads the currently selected item in the current cast media session.
     * @param appending If YES, the item is appended to the current queue if there
     * is one. If NO, or if
     * there is no queue, a new queue containing only the selected item is created.
     */
    func loadSelectedItem(byAppending appending: Bool) {
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            builder.mediaInformation = self.mediaInfo
            builder.autoplay = true
            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build()
            var queueArray = [String]()
            let castContext = GCKCastContext.sharedInstance().sessionManager
            mediaClient = castContext.currentSession?.remoteMediaClient
            mediaClient.add(self)
            if let castContext = mediaClient.mediaStatus?.queueItemCount {
                if castContext != 0 {
                    for index in 0..<mediaClient.mediaStatus!.queueItemCount {
                        queueArray.append(mediaClient.mediaStatus!.queueItem(at: index)!.mediaInformation.contentID!)
                    } } }
            let contains = queueArray.contains(where: {$0 == item.mediaInformation.contentID})
            if ((remoteMediaClient.mediaStatus) != nil) && appending {
                if contains {
                    self.showToastMessageTop(message: NSLocalizedString("This video is already in queue", comment: "success"))
                } else {
                    let request = remoteMediaClient.queueInsert(item, beforeItemWithID: kGCKMediaQueueInvalidItemID)
                    request.delegate = self
                    if let castContext = mediaClient.mediaStatus?.queueItemCount {
                        if castContext == 0 {
                            let request = remoteMediaClient.queueLoad([item],
                                                                      start: 0, playPosition: 0,
                                                                      repeatMode: .all, customData: nil)
                            request.delegate = self
                        } else {
                            self.showToastMessageTop(message: NSLocalizedString("Video is added to queue", comment: "Success"))
                        }
                    }
                }
            } else {
                if contains {
                    self.showToastMessageTop(message: NSLocalizedString("This video is already in queue", comment: "success"))
                } else {
                    let request = remoteMediaClient.queueLoad(
                        [item], start: 0,
                        playPosition: UserDefaults.standard.value(forKey: "Timeinterval") as? TimeInterval ?? 0,
                        repeatMode: .all, customData: nil)
                    request.delegate = self }
            }
        }
    }
    // Load media to Cast
    func loadMedia() {
        let metadata = GCKMediaMetadata()
        metadata.setString(UserDefaults.standard.value(forKey: "Title") as? String ?? "", forKey: kGCKMetadataKeyTitle)
        if let url = URL.init(string: UserDefaults.standard.value(forKey: "Thumbnail") as? String ?? "") {
            metadata.addImage(GCKImage(url: url, width: 480, height: 360)) }
        // [STRAT & END media-metadata]
        let mediaInformation = GCKMediaInformation.init(
            contentID: UserDefaults.standard.value(forKey: "Url") as? String ?? "",
            streamType: GCKMediaStreamType.buffered,
            contentType: "video/m3u8",
            metadata: metadata,
            streamDuration: 0,
            mediaTracks: [],
            textTrackStyle: nil,
            customData: nil
        )
        self.mediaInfo = mediaInformation
    }
}
// Hide and Show viewoption
extension CSVideoDetailViewController {
    ///Tap geture on uiview
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.transition(with: backgroundAlertview, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.alertOptions.isHidden = true
            self.backgroundAlertview.isHidden = true
        })
    }
    //Viewoption disabled action
    func hideCastOpitions() {
        UIView.transition(with: alertOptions, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.alertOptions.isHidden = true
            self.backgroundAlertview.isHidden = true
        })
    }
}
