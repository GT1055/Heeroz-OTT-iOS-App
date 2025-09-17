/*
 * CSVideoDetailViewController+Extension.swift
 * This is a Controller class is used for Video Detail Data displaying
 * Which controll the Functionality of Video Detail Data
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import FaveButton
import UICircularProgressRing
import GoogleCast
//import GoogleInteractiveMediaAds
import IQKeyboardManagerSwift
/* The player state. */
enum PlaybackMode: Int {
    case none = 0
    case local
    case remote
}
let kPrefShowStreamTimeRemaining: String = "show_stream_time_remaining"
// import Starscream
class CSVideoDetailViewController: CSParentViewController, GCKSessionManagerListener, UIGestureRecognizerDelegate, GCKMediaQueueDelegate,
GCKRemoteMediaClientListener {
    /// Background label
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet var backgroundLabel: UIView!
    /// Cast status label
    @IBOutlet var castLabel: UILabel!
    /// Circular Progress Bar
    @IBOutlet weak var progressBar: UICircularProgressRing!
    /// Scroll View
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    /// Comment Table
    @IBOutlet var commentTable: UITableView!
    /// Count View
    @IBOutlet var countView: UIView!
    /// Chat View
    @IBOutlet var liveChatbuttonView: UIView!
    /// count Label View
    @IBOutlet var countLabel: UILabel!
    /// Comment Data Sources
    @IBOutlet var commentTableDataSource: CSCommentTableDataSource!
    /// comment table Height Constant
    @IBOutlet var commentTableHeight: NSLayoutConstraint!
    /// Related Collection View
    @IBOutlet var relatedCollection: UICollectionView!
    /// related Collection Data Sources
    @IBOutlet var relatedCollectionDataSource: CSRelatedCollectionDataSources!
    /// related Collection Height
    @IBOutlet var relatedCollectionHeight: NSLayoutConstraint!
    /// livechatView Height
    @IBOutlet var livechatViewHeight: NSLayoutConstraint!
    /// related Collection More
    @IBOutlet var relatedMore: UIButton!
    /// hide And Show Premium
    @IBOutlet var hideShowPremium: NSLayoutConstraint!
    /// Live width constraint
    @IBOutlet weak var liveWidthConstraint: NSLayoutConstraint!
    /// Profile Image
    @IBOutlet var profileImage: UIImageView!
    /// Comment UIView
    @IBOutlet var commentView: UIView!
    /// Comment Place Holder
    @IBOutlet var commentPlaceHolder: UILabel!
    /// Comment Text View
    @IBOutlet var commentTextView: CSDoneTextView!
    /// A Variable to display the Player Image
    @IBOutlet var playerImage: UIImageView!
    /// A Variable to display the description
    @IBOutlet var descriptionLabel: UILabel!
    /// A Variable to display the title
    @IBOutlet var titleLabel: UILabel!
    /// A Variable to display the Video Duration
    @IBOutlet var videoDuration: UILabel!
    /// A Variable to display the Published Date
    @IBOutlet var publishedDate: UILabel!
    /// Age classification
    @IBOutlet weak var ageClassification: UILabel!
    /// A Variable to display the Published Date
    @IBOutlet var viewsCount: UILabel!
    /// Video Category
    @IBOutlet weak var publishView: UIView!
    /// Age View
    @IBOutlet weak var ageView: UIView!
    /// Age Height
    @IBOutlet weak var ageHConstraint: NSLayoutConstraint!
    /// Age Top Constraint
    @IBOutlet weak var ageTopConstraint: NSLayoutConstraint!
    /// Video Category Label
    @IBOutlet var videoCategory: UILabel!
    /// A Variable to display the Player Image
    @IBOutlet var noDataForTable: UILabel!
    ///  Favourite Button
    @IBOutlet var favouriteButton: FaveButton!
    /// Related Label Y axis height
    @IBOutlet var relatedYAxis: NSLayoutConstraint!
    /// Text Field View height Constant
    @IBOutlet var heightConstantTextField: NSLayoutConstraint!
    /// BM Custom Player 
    @IBOutlet var playerView: BMCustomPlayer!
    /// Add Favourite Label
    @IBOutlet var addFavouriteLabel: UILabel!
    /// Play List Follow
    @IBOutlet var playListFollowImage: UIImageView!
    /// Buy Button
    @IBOutlet var buyButton: UIButton!
    /// Buy Button View
    @IBOutlet var buyButtonView: UIView!
    /// Play List Follow
    @IBOutlet var playListFollowButton: UIButton!
    /// chat button
    @IBOutlet var chatButton: UIButton!
    /// Related Title Height Constant
    @IBOutlet var publishedDateHeight: NSLayoutConstraint!
    /// Related Title
    @IBOutlet var relatedTitle: UILabel!
    /// Reply Comment View
    @IBOutlet var replyCommentBaseView: UIView!
    /// Like Button
    @IBOutlet var likeButton: FaveButton!
    /// UnLike Button
    @IBOutlet var unLikeButton: FaveButton!
    /// Season Drop Imageview
    @IBOutlet weak var seasonDropImageView: UIImageView!
    // Like Count
    @IBOutlet var likeCount: UILabel!
    // DisLike Count
    @IBOutlet var disLikeCount: UILabel!
    // Starring Title
    @IBOutlet var starringTitle: UILabel!
    // Starring list
    @IBOutlet var starring: UILabel!
    // Stack View
    @IBOutlet var stackViewSuper: UIStackView!
    // Stack View
    @IBOutlet var stackViewWidth: NSLayoutConstraint!
    // Days
    @IBOutlet var days: UILabel!
    // Hours
    @IBOutlet var hours: UILabel!
    // Minutes
    @IBOutlet var minutes: UILabel!
    // Seconds
    @IBOutlet var seconds: UILabel!
    /// Season View
    @IBOutlet var showSeasonView: UIView!
    /// Season View Label
    @IBOutlet var showSeasonLabel: UILabel!
    /// Season Drop Down Image Width
    @IBOutlet var seasonDownImageWidth: NSLayoutConstraint!
    /// Play Button
    @IBOutlet var playVideoButton: UIButton!
    /// is Premium Video View
    @IBOutlet var premiumVideo: UILabel!
    /// isGeo-Fenced Region
    @IBOutlet var fencedContent: UIView!
    /// fenced value
    var isFenced = Int()
    /// Comment View
    @IBOutlet var commentCount: UIView!
    /// Show Commenter View
    @IBOutlet var commenterView: UIView!
    /// like And Unlike View
    @IBOutlet var likeAndUnlikeView: UIView!
    /// Like Height View
    @IBOutlet weak var likeViewHeight: NSLayoutConstraint!
    /// like And Unlike View
    @IBOutlet var favouriteShareNadPlaylist: UIStackView!
    /// contents view
    @IBOutlet weak var contentsView: UIView!
    /// releated header view
    @IBOutlet weak var releatedHeaderView: UIView!
    /// View Header
    @IBOutlet weak var commentBackgroundView: UIView!
    /// comments label
    @IBOutlet var commentsLabel: UILabel!
    /// download Image
    @IBOutlet var downloadImage: UIImageView!
    /// download Label
    @IBOutlet var dowwnloadLabel: UILabel!
    /// Ads Views
    @IBOutlet var adsViews: UIView!
    /// Ads Video
    @IBOutlet var adsVideo: UIView!
    /// Ads Progress
    @IBOutlet var adsProgress: UIProgressView!
    /// Ads Play
    @IBOutlet var adsPlay: UIButton!
    /// Ads Full Screen Button
    @IBOutlet var adsFullScreen: UIButton!
    /// Pay wall view
    @IBOutlet var payWallView: UIView!
    /// Delegate
    weak var delegate: CSVideoDetailDelegate?
    /// Resolution Array
    var urlAndResolutionSets = [Any]()
    /// Is Mask shown
    var isMaskShowing = true
    // Delay Item
    open var adsDelayItem: DispatchWorkItem?
    /// Video Thumb Url
    var thumbNailString = String()
    /// Video Id
    var videoId = Int()
    /// Category ID
    var categoryId = "0"
    // videoDetailResponse
    var videoDetailResponse : VideoResponse!
    // price
    var isPrice = Double()
    // related Video
    var relatedVideo = [CSMovieData]()
    // Comment List
    var commentArray = [CommentsList]()
    // VideoURl
    var videoUrl = String()
    // SpriteURL
    var spriteUrl = String()
    // Sprite Image
    var spriteImage = UIImageView()
    // Subtitle
    var currentSub: CSSubTitle?
    /// is From PlayList page
    var isPlaylist = false
    /// is Follow
    var isFollow = Int()
    /// is From Live page
    var isLive = false
    /// is From web series
    var isWebSeries = Int()
    /// Video Description
    var videoDescription = String()
    /// Like To PLayBack
    var tableContentSize: NSKeyValueObservation?
    // Page Index
    var lastPage = 0
    // Current Index
    var currentPage = 0
    /// Download URL
    var downloadUrl = String()
    /// Pagination manger declaration
    var paginatioManager: PaginationManager!
    /// Horizontal Pagination manger declaration
    var horizontalPaginationManager: HorizontalPaginationManager!
    /// Season list
    var seasonList = [CSSeason]()
    /// Drop Down Value
    var seasonDropDownList = [String]()
    /// Shared Data
    var sharedData: CSSharedObject!
    /// is Premium Id
    var isPremiumVideo = 0
    /// is isBought Id
    var isBought = Int()
    /// Loader
    var isHorizontalLoader = false
    // Related Page Index
    var relatedLastPage = 0
    // Related Current Index
    var relatedCurrentPage = 0
    /// Timer For Live Video
    var timerVideo: Timer?
    /// keyTimer
    var videoKeyTimer: Timer?
    /// video Key
    var videoKey = Int64()
    var liveTime = Int()
    /// check expired
    var isExpired = false
    /// Tap Gesute
    var tapgesture: UITapGestureRecognizer!
    ///LiveChat controller
    var liveChatController: CSLiveChatViewController?
    // Delegateview
    @IBOutlet var customBmView: BMPlayerCustomControlView!
    //Delegate
    weak var customDelegate = BMPlayerCustomControlView()
    // View for showing Playbutton
    @IBOutlet var alertOptions: UIView!
    // view for shwoingAlert
    @IBOutlet var backgroundAlertview: UIView!
    // PlayNow Button
    @IBOutlet var playNowButton: UIButton!
    // Add to queue Button
    @IBOutlet var addQueue: UIButton!
    // UIimageview for poster view
    @IBOutlet var posterImg: UIImageView!
    @IBOutlet var staticTextLabel: [UILabel]!
    @IBOutlet var separatorLine: [UIView]!
    @IBOutlet var dynamicTextLabel: [UILabel]!
    var xrayTableView: UITableView = UITableView.init(frame: .zero)
    var xrayViewController: XRayViewController!
    var xrayTapgesture : UITapGestureRecognizer!
    @IBOutlet weak var xrayView: UIView!
    @IBOutlet weak var liveChatView: UIView!
    @IBOutlet weak var liveChatViewTop: NSLayoutConstraint!
    @IBOutlet weak var liveChatViewBottom: NSLayoutConstraint!
    @IBOutlet weak var CommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var PayWallStackView: UIStackView!
    var seasonListTap : UITapGestureRecognizer!
    var liveChatTapGesture: UITapGestureRecognizer!
    // sessionManager
    var sessionManager: GCKSessionManager!
    // mediaClient
    var mediaClient: GCKRemoteMediaClient!
    // castSession
    var castSession: GCKCastSession?
    // castMediaController
    var castMediaController: GCKUIMediaController!
    // playbackMode
    var playbackMode = PlaybackMode.none
    // showStreamTimeRemaining
    var showStreamTimeRemaining: Bool = false
    // localPlaybackImplicitlyPaused
    var localPlaybackImplicitlyPaused: Bool = false
    //Gradient
    var gradient: CAGradientLayer!
    // queueRequest
    var queueRequest: GCKRequest!
    /* Whether to reset the edges on disappearing. */
    var isResetEdgesOnDisappear: Bool = false
    // The media to play.
    var mediaInfo: GCKMediaInformation?
    //Device Name
    var deviceName: GCKDevice!
    //QueueList
    var queueList: GCKMediaQueue!
    // Scheduled Live Video
    var isScheduledLiveVideo = false
    // ------- Google Ads ------------- //
    // is Google Ads
    var isGoogleAds = false
    // Google Loader
    //var adsLoader: IMAAdsLoader?
    // Ads display Container
    //var displayController: IMAAdDisplayContainer?
    // Google Ads Manager
    //var adsManager: IMAAdsManager?
    // Google Ads Manager
    var isAdsStart = false
    // Google Ads Stream Manager
    //var adsStreamManager: IMAStreamManager?
    /// Is Played Till the End
    var isPlayedTitlEnd = false
    /// Google Content Play Head Google Ad Player
    //var contentPlayhead: IMAAVPlayerContentPlayhead?
    /// Is Reach half limit
    var isReachlimit = false
    /// is 15% played or not
    var isFifteenPrecent = false
    /// Transaction Id
    var transactionId: String!
    /// Xray Cast List
    var xrayCastInfos = Array<CastInfo>()
    var xrayResponse: XrayResponse!
    /// SetUp Pinch Gesture
    @objc var pinchGesture: UIPinchGestureRecognizer!
    // Variables to keep track of the scale
    var imageViewScale: CGFloat = 1.0
    // Maximum Scaling
    let maxScale: CGFloat = 3.0
    // Minimum scaling
    let minScale: CGFloat = 0.9
    // App test Ad Tag URl
    var kTestAppAdTagUrl = String()
    // Slug
    var currentSlug = String()
    // Last Time
    var lastTime: Double = 0.00
    // Total Time
    var totalDuration: Double = 0.00
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sessionManager = GCKCastContext.sharedInstance().sessionManager
        self.castMediaController = GCKUIMediaController()
    }
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        CommentViewHeight.constant = 0
        fencedContent.layer.masksToBounds = true
        fencedContent.layer.cornerRadius = 5.0
        self.playVideoButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { self.playVideoButton.isUserInteractionEnabled = true }
        playerImage.backgroundColor = UIColor.thumbnailDefaultColor
        self.sessionManager.add(self)
        chromecastIntialise(); addTabGesture()
        registerRefreshIndicator(); playListView(isFollow)
        addObserverToTable(); setDarkModeNeeds()
        commentTextView.textDelegate = self; self.showSkeleton()
        self.progressBar.maxValue = 100; self.progressBar.isHidden = true
        CSDownloadManager.shared.delegate = self; self.callApi()
        customDelegate = playerView.customControlView as? BMPlayerCustomControlView
        customDelegate?.customDelegate = self
        customDelegate?.chatButton.isHidden = true
        setupXrayTableView()
        setupLiveChatView()
        //setupTapgesture()
        // Create an ad request with our ad tag, display container, and optional user context.
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(willResignActive),
//            name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(didBecomeActive),
//            name: UIApplication.didBecomeActiveNotification, object: nil)
//        contentTopConstraint.constant = thumbnailView.bounds.size.height
//        setUpGestures()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        self.playerView.pause(allowAutoPlay: true)
        callWatchTime()
    }
    override func callApi() {
        payWallView.isHidden = true
        fetchVideoDetail()
        fetchXray()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let statusBar = UIApplication.shared.statusBarUIView
        adsFullScreen.isSelected = UIDevice.current.orientation.isLandscape
        if UIDevice.current.orientation.isLandscape {
            liveChatView.isHidden = (isLive && !isScheduledLiveVideo) ? true: true
            customDelegate?.chatButton.isHidden = isLive ? true : true
            if (customDelegate?.chatButton.isSelected)! {
                liveChatView?.isHidden = true
            }
            self.playerView.frame =  self.view.layer.bounds
            self.playerView.playerLayer?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            pinchGesture.isEnabled = true
            self.view.endEditing(true)
            statusBar?.isHidden = true
            changeOrentation(true)
        } else {
            customDelegate?.chatButton.isHidden = true
            liveChatView.isHidden = true
            self.playerView.playerLayer?.transform = CGAffineTransform(scaleX: 1, y: 1)
            pinchGesture.isEnabled = false
            statusBar?.isHidden = false
            changeOrentation(false)
//            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    @objc func pinchHandler(recognizer : UIPinchGestureRecognizer) {
        
        if recognizer.state == .began || recognizer.state == .changed {
            let pinchScale: CGFloat = recognizer.scale
            
            if imageViewScale * pinchScale < maxScale && imageViewScale * pinchScale > minScale {
                imageViewScale *= pinchScale
                self.playerView.playerLayer?.transform = ((self.playerView.playerLayer?.transform.scaledBy(x: pinchScale, y: pinchScale))!)
            }
            recognizer.scale = 1.0
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        NotificationCenter.default.removeObserver(
            self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(
            self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}
// MARK: - Button Action
extension CSVideoDetailViewController {
    /// Add Video To Facourite
    @IBAction func favouriteVideo(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() {
            playerView.pause(); self.addLoginCloseIfUserNotLogin(self)
            return }
        if favouriteButton.tag == 1 {
            removeFromFavouriteVideo(sender)
        } else { addToFavouriteVideo(sender) }
    }
    /// Save And Unsave Playlist
    @IBAction func savePlayList(_ sender: UIButton) {
        playerView.pause()
        if !UIApplication.isUserLoginInApplication() {
            self.addLoginCloseIfUserNotLogin(self)
            return }
        let addPlaylist = playListAndLatestStoryBoard.instantiateViewController(
            withIdentifier: "CSAddToPlaylistViewController") as? CSAddToPlaylistViewController
        addPlaylist?.videoId = self.videoId
        addPlaylist?.modalPresentationStyle = .overCurrentContext
        addPlaylist?.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(addPlaylist!, animated: true, completion: nil)
    }
    /// Save And Unsave Playlist
    @IBAction func buyButtonAction(_ sender: UIButton) {
        playerView.pause()
        if !UIApplication.isUserLoginInApplication() {
            self.addLoginCloseIfUserNotLogin(self)
            return }
        let chckoutDetails = subscriptionStoryBoard.instantiateViewController(withIdentifier: "CSPaymentOptionViewController") as? CSPaymentOptionViewController
        chckoutDetails?.videodetailContent = videoDetailResponse
        chckoutDetails?.controllerTitle = "Check Out"
        self.navigationController?.pushViewController(chckoutDetails!, animated: true)
    }
    /// Add Player On Button Click
    @IBAction func playerAddView(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() {
            let login = mainStoryBoard.instantiateViewController(withIdentifier:
                "CSLoginViewController") as? CSLoginViewController
            login?.hidesBottomBarWhenPushed = true
            login?.isFromVideoDetail = true
            self.navigationController?.pushViewController(login!, animated: true)
            return }
//        if isPremiumVideo == 1 && isPrice <= 0 {
//            setVideoPlayer()
//            return
//        }
        if isPremiumVideo == 1 && !LibraryAPI.sharedInstance.isUserSubscibed() && isBought == 0 {
            self.performSegue(withIdentifier: "SubscriptionPage", sender: nil)
            return }
        setVideoPlayer() }
    /// Read More Read Less Button Action
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (descriptionLabel.text)!
        if text.contains(NSLocalizedString("Read More", comment: "Video Detail")) {
            readLess()
        } else if text.contains(NSLocalizedString("Read Less", comment: "Video Detail")) {
            readMore() }
    }
    func navigateTopurchasePage() {
        let purchaseDetails = purchaselistStoryBoard.instantiateViewController(withIdentifier: "CSPurchaselistViewcontroller") as? CSPurchaselistViewcontroller
        self.navigationController?.pushViewController(purchaseDetails!, animated: true)
    }
}
