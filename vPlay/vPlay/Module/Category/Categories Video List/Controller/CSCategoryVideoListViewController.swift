/*
 * CSCateoryViewController.swift
 * This class is used to view all the category present in this application
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import GoogleCast
class CSCategoryVideoListViewController: CSParentViewController {
    /// Category Table
    @IBOutlet var categoryTable: UITableView!
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    /// bannar Array data
    var homeDetailResponce: CSHomeResponce?=nil
    /// Movie Array
    var moviesArray = [CSMoviePagenation]()
    /// Movie Array
    var categoryArray = [CSCategoryVideoList]()
    /// video ID
    var categoryId = 0
    /// Selecte Category ID
    var selectedCategoryId = 0
    /// video Id
    var videoId = 0
    // Current Page
    var currentPage = 0
    // Last Page
    var lastPage = 0
    /// Horizontal Load More
    var isHorizontalLoader = false
    /// Use to store offset Valuse
    var storedOffsets = [Int: CGFloat]()
    /// Web series
    var isWebSeries = Int()
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        registerRefreshIndicator()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        callApi()
    }
    override func callApi() {
        super.callApi()
        self.homeDetailResponce = nil
        currentPage = 1
        // callTheAPIForLoadingData()
        callTheAPIForSectionTwo()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.videoId = videoId
            controller?.isWebSeries = isWebSeries
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        UIImageView.af_sharedImageDownloader.imageCache?.removeAllImages()
        UIImageView.af_sharedImageDownloader.sessionManager.session.configuration.urlCache?.removeAllCachedResponses()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.homeDetailResponce = nil
        self.moviesArray.removeAll()
        self.categoryArray.removeAll()
    }
}
// MARK: - Private Method
extension CSCategoryVideoListViewController {
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
    /// Reload Data
    func reloadData() {
        if self.moviesArray.count < 1 {
            self.addChildView(identifier: "NoCategory", storyBoard: alertStoryBoard)
            return
        }
        categoryTable.reloadData()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        categoryTable.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.categoryTable, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.categoryTable, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Check Count For Table
    func addDataToArray() {
        guard let homeResponse = homeDetailResponce else {return}
        self.isWebSeries = homeResponse.isWebSeries
        // New on Categories
//        for video in self.homeDetailResponce.mainVideoList {
//            if let videodata = video.videoList, videodata.movieList.count > 0 && video.slug == "new"{
//                videodata.title = video.title
//                self.moviesArray.append(videodata)
//            }
//        }
        for video in homeResponse.mainVideoList {
            if let videodata = video.videoList, videodata.movieList.count > 0 && video.categorypageactive != 0 {
                videodata.title = video.title
                videodata.slug = video.slug
                videodata.categoryId = self.categoryId
                videodata.categoryBanner = video.categoryBanner
                self.moviesArray.append(videodata)
            }
        }
        for video in homeResponse.categoryVideoList {
            if let videodata = video.videoList, videodata.movieList.count > 0 && video.categorypageactive == 1
            {
                videodata.title = video.title
                videodata.slug = "category"
                videodata.categoryId = video.categroyId
                videodata.categoryBanner = video.categoryBanner
                videodata.categoryBanner = video.childcategorybanner
                self.moviesArray.append(videodata)
            }
        }
        for video in homeResponse.generVideoList {
            if let videodata = video.videoList, videodata.movieList.count > 0 {
                videodata.title = video.name
                videodata.slug = "genre"
                videodata.categoryId = video.categroyId
                videodata.categoryBanner = video.categoryBanner
                self.moviesArray.append(videodata)
            }
        }
        // reloadData()
    }
}
// MARK: - Api Request Method's
extension CSCategoryVideoListViewController {
    // call api To Take Home page Data
    func callTheAPIForLoadingData() {
        let parameter: [String: String] = ["category": String(categoryId),
                                           "is_web_series": String(isWebSeries)]
        CSCategoryApiModel.getCategoryVideoList(parentView: self,
                                                parameters: parameter,
                                                isPaging: currentPage.checkPageNeed(),
                                                completionHandler: { [unowned self] response in
                                                    self.homeDetailResponce = response.responseRequired
                                                    self.moviesArray = [CSMoviePagenation]()
                                                    self.addDataToArray()
                                                    self.callTheAPIForSectionTwo()
        })
    }
    // call api For section two
    func callTheAPIForSectionTwo() {
        let parameter: [String: String] = ["category": String(categoryId),
                                           "section": "2",
                                           "is_web_series": String(isWebSeries)]
        CSCategoryApiModel.getCategoryVideoList(parentView: self,
                                                parameters: parameter,
                                                isPaging: false,
                                                completionHandler: { [unowned self] response in
                                                    self.homeDetailResponce = response.responseRequired
                                                    self.addDataToArray()
                                                    self.reloadData()
        })
    }
    // Load More Videos In Pagination
    func callRecentVideos(_ index: Int) {
        isHorizontalLoader = true
        /// Setting Parameter to Api
        var paramet: [String: String] = [
            "type": self.moviesArray[index].slug,
            "page": String(self.moviesArray[index].currentPage + 1),
            "is_web_series": String(isWebSeries)
        ]
        if self.moviesArray[index].slug.lowercased() == "genre".lowercased() {
            paramet["genre"] = String(self.moviesArray[index].categoryId)
            paramet["category"] = String(self.categoryId)
        } else {
            paramet["category"] = String(self.moviesArray[index].categoryId)
        }
        CSCategoryApiModel.getCategoryMoreVideoList(
            parentView: self,
            parameters: paramet,
            isPaging: (self.moviesArray[index].currentPage + 1).checkPageNeed(),
            completionHandler: { response in
                self.moviesArray[index].movieList +=
                    response.responseRequired.moreCategoryVideoList.videoList.movieList
                self.moviesArray[index].lastPage =
                    response.responseRequired.moreCategoryVideoList.videoList.lastPage
                self.moviesArray[index].currentPage =
                    response.responseRequired.moreCategoryVideoList.videoList.currentPage
                if let cell = self.categoryTable.cellForRow(at: IndexPath.init(row: index, section: 0))
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

// MARK: - Pull to Refresh
extension CSCategoryVideoListViewController: PullToRefreshManagerDelegate {
    /// Pull to refresh Manager start Method
    public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager,
                                                    onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApi()
        }
    }
}
// MARK: - vertical pagenation for
extension CSCategoryVideoListViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callTheAPIForLoadingData()
        }
    }
    /// Check is Pagination Needed
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > self.lastPage {
            return false
        }
        return true
    }
}
