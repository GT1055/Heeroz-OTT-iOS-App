/*
 * CSLiveViewController
 * This Controller is used to display the Live videos
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ImageSlideshow
class CSLiveViewController: CSParentViewController, UIGestureRecognizerDelegate {
    // MARK: - Outlets
    // An Outlet to display the Live Scroll View
    @IBOutlet var liveScrollView: UIScrollView!
    // An Outlet to display the Live Now Label
    @IBOutlet var livenowLabel: UILabel!
    // An Outlet to display the Live Scroll View
    @IBOutlet var bannarView: UIView!
    // An Outlet to display to show Bannar Height
    @IBOutlet var bannarHeight: NSLayoutConstraint!
    /// Live Collection Data Source
    @IBOutlet var liveCollectionData: CSLiveCollectionDataSources!
    /// A variable to set the Number of sections
    @IBOutlet weak var liveTableHConstantraint: NSLayoutConstraint!
    /// A variable to set the Number of sections
    @IBOutlet weak var liveCollectionHConstantraint: NSLayoutConstraint!
    /// Banner Slider
    @IBOutlet var slideshow: ImageSlideshow!
    /// Bannar title
    @IBOutlet var bannarTitle: UILabel!
    /// Bannar Description
    @IBOutlet var bannarDescrption: UILabel!
    /// Bannar Premium Video View
    @IBOutlet var liveView: UIView!
    // An Outlet to display the Live Videos
    @IBOutlet var liveCollectionView: UICollectionView!
    // Live Table View
    @IBOutlet var liveTableView: UITableView!
    // An Player View
    @IBOutlet var playerView: BMCustomPlayer!
    // An Player View
    @IBOutlet var thumbNailImage: UIImageView!
    /// Use to store offset Valuse
    var storedOffsets = [Int: CGFloat]()
    // MARK: - Data type declaration
    var liveVideoData: LiveVideosArray!
    // MARK: - Data type declaration
    var liveVideoList = [LiveVideoListArray]()
    /// Banner Detail List
    var bannerDetailList = [BannarDetailData]()
    /// Banner Detail List
    var csbannerDetailList = [CSBannerData]()
    /// Horizontal Load More
    var isHorizontalLoader = false
    /// Horizontal Load More
    var currentSelectedBannar: UpcomingliveVideosList!
    /// Current Language
    var currentLanguage = CSLanguage.currentAppleLanguage()
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Resolution Array
    var urlAndResolutionSets = [Any]()
    /// Livechatview
    @IBOutlet weak var liveChatView: UIView?
    /// Live chat constraints
    @IBOutlet weak var liveChatViewTop: NSLayoutConstraint!
    @IBOutlet weak var liveChatViewBottom: NSLayoutConstraint!
    /// Livechat TAp Gesture
     var liveChatTapGesture: UITapGestureRecognizer!
    //Delegate
     var delegate = BMPlayerCustomControlView()
    ///LiveChat controller
    var liveChatController : CSLiveChatViewController?
    var currentIndex = 0
    // MARK: - UIViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = (playerView.customControlView as? BMPlayerCustomControlView)!
        self.delegate.customDelegate = self
        registerRefreshIndicator()
        self.callApi()
        changeLanguage()
        setupLiveChatView()
        self.slideshow.superview?.showSkeletionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bannarView.isHidden = false
        liveChatView?.isHidden = true
        self.livenowLabel.textColor = UIColor.invertColor(true)
        setLiveViewComponents()
        thumbNailImage.backgroundColor = UIColor.thumbnailDefaultColor
        if self.islangauge(currentLanguage) { return }
        addGradientBackGround()
        chanageRefreshIndicator(refreshManager)
        self.liveCollectionView.reloadData()
        self.liveTableView.reloadData()
        addPlayerLayer()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.liveChatController?.scrolltoBottom()
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
         playerViewable.swipeRightview.isHidden = true
         playerViewable.swipeLeftview.isHidden = true
        }
    }
    override func callApi() {
        /// Call Live Api Integration
        self.liveVideoRequest()
    }
    func stopSkeletonLoading() {
        slideshow.superview?.hideSkeleton()
    }
    func setLiveViewComponents() {
        if LibraryAPI.sharedInstance.getUserImageUrl().isEmpty {
            liveChatController?.profileImage?.image = UIImage.init(named: "placeholder")
        } else {
            liveChatController?.profileImage?.setImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
        }
        liveChatController?.textField.placeholder = LibraryAPI.sharedInstance.getUserName().isEmpty ? "Login to Enjoy Live Chat" : "Chat as \(LibraryAPI.sharedInstance.getUserName())"
        liveChatController?.textField.placeHolderColor = UIColor.lightGray
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "liveVideoDetail" {
            let index = (sender as? Int)!
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.videoId = index
            LibraryAPI.sharedInstance.setUserDefaults(key: "videoId", value: String(index))
        }
//        if segue.identifier == "toLive" {
//            let dest = segue.destination as! CSLiveChatViewController
//            self.liveChatController = dest
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        bannarView.isHidden = false
        if playerView != nil {
            playerView.isHidden = true
            playerView.pause()
            playerView.avPlayer?.replaceCurrentItem(with: nil)
        }
    }
    func changeLanguage() {
        if currentLanguage != CSLanguage.currentAppleLanguage() {
            currentLanguage = CSLanguage.currentAppleLanguage()
            addGradientBackGround()
            chanageRefreshIndicator(refreshManager)
        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let statusBar = UIApplication.shared.statusBarUIView
        if UIDevice.current.orientation.isLandscape {
            self.liveChatController?.scrolltoBottom()
            if self.delegate.isplayerPlaying {
            liveChatView?.isHidden = false
            self.delegate.chatButton.isHidden = true
            }
            if self.delegate.chatButton.isSelected {
                liveChatView?.isHidden = true
            }
            self.view.endEditing(true); statusBar?.isHidden = true;
            //changeOrentation(true)
        } else {
            liveChatView?.isHidden = true
            self.delegate.chatButton.isHidden = true
            statusBar?.isHidden = false; //changeOrentation(false)
//            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}
// MARK: - Button Action Method
extension CSLiveViewController {
    /// Banner selected Functionality
    @IBAction func selecetdidBannerSelected() {
        setVideoPlayer()
    }
}
// MARK: - Private Method
extension CSLiveViewController {
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.liveScrollView, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    func isPremiumBannar(_ isShow: Int) {
        liveView.isHidden = isShow == 1 ? false : true
    }
    /// Load Data
    func loadData() {
        if self.liveVideoList.count > 0 {
            self.liveTableView.delegate = self
            self.liveTableView.dataSource = self
            self.liveTableView.reloadData()
            self.liveTableView.layoutIfNeeded()
            liveTableHConstantraint.constant = self.liveTableView.contentSize.height
        } else {
            self.liveTableHConstantraint.constant = 0
        }
        if self.liveVideoList.count < 0 && self.liveVideoData.currentLiveVideos.count < 0 {
            self.addChildView(identifier: "NoLive", storyBoard: alertStoryBoard)
        }
    }
    /// Set Bannar Data
//    func setBannarData() {
//        self.bannarTitle.text = currentSelectedBannar.title
//        self.bannarDescrption.text = currentSelectedBannar.description
//        self.thumbNailImage.setImageWithUrl(currentSelectedBannar.posterImage)
//        self.isPremiumBannar(currentSelectedBannar.isPremium)
//    }
    /// Check Count For Table
    func addDataToArray() {
        self.liveVideoList = [LiveVideoListArray]()
        if self.liveVideoData.currentLiveVideos.count > 0 {
            liveCollectionData.liveVideoArray = self.liveVideoData.currentLiveVideos
            liveCollectionData.delegate = self
            liveCollectionView.allowsSelection = false
            liveCollectionView.reloadData()
            liveCollectionView.layoutIfNeeded()
            if let data = self.liveCollectionData.liveVideoArray.first {
                currentSelectedBannar = data
                //self.setBannarData()
            }
            self.liveCollectionHConstantraint.constant = liveCollectionView.contentSize.height
        } else {
            self.liveCollectionHConstantraint.constant = 0
        }
        if self.liveVideoData.todayLiveVideos.count > 0 {
            let todayVideoList = LiveVideoListArray()
            todayVideoList.liveVideoTitle = NSLocalizedString("Todays Live", comment: "live")
            todayVideoList.slug = "todaynow"
            todayVideoList.liveVideoArray = self.liveVideoData.todayLiveVideos
            self.liveVideoList.append(todayVideoList)
        }
        if let upComeingLive = self.liveVideoData.upcomingvideo, upComeingLive.upComingData.count > 0 {
            let upComeingList = LiveVideoListArray()
            upComeingList.liveVideoTitle = NSLocalizedString("Upcoming Live", comment: "live")
            upComeingList.slug = "Upcomingnow"
            upComeingList.currentPage = self.liveVideoData.upcomingvideo.currentPage
            upComeingList.lastPage = self.liveVideoData.upcomingvideo.lastPage
            upComeingList.liveVideoArray = upComeingLive.upComingData
            self.liveVideoList.append(upComeingList)
        }
        self.loadData()
    }
}
// MARK: - Pull to Refresh
extension CSLiveViewController: PullToRefreshManagerDelegate {
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApi()
        }
    }
}
// MARK: - Api Request
extension CSLiveViewController {
    /// Api For Live Videos
    func liveVideoRequest() {
        view.showSkeletionView()
        CSliveModelApi.fetchLiveVideosRequest(
            parentView: self,
            parameters: nil,
            completionHandler: { response in
                self.liveVideoData = response.requriedResponce
                self.addDataToArray()
                self.view.hideSkeleton()
        })
    }
    /// Fetch All Live Videos
    func fetchMoreLiveVideos(_ index: Int) {
        isHorizontalLoader = true
        let parameter = ["page": String(self.liveVideoList[index].currentPage + 1)]
        CSliveModelApi.fetchMoreLiveVideosRequest(
            parentView: self,
            parameters: parameter,
            isPageDisable: true,
            completionHandler: { responces in
                self.liveVideoList[index].liveVideoArray += responces.requriedResponce.upcomingvideo.upComingData
                self.liveVideoList[index].currentPage = responces.requriedResponce.upcomingvideo.currentPage
                self.liveVideoList[index].lastPage = responces.requriedResponce.upcomingvideo.lastPage
                self.liveCollectionView.reloadData()
        })
    }
}
extension CSLiveViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addPlayerFunctionaly(indexPath.row)
    }
    /// Add Player Functionality
    func addPlayerFunctionaly(_ index: Int) {
        self.playerView.avPlayer?.replaceCurrentItem(with: nil)
        if self.liveCollectionData.liveVideoArray.count == 0 { return }
        currentSelectedBannar = self.liveCollectionData.liveVideoArray[index]
        LibraryAPI.sharedInstance.setUserDefaults(key: "videoId", value: String(currentSelectedBannar.idData))
        if self.liveCollectionData.liveVideoArray[index].isPremium == 1 && !LibraryAPI.sharedInstance.isUserSubscibed() {
            self.moveToLiveDetail(index)
            return
        }
        //self.setBannarData()
        setVideoPlayer()
//        let id = self.liveCollectionData.liveVideoArray[index].idData
//        liveChatController?.videoId = id
//        liveChatController?.messages = []
//        liveChatController?.configureDatabase(videoId: id)
//        liveChatController?.clientTable.reloadData()
//        liveChatController?.scrolltoBottom()
    }
    /// Set Url Video Player
    func setVideoPlayer() {
        let playlistString: String = currentSelectedBannar.playlistURL.addingPercentEncoding(withAllowedCharacters:
            NSCharacterSet.urlQueryAllowed)!
        CSVideoDetailApiModel.setPlayerUrlResolution(
            parentView: self,
            url: playlistString) {(response) in
                self.liveChatController?.videoId = self.currentSelectedBannar.idData
                self.liveChatController?.messages = []
                self.liveChatController?.observe = false
                self.liveChatController?.loadobserve = false
                self.liveChatController?.configureDatabase(videoId: self.currentSelectedBannar.idData)
                self.liveChatController?.clientTable.reloadData()
                self.liveChatController?.scrolltoBottom()
                self.urlAndResolutionSets = response
                self.preparePlayerItem()
        }
    }
    // Live Detail Page
    func moveToLiveDetail(_ index: Int) {
        if CSAdMob.shared.interstitial.isReady {
            CSAdMob.shared.delegate = self
            currentIndex = index
            CSAdMob.shared.interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            self.performSegue(withIdentifier: "liveVideoDetail",
                              sender: self.liveCollectionData.liveVideoArray[index].idData)
        }
    }
}
extension CSLiveViewController: CSAdMobDelegate {
    func didAdDismissed() {
        self.performSegue(withIdentifier: "liveVideoDetail",
                          sender: self.liveCollectionData.liveVideoArray[currentIndex].idData)
    }
}
// MARK: - Player Height
extension CSLiveViewController {
    /// Add Player Layer
    func addPlayerLayer() {
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            playerViewable.isLive = true
            playerViewable.isLiveController = true
            BMPlayerConf.enablePlaytimeGestures = false
            playerViewable.setHideViewForLive()
        }
    }
    // PLayer Item
    func preparePlayerItem() {
        /// Resolution protocol to pass the resolution
        playerView.delegate = self
        var bitRateResource = [BMPlayerResourceDefinition]()
        for  index in 0..<self.urlAndResolutionSets.count {
            if let data = self.urlAndResolutionSets[index] as? CSVideoUrlResponse {
                let resource = BMPlayerResourceDefinition(url: data.resulotionUrl,
                                                          definition: data.quality,
                                                          options: nil)
                bitRateResource.append(resource)
            }
        }
        let asset = BMPlayerResource(name: currentSelectedBannar.title,
                                     definitions: bitRateResource,
                                     cover: URL.init(string: currentSelectedBannar.posterImage),
                                     subtitles: nil)
        playerView.isHidden = false
        bannarView.isHidden = true
        addPlayerLayer()
        // Back button event
        playerView.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            _ = self.navigationController?.popViewController(animated: true)
        }
        playerView.setVideo(resource: asset)
    }
    /// Detect Change of Orientation
    func changeOrentation(_ isFullscreen: Bool) {
        playerView.snp.remakeConstraints { (make) in
            if !isFullscreen {
                if UIScreen.main.nativeBounds.height == 2436 ||
                    UIScreen.main.nativeBounds.height == 2688 ||
                    UIScreen.main.nativeBounds.height == 1624 {
                    make.top.equalTo(view.snp.top).offset(100)
                } else {
                    make.top.equalTo(view.snp.top).offset(80)
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
}
public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
