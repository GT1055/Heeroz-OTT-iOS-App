/*
 * HomePageViewController
 * This controller is used to display the Videos and Images in HomePage
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ImageSlideshow
import FirebasePerformance
import SkeletonView
import Alamofire
class HomePageViewController: CSParentViewController {
    /// Scroll View
    @IBOutlet var scrollView: UIScrollView!
    /// Layout Constant
    @IBOutlet var bannarHeight: NSLayoutConstraint!
    /// Banner Slider
    @IBOutlet var slideshow: ImageSlideshow!
    /// Table View Slider
    @IBOutlet var homeTableView: UITableView!
    /// Use to store offset Valuse
    var storedOffsets = [Int: CGFloat]()
    // MARK: - Outlets
    /// Bannar title
    @IBOutlet var bannarTitle: UILabel!
    /// Bannar Description
    @IBOutlet var bannarDescrption: UILabel!
    /// Bannar Premium Video
    @IBOutlet var premiumViewWidthConstant: NSLayoutConstraint!
    /// Bannar Premium Video View
    @IBOutlet var premiumView: UIView!
    /// Bannar Live Video
    @IBOutlet var liveViewWidthConstant: NSLayoutConstraint!
    /// Bannar Live Video View
    @IBOutlet var liveView: UIView!
    // Pagecontrol
    @IBOutlet weak var pageControl: UIPageControl!
    /// A variable to set the Number of sections
    @IBOutlet weak var headerViewHieghtConstant: NSLayoutConstraint!
    @IBOutlet weak var BannerPlayImage: UIButton!
    /// bannar Array data
    var homeDetailResponce: CSHomeResponce?=nil
    /// Movie Array
    var moviesArray = [CSMoviePagenation]()
    /// Index Path
    var currentIndexPath: IndexPath!
    /// Banner Detail List
    var bannerDetailList = [BannarDetailData]()
    /// Banner Detail List
    var currentBannerList = [CSBannerData]()
    /// banner response
    var bannerResponse: CSHomeResponce?=nil
    /// Horizontal Load More
    var isHorizontalLoader = false
    /// Currrent Language
    var currentLanguage = CSLanguage.currentAppleLanguage()
    /// New Category
    var newMovies: CSMoviePagenation?=nil
    
    var childcategoriesvideos:CSChildCategoryVideo?=nil
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // current Page
    var currentPage = 0
    var totalCategory : Int?
    var callmoreinApiFinishedLoading = false
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage = 1
        registerRefreshIndicator()
        callApi()
        CSAdMob.shared.requestInterstitialAds()
        self.changeOfLanguage()
        self.slideshow.superview?.showSkeletionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerRefreshIndicator()
        if self.islangauge(currentLanguage) { return }
        self.addGradientBackGround()
        self.chanageRefreshIndicator(refreshManager)
        self.homeTableView.reloadData()
        appDelegate?.isCastControlBarsEnabled = true
    }
    override func callApi() {
        super.callApi()
        self.childcategoriesvideos = nil
        self.newMovies = nil
        self.bannerResponse = nil
        self.homeDetailResponce = nil
        self.getBannarDetails()
        self.callTheAPIForLoadingData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        UIImageView.af_sharedImageDownloader.imageCache?.removeAllImages()
        UIImageView.af_sharedImageDownloader.sessionManager.session.configuration.urlCache?.removeAllCachedResponses()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.delegate = self
            controller?.parent?.hidesBottomBarWhenPushed = true
            if sender != nil {
                currentIndexPath = nil
                controller?.videoId = (sender as? Int)!
            } else {
                controller?.videoId =
                    self.moviesArray[currentIndexPath.section].movieList[currentIndexPath.row].movieId
            }
        }
    }
    func startSkeletonLoading() {
    }
    func stopSkeletonLoading() {
        slideshow.superview?.hideSkeleton()
    }
    /// Change Of Language
    func changeOfLanguage() {
        if currentLanguage != CSLanguage.currentAppleLanguage() {
            currentLanguage = CSLanguage.currentAppleLanguage()
            self.addGradientBackGround()
            self.chanageRefreshIndicator(refreshManager)
            self.homeTableView.reloadData()
        }
    }
    /// Banner init
    /// - Parameter alamofireImage: alamofire image sources
    func bannerInit(_ bannarData: [CSMovieData]) {
        var alamofireImage = [InputSource]()
        var detailList = [BannarDetailData]()
        for banner in bannarData {
            let bannarDetailData = BannarDetailData()
            bannarDetailData.name = banner.title
            bannarDetailData.bannnerId = banner.movieId
            bannarDetailData.videoId = banner.videoId
            bannarDetailData.slug = banner.slug
            bannarDetailData.bannerVideoUrl = banner.videoUrl
            bannarDetailData.isPremium = banner.isPremium
            bannarDetailData.isLive = banner.isLive
            if banner.slug.isEmpty
            {
                BannerPlayImage.isHidden = true
            }else{
                BannerPlayImage.isHidden = false
            }
            if !banner.bannerImage.isEmpty {
                bannarDetailData.image = banner.bannerImage
            } else {
                bannarDetailData.image = banner.thumbNailImage
            }
            bannarDetailData.description = banner.description.removeHtmlFromString()
            detailList.append(bannarDetailData)
            if !bannarDetailData.image.isEmpty {
                let imageString: String = bannarDetailData.image.addingPercentEncoding(withAllowedCharacters:
                    NSCharacterSet.urlQueryAllowed)!
                let url = URL(string: imageString)
                alamofireImage.append(AlamofireSource.init(url: url!))
            } else {
                let imafes = UIImage.init(color: .backgroundColor())!
                alamofireImage.append(ImageSource(image: imafes))
            }
        }
        self.bannerDetailList = detailList
        bannarHeight.constant = self.bannerDetailList.count == 0 ?
            0 : UIScreen.main.bounds.width * 9/16
        slideshow.superview?.isHidden = false
        if bannarHeight.constant == 0 {
            slideshow.superview?.isHidden = true
        }
        self.isPremiumBannar(0, isLive: 0)
        if let bannar = self.bannerDetailList.first {
            bannarTitle.text = bannar.name
            self.isPremiumBannar(bannar.isPremium, isLive: bannar.isLive)
        }
        /// Banner initia
        self.bannerImageSider(alamofireSource: alamofireImage)
    }
    /// Banner Image Slider
    /// - Parameter alamofireSource: alamofire as! input
    func bannerImageSider(alamofireSource: [InputSource]) {
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5
        slideshow.pageIndicator = nil
        slideshow.circular = true
        // pageControl.isHidden = true
        // pageControl.numberOfPages = alamofireSource.count
        slideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            self.bannarTitle.text = self.bannerDetailList[page].name
            self.BannerPlayImage.isHidden = self.bannerDetailList[page].slug.isEmpty
            // self.pageControl.currentPage = page
            self.isPremiumBannar(self.bannerDetailList[page].isPremium,
                                 isLive: self.bannerDetailList[page].isLive)
        }
        slideshow.setImageInputs(alamofireSource)
    }
    func isPremiumBannar(_ isShow: Int, isLive: Int) {
        premiumViewWidthConstant.constant = isShow == 1 ? 60 : 0
        premiumView.isHidden = true
        liveViewWidthConstant.constant = isLive == 1 ? 50 : 0
        liveView.isHidden = isLive == 1 ? false : true
    }
    func backupdataSetToHomePage(_ data: CSHomeResponce) {
        self.homeDetailResponce = data
        self.totalCategory = data.totalmaincategory
        self.moviesArray = [CSMoviePagenation]()
        guard let newmov = self.newMovies else {return}
        guard let newmovie = self.homeDetailResponce else {return}
        if newmov.movieList.count > 0 {
            if newmov.categoryName != "New on Heeroz" {
                self.moviesArray.append(newmov)
            }
        }
//        for movie in newmovie.homePage where movie.movieList.count > 0 {
//            self.moviesArray.append(movie)
//        }
        for video in newmovie.homePage {
            for movie in video.childcategoryvideo.categoryvideos where movie.home_page_active == 1 && movie.videolist.movieList.isEmpty == false
            {
                let vid = video.childcategoryvideo
                if let videodata = movie.videolist, vid!.categoryvideos.count > 0 {
                    videodata.categoryName = movie.title
                    videodata.categoryBanner = movie.child_category_banner
                    self.moviesArray.append(videodata)
                }
                
            }
        }
//        if self.moviesArray.count < 1 {
//            self.addChildView(identifier: "CSRecordView", storyBoard: alertStoryBoard)
//            return
//        }
        // settingsData(data.statistics)
        self.homeTableView.reloadData()
        self.homeTableView.layoutIfNeeded()
        self.headerViewHieghtConstant.constant = self.homeTableView.contentSize.height
    }
    func backupdataSetToHomePageMore(_ data: CSHomeResponce) {
        
        for movie in data.homePage where movie.movieList.count > 0 && movie.homepageactive == 1
        {
            self.moviesArray.append(movie)
        }
        for video in data.homePage where video.movieList.count > 0 {
            for movie in video.childcategoryvideo.categoryvideos where movie.home_page_active == 1 && movie.videolist.movieList.isEmpty == false
            {
                let vid = video.childcategoryvideo
                if let videodata = movie.videolist, vid!.categoryvideos.count > 0 {
                    videodata.categoryName = movie.title
                    videodata.categoryBanner = movie.child_category_banner
                    self.moviesArray.append(videodata)
                }
            }
        }
        self.homeTableView.reloadData()
        self.homeTableView.layoutIfNeeded()
        self.headerViewHieghtConstant.constant = self.homeTableView.contentSize.height
    }
    /// Data Set To Home Page
    func dataSetToHomePage(_ data: CSHomeResponce) {
        self.homeDetailResponce = data
        self.totalCategory = data.totalmaincategory
        self.moviesArray = [CSMoviePagenation]()
        if let homeResponse = self.homeDetailResponce {
            for movie in homeResponse.homePage {
                if movie.movieList.count > 0 && movie.homepageactive == 1 {
                    self.moviesArray.append(movie)
                }
                for category in movie.childcategoryvideo.categoryvideos {
                    if category.home_page_active == 1 && !category.videolist.movieList.isEmpty {
                        category.videolist.categoryName = category.title
                        category.videolist.categoryBanner = category.child_category_banner
                        self.moviesArray.append(category.videolist)
                    }
                }
            }
        }
        self.homeTableView.reloadData()
        self.homeTableView.layoutIfNeeded()
        self.headerViewHieghtConstant.constant = self.homeTableView.contentSize.height
    }
    func dataSetToHomePageMore(_ data: CSHomeResponce) {
        for movie in data.homePage {
            if movie.movieList.count > 0 && movie.homepageactive == 1 {
                self.moviesArray.append(movie)
            }
            for category in movie.childcategoryvideo.categoryvideos {
                if category.home_page_active == 1 && !category.videolist.movieList.isEmpty {
                    category.videolist.categoryName = category.title
                    category.videolist.categoryBanner = category.child_category_banner
                    self.moviesArray.append(category.videolist)
                }
                
            }
        }
        self.homeTableView.reloadData()
        self.homeTableView.layoutIfNeeded()
        self.headerViewHieghtConstant.constant = self.homeTableView.contentSize.height
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.scrollView, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Setting Data
    func settingsData(_ staticsData: CSStatistics) {
        LibraryAPI.sharedInstance.setUserDefaults(key: "planName", value: staticsData.subscribedPlan.planName)
    }
}
// MARK: - Bannaer Selection, Button Action For Favourite Video, Follow Playlist
extension HomePageViewController {
    /// View All Button Action
    @objc func viewFullVideoInSection(_ sender: UIButton) {
        self.performSegue(withIdentifier: "videoListMore", sender: sender.tag)
    }
    /// Banner selected Functionality
    @IBAction func selecetdidBannerSelected() {
        if bannerDetailList[slideshow.currentPage].slug.isEmpty{
            
        }else{
            if bannerDetailList.count > 0 {
                self.performSegue(withIdentifier: "videoDetail",
                                  sender: bannerDetailList[slideshow.currentPage].videoId)
            }
        }
    }
}
// MARK: - Pull to Refresh
extension HomePageViewController: PullToRefreshManagerDelegate {
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.currentPage = 1
            self.callApi()
        }
    }
}
// MARK: - API Request
extension HomePageViewController {
    // call api To Take Home More page Data
    func callTheAPIForHomePageMoreLoadingData() {
        ///Adding Loader
        CSHomeApiModel.homePageMoreApiRequest(parentView: self,
                                              parameters: nil, buttonObject: currentPage,
                                      completionHandler: {[unowned self] response in
                                        guard let homedetail = self.homeDetailResponce else {return}
                                        self.totalCategory = homedetail.totalmaincategory
                                        self.dataSetToHomePageMore(response.responseRequired)
        })
    }
    
    // call api To Take Home page Data
    func callTheAPIForLoadingData() {
        ///Adding Loader
        CSHomeApiModel.homeApiRequest(parentView: self,
                                      parameters: nil,
                                      completionHandler: { [unowned self] response in
                                        self.dataSetToHomePage(response.responseRequired)
                                        self.currentPage = 1
                                        self.callTheAPIForHomePageMoreLoadingData()
        })
    }
    // call api To Take Home page Data
    func slugVideoId(_ id: String) {
        CSHomeApiModel.SlugVideoId(parentView: self,
                                      parameters: nil,
                                      slugid: id,
                                      completionHandler: { response in
                                        self.dataSetToSlugId(response.slugVideoResponce)
        })
//    Alamofire.request("https://vplayed-catrack-uat.contus.us/medias/api/v2/getVideoId/sikander-yaaran-da-yaar-heeroz", method: .get)
//       .validate()
//       .responseData(completionHandler: { (responseData) in
//        //Convert my response data to string
//        let content = String(data: (responseData.result.value)!, encoding: String.Encoding.utf8)
//        print("SLUG ID ***************")
//        print(content as! String)
//       })
    }
    // Get Bannar Details
    func dataSetToSlugId(_ data: CSSlugVideoKey){
        print(data.id)
        self.performSegue(withIdentifier: "videoDetail", sender: data.id)
    }
    func getBannarDetails() {
        CSHomeApiModel.homeBannarApiRequest(parentView: self,
                                            parameters: nil,
                                            completionHandler: { [unowned self] response in
                                                self.bannerResponse = response.responseRequired
                                                self.setBannarData(response.responseRequired)
        })
    }
    func setBannarData(_ data: CSHomeResponce) {
        slideshow.superview?.isHidden = false
        if let bannar = data.bannar, bannar.movieList.count > 0 {
            self.bannerInit(bannar.movieList)
        } else {
            bannarHeight.constant = self.bannerDetailList.count == 0 ?
                0 : UIScreen.main.bounds.width * 9/16
            self.isPremiumBannar(0, isLive: 0)
        }
    }
    // Load More Videos In Pagination
    func callRecentVideos(_ index: Int) {
        isHorizontalLoader = true
        /// Setting Parameter to Api
        let paramet: [String: String] = [
            "type": self.moviesArray[index].type,
            "page": String(self.moviesArray[index].currentPage + 1)
        ]
        CSVideoDetailApiModel.fetchRecentAndTrending(
            parentView: self,
            parameters: paramet,
            isPageDisable: 2.checkPageNeed(),
            completionHandler: { responce in
                self.moviesArray[index].currentPage = responce.homePageMovieMore.currentPage
                self.moviesArray[index].lastPage = responce.homePageMovieMore.lastPage
                self.moviesArray[index].movieList += responce.homePageMovieMore.movieList
                if let cell = self.homeTableView.cellForRow(at: IndexPath.init(row: index, section: 0))
                    as? CSHomeTableViewCell {
                    cell.collectionView.reloadData()
                }
                DispatchQueue.main.asyncAfter(
                    deadline: DispatchTime.now() + 0.8, execute: {
                        self.isHorizontalLoader = false
                })
        })
    }
}
// MARK: - Favourite Session
extension HomePageViewController: CSVideoDetailDelegate {
    func favouriteDelegate(_ favourite: Int, videoId: Int) {
        if currentIndexPath == nil { return }
        moviesArray[currentIndexPath!.section].movieList[currentIndexPath!.row].isFavourite = favourite
    }
}
// MARK: - vertical pagenation for
extension HomePageViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callTheAPIForHomePageMoreLoadingData()
        }
    }
    /// Check is Pagination Needed
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if let total = totalCategory
        {
            if currentPage > total - 1 {
                return false
            }
        }
        return true
    }
}
