/*
 * CSParentViewController.swift
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */
import UIKit
import GoogleCast
class CSParentViewController: UIViewController {
    //Queue Builder
    var builder = GCKMediaQueueItemBuilder()
    // Mediacontroller
    var castMediaController1: GCKUIMediaController!
    // mediaInfo
    var mediaInfo1: GCKMediaInformation?
    // bottom Bar
    @IBOutlet var bottomBar: UIView!
    // Minimediacontroller
    var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    // BottomLayout
    @IBOutlet var bottomLayout: NSLayoutConstraint!
    // CurrentCast status
    var currentMediaStatus: GCKMediaStatus?
    /// Banner Slider
    @IBOutlet var navigation: CSCustomNavigationView!
    /// Controller Title
    var controllerTitle = "My Transactions"
    var ChangeTitle = ""
    // MARK: - UIView controller life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.castMediaController1 = GCKUIMediaController()
        castMediaController1.delegate = self
        self.installViewController()
        let previousBtn = GCKUIMediaButtonType(rawValue: 3)
        let nxtBtn = GCKUIMediaButtonType(rawValue: 2)
        castContext.defaultExpandedMediaControlsViewController.setButtonType(previousBtn!, at: 0)
        castContext.defaultExpandedMediaControlsViewController.setButtonType(nxtBtn!, at: 3)
        if CSLanguage.currentAppleLanguage() == "ar" {
            loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: self.view.subviews)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        LibraryAPI.sharedInstance.currentController = self
    }
    override func viewDidAppear(_ animated: Bool) {
        LibraryAPI.sharedInstance.currentController = self
        self.logUser()
        CSRemoteConfiguration.configureRemoteUpdate()
        CSRemoteConfiguration.appVersionCheck(self)
        if navigation != nil {
            navigation.showHideUserView()
            navigation.showNotificationCount()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (LibraryAPI.sharedInstance.isDarkMode()) ? .lightContent : .default
    }
    /// Update notification Count
    func setNotificationCount() {
        if navigation != nil {
            navigation.showNotificationCount()
        }
    }
    func hideSkeletonView() {
    }
    /// Use the current user's information
    func logUser() {
        // You can call any combination of these three methods
        // Crashlytics.sharedInstance().setUserEmail(LibraryAPI.sharedInstance.getUserEmailId())
        // Crashlytics.sharedInstance().setUserIdentifier(LibraryAPI.sharedInstance.getAccessToken())
        // Crashlytics.sharedInstance().setUserName(LibraryAPI.sharedInstance.getUserName())
    }
    override func didReceiveMemoryWarning() {
    }
    // Call Api
    func callApi() {
        if navigation != nil {
            navigation.showHideUserView()
        }
    }
    /// add addChildView
    /// - Parameters:
    ///   - identifier: identifiers for child view controller
    ///   - storyBoard: child view controller story board
    func addChildView( identifier: String, storyBoard: UIStoryboard) {
        let controller = storyBoard.instantiateViewController(withIdentifier:
            identifier) as? CSAlertViewController
        controller?.view.frame = self.view.bounds
        controller?.titleText = controllerTitle
        controller?.willMove(toParent: self)
        self.view.addSubview((controller?.view)!)
        self.addChild(controller!)
        controller?.didMove(toParent: self)
    }
    /// add addChildView
    /// - Parameters:
    ///   - identifier: identifiers for child view controller
    ///   - storyBoard: child view controller story board
    func addChildViewController( identifier: String, storyBoard: UIStoryboard) {
        let controller = storyBoard.instantiateViewController(withIdentifier:
            identifier)
        controller.view.frame = self.view.bounds
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
    /// This method is used to remove the child view from the parent
    /// - Parameter controller: controller to remove from parent
    func removeChildView( controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    /// Setting Gradient
    /// - Parameter view: Passed view from other view controllers
    func addGradientBackGround() {
        self.view.backgroundColor = .background
    }
    /// Add Left Bar Button To Navigation bar
    func addLeftBarButton() {
        self.navigationItem.setLeftBarButtonItems([self.setBackBarButton(),
                                                   self.setHeaderTitle(controllerTitle)], animated: true)
    }
    // Add left Bar Button To presentViewcontroller
    func addLeftPresentBarButton() {
        self.navigationItem.setLeftBarButtonItems([self.setDismissBarButton(),
                                                   self.setHeaderTitle(controllerTitle)], animated: true)
    }
    /// Add Right Bar Button To Navigation bar
    func addRightBarButton() {
        self.navigationItem.setRightBarButtonItems([self.setSapcer()], animated: true)
    }
    /// To change the refresh inidcator color
    func chanageRefreshIndicator(_ indicator: PullToRefreshManager) {
        indicator.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    func linearProgressBar() {
    }
}
// MARK: - Activity Indicator
extension CSParentViewController {
    /// This method is used to start the loader
    func startLoading() {
    }
    /// This method to stop the loader
    func stopLoading() {
    }
}
extension UIViewController {
    // Check Langauge Change
    func islangauge(_ langauge: String) -> Bool {
        if langauge != CSLanguage.currentAppleLanguage() {
            self.reloadViewFromNib()
            return true
        }
        return false
    }
}
// GCKUIMiniMediaControlsViewControllerDelegate Controls
extension CSParentViewController: GCKUIMiniMediaControlsViewControllerDelegate {
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
extension CSParentViewController: GCKUIMediaControllerDelegate, GCKRequestDelegate {
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
            self.mediaInfo1 = mediaInformation
            if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
                builder.mediaInformation = self.mediaInfo1
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
