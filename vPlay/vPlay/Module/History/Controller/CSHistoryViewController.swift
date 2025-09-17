/*
 * CSHistoryViewController.swift
 * This class is used to view all the video's that has been watched by the user
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSHistoryViewController: CSParentViewController {
    /// Header view
    @IBOutlet weak var headerView: UIView!
    /// Back button
    @IBOutlet weak var backButton: UIButton!
    /// controller title
    @IBOutlet var historyTitle: UILabel!
    /// history Collection
    @IBOutlet var historyCollection: UICollectionView!
    /// history Collection Data Source
    @IBOutlet var historyCollectionDataSource: CSRelatedCollectionDataSources!
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
        setupNavigation()
        registerRefreshIndicator()
        callApi()
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.addLoginIfUserNotLogin(self)
            return
        }
        currentPage = 1
        self.movieData = [CSMovieData]()
        self.callRecentVideos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setModeBasedColor() {
        historyTitle.textColor = UIColor.contentColor()
        headerView.backgroundColor = UIColor.navigationBarColor
        backButton.tintColor = UIColor.iconColor()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSVideoDetailViewController {
            let controller = segue.destination as? CSVideoDetailViewController
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
// MARK: - Private Method Data
extension CSHistoryViewController {
    // It adds the notification bar.
    func setupNavigation() {
        historyTitle.text = controllerTitle
        addGradientBackGround()
        setModeBasedColor()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.historyCollection, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.historyCollection, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    // Bind Data To Recent
    func bindDataToRecent() {
        if movieData.count < 1 {
            self.addChildView(identifier: "NoHistory", storyBoard: alertStoryBoard)
            return
        }
        self.historyCollectionDataSource.delegate = self
        self.historyCollectionDataSource.movieData = self.movieData
        self.historyCollection.reloadData()
    }
}
// MARK: - Button Action
extension CSHistoryViewController {
    /// Set Favourite
    @IBAction func clearVideoFromHistoryAction(_ sender: UIButton) {
        self.clearVideoFromHistory(sender.tag)
    }
    /// Clear All Video From History
    @IBAction func clearAllVideoFromHistoryAction(_ sender: UIButton) {
        self.clearAllVideoFromHistory()
    }
}
// MARK: - Delegate Method
extension CSHistoryViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "videoDetail", sender: indexPath.row)
    }
}
// MARK: - API REQUEST
extension CSHistoryViewController {
    // Recent for api
    func callRecentVideos() {
        /// Setting Parameter to Api
        let paramet: [String: String] = [
            "type": "recent",
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
    /// Remove Video from Favourite
    func clearVideoFromHistory(_ index: Int) {
        let paramet: [String: String] = ["video_id": String(self.movieData[index].movieId)]
        CSHomeApiModel.removeVideoFromHistory(
            parentView: self, parameters: paramet,
            completionHandler: { _ in
                self.movieData.remove(at: index)
                self.historyCollectionDataSource.movieData.remove(at: index)
                self.historyCollection.reloadData()
                if self.movieData.count < 1 {
                     self.addChildView(identifier: "NoHistory", storyBoard: alertStoryBoard)
                }
        })
    }
    /// Add Video to Favourite
    func clearAllVideoFromHistory() {
        CSHomeApiModel.removeVideoFromHistory(
            parentView: self, parameters: nil,
            completionHandler: { _ in
                self.movieData = [CSMovieData]()
                self.historyCollectionDataSource.movieData = [CSMovieData]()
                self.historyCollection.reloadData()
                self.addChildView(identifier: "NoHistory", storyBoard: alertStoryBoard)
        })
    }
}
// MARK: - Pull to Refresh
extension CSHistoryViewController: PullToRefreshManagerDelegate {
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
extension CSHistoryViewController: PaginationManagerDelegate {
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
