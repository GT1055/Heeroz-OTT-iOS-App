/*
 * CSFavouriteListMapper
 * This View Controller is used to display favourites Video
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSFavoutritesViewController: CSParentViewController {
    /// Favourite Collection
    @IBOutlet var favouriteCollection: UICollectionView!
    /// Favourite Collection View
    @IBOutlet var favouritesCollectionDataSource: CSRelatedCollectionDataSources!
    // stores only favourites list array
    var favouriteListArray = [CSMovieData]()
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // last Page
    var lastPage = Int()
    // total video detail
    var totalVideoCount = Int()
    // current video detail
    var currentPage = Int()
    // commen Index path
    var comIndexTag: IndexPath!
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteCollection.tag = 2
        self.setupNavigation()
        registerRefreshIndicator()
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.addLoginIfUserNotLogin(self)
            return
        }
        self.currentPage = 1
        self.favouriteListArray = [CSMovieData]()
        self.favouriteCollection.reloadData()
        fetchFacouriteApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApi()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let index = (sender as? Int)!
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.videoId = self.favouriteListArray[index].movieId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CSFavoutritesViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "videoDetail", sender: indexPath.row)
    }
}
// MARK: - Private Method
extension CSFavoutritesViewController {
    // register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.favouriteCollection, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.favouriteCollection, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Reload Data
    func reloadData() {
        favouritesCollectionDataSource.delegate = self
        favouritesCollectionDataSource.favouriteListArray = favouriteListArray
        favouriteCollection.reloadData()
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        self.addLeftBarButton()
        addRightBarButton()
    }
}
// MARK: - Button action
extension CSFavoutritesViewController {
    /// open popup for the button action below
    /// - Parameter sender: Any
    @IBAction func showfavOptionPopUpViewcontroller(_ sender: UIButton) {
    }
    /// Open Option Button
    @IBAction func openOptionButton(_ sender: UIButton) {
        let parameter: [String: String] =
            ["videoSlug": self.favouriteListArray[sender.tag].slug,
             "videoId": String(self.favouriteListArray[sender.tag].movieId),
             "videoImage": self.favouriteListArray[sender.tag].posterImage,
             "videoTitle": self.favouriteListArray[sender.tag].title,
             "videoDescription": ""]
        CSOptionDropDown.myFavouriteDropDownMenu(popUpButton: sender, controller: self, parametr: parameter)
    }
}
// MARK: - Api Call
extension CSFavoutritesViewController {
    /// Fetch Api of Favourite
    func fetchFacouriteApi() {
        let parameter = ["page": String(self.currentPage)]
        CSFavouriteApiModel.fetchFavouriteVideosRequest(
            parentView: self,
            parameters: parameter,
            isPageingDisable: currentPage.checkPageNeed(),
            completionHandler: { responces in
                self.currentPage = responces.favouritePage.currentPage
                self.lastPage = responces.favouritePage.lastPage
                self.favouriteListArray += responces.favouritePage.movieList
                if self.favouriteListArray.count > 0 {
                    self.reloadData()
                } else {
                    self.addChildView(identifier: "NoFavourite", storyBoard: alertStoryBoard)
                }
        })
    }
    /// Remove Video from Favourite
    func removeFromFavouriteVideo(videoId: String) {
        let paramet: [String: String] = ["video_slug": videoId]
        CSHomeApiModel.removeFavouriteRequest(
            parentView: self, parameters: paramet, buttonObject: UIButton.init(),
            completionHandler: { [unowned self] _ in
                self.favouriteListArray.removeAll()
                self.fetchFacouriteApi()
        })
    }
}
// MARK: - Pull to Refresh
extension CSFavoutritesViewController: PullToRefreshManagerDelegate {
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
extension CSFavoutritesViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.fetchFacouriteApi()
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
