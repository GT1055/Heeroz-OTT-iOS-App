/*
 * CSVideoDetailViewController+PlayerExtension.swift
 * This is a extenstion class for video Detail page which contain Player method
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import CryptoSwift
import GoogleCast
//import GoogleInteractiveMediaAds
// import Starscream
// MARK: - Player Private Method
extension CSVideoDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubscriptionPage"{
            if let destination = segue.destination as? CSSubscriptionViewController {
                destination.isViaVideo = true
            }
        }
        if segue.identifier == "toXrayView" {
            let destinationNavigationController = segue.destination as! UINavigationController
            if let targetController = destinationNavigationController.topViewController as? XRayViewController {
                self.xrayViewController = targetController
                targetController.parenController = self
//                targetController.xrayList = self.xrayList
            }
        }
        if segue.identifier == "xrayDetail" {
            let param = sender as! [String:Int]
            let row = param["row"]!
            let dest = segue.destination as! XRayDetailViewController
            if let url = URL.init(string: self.xrayCastInfos[row].externalUrl) {
               dest.pageUrl = url
            }
        }
        if segue.identifier == "liveChat" {
            if let destination = segue.destination as? CSLiveChatViewController {
                self.liveChatController = destination
            }
        }
    }
    //Paywall
    func addPaywallPopover() {
        self.playerView.stopActivity()
        payWallView.isHidden = false
    }
    
    /// Add Player
    func setPlayerData() {
        // should print log, default false
        BMPlayerConf.allowLog = false
        BMPlayerConf.enablePlaytimeGestures = true
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            playerViewable.isLive = isLive
            playerViewable.isLiveController = false
            BMPlayerConf.enablePlaytimeGestures = false
            playerViewable.setHideViewForLive()
            playerViewable.backButtonWidthConstant = 35
            playerViewable.setHideBackButtonViewForLive(playerViewable.backButtonWidthConstant)
        }
        addPlayer()
        self.preparePlayerItem()
        if let asset = self.customDelegate?.player?.avPlayer?.currentItem?.asset {
            //customDelegate?.fetchAudio(with: asset as! AVURLAsset)
        }
        playerView.isHidden = false
    }
    /// Player Adding
    func addPlayer() {
        /// Player Delgate
        playerView.delegate = self
        playerView.backBlock = { [unowned self] (isFullScreen) in
            if !isFullScreen {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    /// Check Network
    func checkNetworkAndStorePlayBack() {
        if !Connectivity.isConnectedToInternet() {
            self.showToastMessageTop(message: "The Internet connection appears to be offline")
            // self.playerView.pause()
            return
        }
    }
    func checkNetworkStatus() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSVideoDetailViewController.addPlayerView(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
    @objc func addPlayerView(notification: NSNotification) {
    }
    /// Detect Change of Orientation
    func changeOrentation(_ isFullscreen: Bool) {
        if replyCommentBaseView.tag == 1 {
            replyCommentBaseView.isHidden = true
        } else {
            replyCommentBaseView.isHidden = true
        }
        commentView.isHidden = isFullscreen
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView), isGoogleAds {
            playerViewable.removeCuePoint()
            DispatchQueue.main.async {
                playerViewable.addCuePointView()
            }
        }
        playerView.snp.remakeConstraints { (make) in
            if !isFullscreen {
                if UIScreen.main.nativeBounds.height == 2436 ||
                    UIScreen.main.nativeBounds.height == 2688 ||
                    UIScreen.main.nativeBounds.height == 1624 {
                    make.top.equalTo(view.snp.top).offset(40)
                } else {
                    make.top.equalTo(view.snp.top).offset(20)
                }
            } else {
                make.top.equalTo(view.snp.top)
            }
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(view.snp.bottom)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    /// Auto Play The Video
    func autoPlayVideo() {
        // self.videoKeyDetail()
        for view in (self.playerImage.superview?.subviews)! { view.isHidden = true }
        self.newTrackVideo()
        self.setPlayerData()
    }
}
// MARK: - BMPlayerDelegate example
extension CSVideoDetailViewController: BMPlayerDelegate {
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
        if hasConnectedCastSession() {
            let metadata = GCKMediaMetadata()
            metadata.setString(self.titleLabel.text!, forKey: kGCKMetadataKeyTitle)
            if let url = URL.init(string: UserDefaults.standard.value(forKey: "Thumbnail") as? String ?? "") {
                metadata.addImage(GCKImage(url: url, width: 480, height: 360)) }
            // [START load-media]
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
            playerView.pause()
            UIView.transition(with: alertOptions, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.alertOptions.isHidden = false
                self.backgroundAlertview.isHidden = false
            })
            posterImg.setImageWithUrl(UserDefaults.standard.value(forKey: "Image") as? String)
        }
    }
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        if state == .buffering {
            checkNetworkAndStorePlayBack()
        }
//        if isGoogleAds, state == .playedToTheEnd,
//            let playerItem = player.avPlayer?.currentItem,
//            let avurlasset = playerItem.asset as? AVURLAsset,
//            avurlasset.url.absoluteString == videoUrl {
//            isPlayedTitlEnd = true
//            adsLoader!.contentComplete()
//        }
    }
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval,
                  totalTime: TimeInterval) {
        lastTime = Double(currentTime)
        totalDuration = Double(totalTime)
        let perCentage = 100 * lastTime / totalDuration
        isFifteenPrecent = (perCentage >= 15) ? true : false
    
        //Paywall logic
        if !LibraryAPI.sharedInstance.isUserSubscibed() {
            if isPremiumVideo == 0 && isPrice == 0 {
                if Double(currentTime) == Double(totalTime) {
                    callWatchTime()
                    addPaywallPopover()
                    return
                }
            }
        }
        
        if isBought == 1 && isPrice > 0 && !LibraryAPI.sharedInstance.isUserSubscibed() {
            if perCentage > 99.9 {
                if isExpired ==  true {
                    isExpired = false
                    if UIDevice.current.orientation.isLandscape {
                        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    }
                    self.playerView.playerLayer?.pause()
                    self.callApi()
                    expiryAlert()
                }
            }
        if perCentage > 9 && perCentage < 31 {
            if isReachlimit == false {
                print(perCentage)
                fetchVideoCount(50)
                isReachlimit = true
            }
        } else if perCentage > 59 && perCentage < 81 {
            if isReachlimit == false {
                print(perCentage)
                fetchVideoCount(100)
                isReachlimit = true
            }
        } else {
            isReachlimit = false
        }
    }
        isPlayedTitlEnd = false
        UserDefaults.standard.set(currentTime, forKey: "Timeinterval")
        if LibraryAPI.sharedInstance.isUserSubscibed(), UIApplication.isUserLoginInApplication() {
            LibraryAPI.sharedInstance.storeLastPlayItem(String(videoId),
                                                        currentVideoDuration: String(currentTime))
            return
        }
    }
    func expiryAlert() {
        let alert = UIAlertController(title: "", message: "You have reached maximum number of views hence this video has been expired.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            self.navigateTopurchasePage()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval,
                  totalDuration: TimeInterval) {
    }
    // PLayer Item
    func preparePlayerItem() {
        /// Resolution protocol to pass the resolution
        var bitRateResource = [BMPlayerResourceDefinition]()
        let header = ["Referer": REFERER,
                      "Title": ("vplayed/" + String(self.videoKey)).aesDoubleEncryptedString(),
                      "Content-Type": "application/x-www-form-urlencoded",
                      "X-REQUEST-TYPE": "mobile",
                      "X-DEVICE-TYPE": "iOS",
                      "X-USER-ID": LibraryAPI.sharedInstance.getUserId(),
                      "X-ACCESS-TOKEN": LibraryAPI.sharedInstance.getAccessToken()]
        let options = ["AVURLAssetHTTPHeaderFieldsKey": header]
        for  index in 0..<self.urlAndResolutionSets.count {
            if let data = self.urlAndResolutionSets[index] as? CSVideoUrlResponse {
                let resource = BMPlayerResourceDefinition(url: data.resulotionUrl,
                                                          definition: data.quality,
                                                          options: options)
                bitRateResource.append(resource)
            }
        }
        let asset = BMPlayerResource(name: self.titleLabel.text!,
                                     definitions: bitRateResource,
                                     cover: URL.init(string: thumbNailString),
                                     subtitles: nil)
        if LibraryAPI.sharedInstance.getVideoId() == videoId &&
            LibraryAPI.sharedInstance.getVideoDuration() != 0 {
            playerView.seek(TimeInterval(LibraryAPI.sharedInstance.getVideoDuration()))
        }
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            playerViewable.playRate = 1.0
            playerViewable.isLive = isLive
            playerViewable.playerDefinion = "Auto"
            playerViewable.previousResoutionIndex = 0
            playerViewable.selectedRateIndex = 1
        }
        if isGoogleAds {
            /// Player Add For Google Ads
            self.playerView.setVideo(resource: asset)
            DispatchQueue.main.async {[weak self] in
//                self?.contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self?.playerView.avPlayer)
//                self?.requestAds()
            }
            return
        }
        playerView.setVideo(resource: asset)
    }
    /// Add Player Timer
    func addPlayerTimer() {
        videoKeyTimer?.fire()
        videoKeyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.videoKey += 1
            self.liveTime += 1
            if self.liveTime >= 300
            {
                self.playerView.pause()
                self.addPaywallPopover()
                self.liveTime = 0
            }
        })

    }
}
extension Data {
    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        for index in 0..<length {
            let offsetOne = hexString.index(hexString.startIndex, offsetBy: index * 2)
            let offsetTwo = hexString.index(offsetOne, offsetBy: 2)
            let bytes = hexString[offsetOne..<offsetTwo]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}
// Ad Integration
/*extension CSVideoDetailViewController {
    func setUpAdsLoader() {
        if !isGoogleAds { return }
        adsLoader = IMAAdsLoader(settings: nil)
        // NOTE: This line will cause an error until the next step, "Get the Ads Manager".
        adsLoader!.delegate = self
        let settings = IMAAdsRenderingSettings.init()
        settings.mimeTypes = ["video/mp4", "application/x-mpegURL"]
        self.adsManager?.initialize(with: settings)
    }
    func requestAds() {
        // Create an ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: adsVideo, viewController: nil)
        let request = IMAAdsRequest(
            adTagUrl: kTestAppAdTagUrl,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        adsLoader!.requestAds(with: request)
    }
}
/// MARK: - Ads Manager Delegate
extension CSVideoDetailViewController: IMAAdsManagerDelegate {
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        switch event.type {
        case .LOADED:
            // When the SDK notifies us that ads have been loaded, play them.
            adsManager.start()
            controlAnimation(false)
            adsPlay.isSelected = false
            adsProgress.setProgress(0, animated: false)
            isAdsStart = true
        case .CLICKED:
            adsPlay.isSelected = true
            adsManager.pause()
        case .COMPLETE, .SKIPPED:
            controlAnimation(false)
            isAdsStart = false
            adsViews.isHidden = true
            self.adsPlay.superview?.isHidden = true
        case .PAUSE:
            adsPlay.isSelected = true
        case .RESUME:
            adsPlay.isSelected = false
        default:
            break
        }
    }
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the
        // error and play the content.
        // self.showToastMessageTop(message: error.message)
        adsViews.isHidden = true
        self.adsPlay.superview?.isHidden = true
        if !self.isPlayedTitlEnd {
            self.playerView.play()
        }
    }
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        adsViews.isHidden = false
        self.adsPlay.superview?.isHidden = false
        self.playerView.pause()
    }
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        if !self.isPlayedTitlEnd {
            adsViews.isHidden = true
            self.adsPlay.superview?.isHidden = true
            self.playerView.play()
        }
    }
}
// MARK: - Ads Loader Delegate
extension CSVideoDetailViewController: IMAAdsLoaderDelegate {
    public func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate
        adsManager = adsLoadedData.adsManager
        if let data: [Any] = self.adsManager?.adCuePoints ,
            let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView),
            data.count > 0 {
            playerViewable.cuePoint = data
            playerViewable.addCuePointView()
        }
        adsManager!.delegate = self
        // Create ads rendering settings and tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsRenderingSettings.webOpenerPresentingController = self
        // Initialize the ads manager.
        adsManager!.initialize(with: adsRenderingSettings)
    }
    public func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        adsViews.isHidden = true
        self.adsPlay.superview?.isHidden = true
        // self.showToastMessageTop(message: adErrorData.adError.message)
        if !self.isPlayedTitlEnd {
            self.playerView.play()
        }
    }
    public func adsManager(_ adsManager: IMAAdsManager!, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval) {
        let progress = Float(mediaTime/totalTime)
        adsProgress.setProgress(progress, animated: true)
    }
    @objc func willResignActive(_ notification: Notification) {
        // code to execute
        if adsManager != nil && isAdsStart {
            isAdsStart = false
            adsManager?.pause()
        }
    }
    @objc func didBecomeActive(_ notification: Notification) {
        // code to execute
        if adsManager != nil && !isAdsStart {
            isAdsStart = true
            adsManager!.resume()
        }
    }
}*/
// MARK: - Video Player
extension CSVideoDetailViewController {
    @IBAction func playVideoButton(_ sender: UIButton) {
        if sender.isSelected {
            //adsManager?.resume()
        } else {
            //adsManager?.pause()
        }
    }
    @IBAction func fullscreenButton(_ sender: UIButton) {
        if UIDevice.current.orientation.isLandscape {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        sender.isSelected = UIDevice.current.orientation.isLandscape
    }
}
// MARK: - Auto fade effect show of masking View on tap gesture action
extension CSVideoDetailViewController {
    /// Control Animation action of Masking View
    func controlAnimation(_ isShow: Bool) {
        self.adsPlay.superview?.alpha = isShow ? 0 : 1
        self.adsFullScreen.alpha = isShow ? 0 : 1
        self.adsFullScreen.superview?.alpha = isShow ? 0 : 1
    }
}
