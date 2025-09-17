/*
 * CSPlaylistViewController.swift
 * This Controller is used for listing Playlist
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
@objc protocol CSTableViewDelegate: class {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableViewDidScroll(_ scrollView: UIScrollView)
}
@objc protocol CSCollectionViewDelegate: class {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func collectionViewDidScroll(_ scrollView: UIScrollView)
}
class CSPlaylistVideoListViewController: CSParentViewController {
    /// Play list Video
    @IBOutlet var playlistVideoCollection: UICollectionView!
    // Data Sources
    @IBOutlet var playlistVideoDataSource: CSRelatedCollectionDataSources!
    /// Play list Array
    var playListArray = [CSMovieData]()
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    /// PlayList Id
    var playListId = String()
    /// Current Page
    var currentPage = 0
    /// Last Page
    var lastPage = 0
    // MARK: - UIViewController Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        registerRefreshIndicator()
        addGradientBackGround()
        // Do any additional setup after loading the view.
    }
    /// Call Api
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.addLoginIfUserNotLogin(self)
            return
        }
        currentPage = 1
        playListArray = [CSMovieData]()
        fetchPlayListApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApi()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playListDetail" {
            let index = (sender as? Int)!
            let controller = segue.destination as? CSVideoDetailViewController
            controller?.delegate = self
            controller?.videoId = playListArray[index].movieId
            controller?.categoryId = playListId
            controller?.isPlaylist = true
            controller?.controllerTitle = controllerTitle
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - BUtton Action
extension CSPlaylistVideoListViewController {
    /// Favourite Button Action
    @IBAction func optionForButton(_ sender: UIButton) {
        let parmeter: [String: String] = [
            "videoSlug": self.playListArray[sender.tag].slug,
            "videoId": String(self.playListArray[sender.tag].movieId),
            "videoImage": self.playListArray[sender.tag].posterImage,
            "videoTitle": self.playListArray[sender.tag].title,
            "videoDescription": self.playListArray[sender.tag].description]
        CSOptionDropDown.playlistVideoDropdown(popUpButton: sender,
                                               controller: self,
                                               parametr: parmeter)
    }
    /// Open Drop Down Button Action
    @IBAction func favouriteButtonPlayList(_ sender: UIButton) {
    }
}
// MARK: - Delegate of table
extension CSPlaylistVideoListViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "playListDetail", sender: indexPath.row)
    }
}
// MARK: - Private Methods
extension CSPlaylistVideoListViewController {
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.playlistVideoCollection, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.playlistVideoCollection, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Load Data
    func loadDataToTable() {
        if self.playListArray.count < 1 {
            self.addChildView(identifier: noDataIdentifier, storyBoard: alertStoryBoard)
            return
        }
        playlistVideoDataSource.delegate = self
        playlistVideoDataSource.relatedVideo = playListArray
        playlistVideoCollection.reloadData()
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        self.addLeftBarButton()
    }
}
// MARK: - Call Api
extension CSPlaylistVideoListViewController {
    // Fetch playlist Video api
    func fetchPlayListApi() {
        let parameter: [String: String] = ["page": String(currentPage),
                                           "playlist_id": playListId]
        CSPlayListApiModel.fetchPlayListVideo(
            parentView: self,
            parameters: parameter,
            isPageDisable: currentPage.checkPageNeed(),
            completionHandler: { response in
                self.currentPage = response.responseRequired.playlistVideo.currentPage
                self.lastPage = response.responseRequired.playlistVideo.lastPage
                self.playListArray += self.convertPlaylistMovietoMoviewList(
                    playlistMovie: (response.responseRequired.playlistVideo.playList))
                self.loadDataToTable()
        })
    }
    // Delete playlist Video
    func deletePlayListVideoApi(_ index: Int) {
        let parameter: [String: String] = ["video_id": String(self.playListArray[index].movieId),
                                           "playlist_id": playListId]
        CSPlayListApiModel.deletePlayListVideo(
            parentView: self,
            parameters: parameter,
            completionHandler: { _ in
                self.playListArray.remove(at: index)
                self.playlistVideoDataSource.relatedVideo.remove(at: index)
                self.loadDataToTable()
        })
    }
    // Convert Playlist Movie To Movie List
    func convertPlaylistMovietoMoviewList(playlistMovie: [CSPlayList]) -> [CSMovieData] {
        var movieList = [CSMovieData]()
        for movie in playlistMovie where movie.playlistVideos != nil {
            movieList.append(movie.playlistVideos)
        }
        return movieList
    }
}
// MARK: - Delegate Methods
extension CSPlaylistVideoListViewController: CSVideoDetailDelegate {
    func favouriteDelegate(_ favourite: Int, videoId: Int) {
        let index = self.playListArray.firstIndex(where: { $0.movieId == videoId })
        self.playListArray[index!].isFavourite = favourite
        self.playlistVideoDataSource.relatedVideo[index!].isFavourite = favourite
        if let cell = self.playlistVideoCollection.cellForItem(at:
            IndexPath(row: index!, section: 0)) as? HomeCollectionViewCell {
            cell.checkVideoFavourite(favourite)
        }
    }
}
// MARK: - Pull to Refresh
extension CSPlaylistVideoListViewController: PullToRefreshManagerDelegate {
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
extension CSPlaylistVideoListViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.fetchPlayListApi()
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
