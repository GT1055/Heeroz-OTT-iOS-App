/*
 * CSAlertViewController
 * This class is used for show the nodataview/whoopsview/nointernetview
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import Reachability
import GoogleCast
class CSAlertViewController: UIViewController {
    //QueueBuilder
    var builder = GCKMediaQueueItemBuilder()
    // Mediacontroller
    var castMediaController: GCKUIMediaController!
    // Bottombar
    @IBOutlet var bottomBar: UIView!
    // Minimediacontroller
    var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    //Bottomlayout
    @IBOutlet var bottomLayout: NSLayoutConstraint!
    /// Content Label
    @IBOutlet weak var contentLabel: UILabel!
    /// back button Iboutlet
    @IBOutlet weak var backButton: UIButton!
    /// Title Label
    @IBOutlet weak var titleLabel: UILabel!
    /// Title Label
    @IBOutlet weak var contentTitle: UILabel!
    /// show retry button hidde
    var hiddeRetryButton = false
    /// Navigation Is Need
    var isNavigationNeed = false
    /// Title Text as String
    var titleText = String()
    // mediaInfo
    var mediaInfo: GCKMediaInformation?
    // Reachability
    private var reachability: Reachability!
    override func viewDidLoad() {
        super.viewDidLoad()
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.castMediaController = GCKUIMediaController()
        castMediaController.delegate = self
        self.installViewController()
        reachability = Reachability()
        //        updateUserInterface()
    }
    override func viewDidAppear(_ animated: Bool) {
        hideandShowNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusManager),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do {
            try self.reachability.startNotifier()
        } catch {
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        setColorByMode()
        self.navigationController?.isNavigationBarHidden = true
        hideandShowNavigationBar()
        titleLabel.text = titleText
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = isNavigationNeed
    }
    func setColorByMode() {
        self.view.backgroundColor = .background
        contentLabel.textColor = UIColor.themeColorButton()
        titleLabel.textColor = .navigationTitleColor
        backButton.tintColor = .navigationIconColor
    }
    // Hide and Show NAvigation Bar
    func hideandShowNavigationBar() {
        if let navigationController = LibraryAPI.sharedInstance.currentController.navigationController {
            self.isNavigationNeed = navigationController.isNavigationBarHidden
        } else {
            self.isNavigationNeed = false
        }
        if LibraryAPI.sharedInstance.currentController is HomePageViewController ||
            LibraryAPI.sharedInstance.currentController is CSLiveViewController ||
            LibraryAPI.sharedInstance.currentController is CSCateoryViewController ||
            LibraryAPI.sharedInstance.currentController is CSOfflineViewController {
            backButton.superview?.isHidden = true
        } else if LibraryAPI.sharedInstance.currentController is CSAddToPlaylistViewController ||
            LibraryAPI.sharedInstance.currentController is CSReplyCommentViewController ||
            LibraryAPI.sharedInstance.currentController is CSModifyPlaylistViewController {
            backButton.superview?.isHidden = !self.isNavigationNeed
        } else if LibraryAPI.sharedInstance.currentController is CSElasticSearchViewController ||
            LibraryAPI.sharedInstance.currentController is CSNotificationViewController ||
            LibraryAPI.sharedInstance.currentController is CSFavoutritesViewController ||
            LibraryAPI.sharedInstance.currentController is CSSavedPlaylistViewController ||
            LibraryAPI.sharedInstance.currentController is CSHistoryViewController ||
            LibraryAPI.sharedInstance.currentController is CSTransactionListViewController ||
            LibraryAPI.sharedInstance.currentController is CSVideoDetailViewController ||
            LibraryAPI.sharedInstance.currentController is CSPlaylistVideoListViewController {
            if backButton != nil {
                backButton.superview?.isHidden = !self.isNavigationNeed
            }
        } else {
            if backButton != nil {
                backButton.superview?.isHidden = !self.isNavigationNeed
            }
        }
    }
    /// This method is used to retry the api
    /// - Parameter sender: UIButton
    @IBAction func retryAction(_ sender: Any) {
        if parent is CSParentViewController {
            let parentController: CSParentViewController? = (parent as? CSParentViewController)
            parentController?.removeChildView(controller: self)
            parentController?.callApi()
        }
    }
    /// This method is used to pop the view
    ///
    /// - Parameter sender: UIButton
    @IBAction func backAction(_ sender: Any) {
        if parent is CSParentViewController {
            let parentController: CSParentViewController? = (parent as? CSParentViewController)
            parentController?.removeChildView(controller: self)
            _ = parentController?.navigationController?.popViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateUserInterface() {
        if self.view.tag == 101 && reachability.connection != .none {
            self.showToastMessageTop(message: NSLocalizedString("Back to online", comment: "network"))
            self.retryAction(UIButton())
        }
    }
    @objc func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
}
// GCKUIMiniMediaControlsViewControllerDelegate Listeners
extension CSAlertViewController: GCKUIMiniMediaControlsViewControllerDelegate {
    // Install Bottomview
    func installViewController() {
        if let view = bottomBar {
            if !view.subviews.contains(miniMediaControlsViewController.view) {
                miniMediaControlsViewController.view.frame = view.bounds
                view.addSubview(miniMediaControlsViewController.view)
                miniMediaControlsViewController.didMove(toParent: self)
            }
            view.alpha = miniMediaControlsViewController.active ? 1.0 : 0
            if let constant = bottomLayout {
                constant.constant = miniMediaControlsViewController.active ? 60.0 : 0.0
            }
        }
    }
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                         shouldAppear: Bool) {
        if let constant = bottomLayout {
            constant.constant = shouldAppear ? 60.0 : 0.0
        }
        if let view = bottomBar {
            view.alpha = shouldAppear ? 1.0 : 0
        }
    }
}
//GCKUIMediaControllerDelegate & GCKRequestDelegate Controls
extension CSAlertViewController: GCKUIMediaControllerDelegate, GCKRequestDelegate {
    func mediaController(_ mediaController: GCKUIMediaController, didBeginPreloadForItemID itemID: UInt) {
    }
    func mediaController(_ mediaController: GCKUIMediaController, didUpdate mediaStatus: GCKMediaStatus) {
        if mediaStatus.idleReason == GCKMediaPlayerIdleReason.finished {
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
            if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
                builder.mediaInformation = self.mediaInfo
                builder.autoplay = false
                builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
                let item = builder.build()
                let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
                let request = remoteMediaClient.queueLoad([item],
                                                          start: 0, playPosition: 0,
                                                          repeatMode: repeatMode, customData: nil)
                request.delegate = self
            }
        }
    }
    func mediaController(_ mediaController: GCKUIMediaController,
                         didUpdate playerState: GCKMediaPlayerState, lastStreamPosition streamPosition: TimeInterval) {
    }
}
