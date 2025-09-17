/*
 * CSRelateAndTrendingViewController.swift
 * This class is used to Display All the recent video, popular and other's
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSRelateAndTrendingViewController: CSParentViewController {
    /// Related And Trending Collection
    @IBOutlet var relateAndTrendingCollection: UICollectionView!
    /// Related And Trending Collection Data Source's
    @IBOutlet var relateAndTrendingCollectionDataSource: CSRelatedCollectionDataSources!
    /// details
    var type = String()
    // Page Index
    var lastPage = 0
    // Current Index
    var currentPage = 0
    /// Movie Data
    var movieData = [CSMovieData]()
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // MARK: - UIView Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        registerRefreshIndicator()
        setupNavigation()
        self.callApi()
        // Do any additional setup after loading the view.
    }
    override func callApi() {
        currentPage = 1
        self.movieData = [CSMovieData]()
        self.callRecentVideos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSVideoDetailViewController {
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.delegate = self
            let index = (sender as? Int)!
            controller?.videoId = movieData[index].movieId
            controller?.controllerTitle = movieData[index].title
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - Delegate Methods
extension CSRelateAndTrendingViewController: CSVideoDetailDelegate {
    func favouriteDelegate(_ favourite: Int, videoId: Int) {
        let index = self.relateAndTrendingCollectionDataSource.movieData.firstIndex(where: { $0.movieId == videoId })
        self.relateAndTrendingCollectionDataSource.movieData[index!].isFavourite = favourite
        self.movieData[index!].isFavourite = favourite
        if let cell = self.relateAndTrendingCollection.cellForItem(at:
            IndexPath(row: index!, section: 0)) as? HomeCollectionViewCell {
            cell.checkVideoFavourite(favourite)
        }
    }
}
// MARK: - Private Method Data
extension CSRelateAndTrendingViewController {
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.relateAndTrendingCollection, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.relateAndTrendingCollection, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    // Bind Data To Recent
    func bindDataToRecent() {
        relateAndTrendingCollectionDataSource.delegate = self
        self.relateAndTrendingCollectionDataSource.movieData = self.movieData
        self.relateAndTrendingCollection.reloadData()
    }
}
// MARK: - Button Action
extension CSRelateAndTrendingViewController {
    /// Set Favourite
    @IBAction func shareAndFavourite(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() {
            self.addLoginCloseIfUserNotLogin(self)
            return
        }
    }
    /// Open Option Button
    @IBAction func openOptionButton(_ sender: UIButton) {
        let parameter: [String: String] =
            ["videoSlug": self.movieData[sender.tag].slug,
             "videoId": String(self.movieData[sender.tag].movieId),
             "videoImage": self.movieData[sender.tag].posterImage,
             "videoTitle": self.movieData[sender.tag].title,
             "videoDescription": self.movieData[sender.tag].description]
        CSOptionDropDown.dropDownMenu(popUpButton: sender,
                                      controller: self,
                                      parametr: parameter)
    }
}
// MARK: - Delegate Method
extension CSRelateAndTrendingViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "videoDetail", sender: indexPath.row)
    }
}
// MARK: - API REQUEST
extension CSRelateAndTrendingViewController {
    // Recent for api
    func callRecentVideos() {
        /// Setting Parameter to Api
        let paramet: [String: String] = [
            "type": type,
            "page": String(currentPage)
        ]
        CSVideoDetailApiModel.fetchRecentAndTrending(
            parentView: self,
            parameters: paramet,
            isPageDisable: currentPage.checkPageNeed(),
            completionHandler: { responce in
                self.currentPage = responce.homePageMovieMore.currentPage
                self.lastPage = responce.homePageMovieMore.lastPage
                self.movieData += responce.homePageMovieMore.movieList
                self.bindDataToRecent()
        })
    }
}
// MARK: - Pull to Refresh
extension CSRelateAndTrendingViewController: PullToRefreshManagerDelegate {
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
extension CSRelateAndTrendingViewController: PaginationManagerDelegate {
    public func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callRecentVideos()
        }
    }
    public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
        currentPage += 1
        if currentPage > self.lastPage {
            return false
        }
        return true
    }
}
