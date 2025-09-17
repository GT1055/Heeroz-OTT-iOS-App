/*
 * CSSavedPlaylistViewController.swift
 * These class is for listing all the Saved playlist Listed
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSSavedPlaylistViewController: CSParentViewController {
    /// Saved Playlist Collection
    @IBOutlet var savedPlayListCollection: UICollectionView!
    /// Saved Playlist Data Sources
    @IBOutlet var savedPlayListCollectionDataSource: CSPlayListDataSources!
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    /// Playlisr Video Listing
    var playList = [CSPlayList]()
    // Current Page
    var currentPage = 0
    // Last Page
    var lastPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        registerRefreshIndicator()
        addGradientBackGround()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApi()
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.addLoginIfUserNotLogin(self)
            return
        }
        currentPage = 1
        playList = [CSPlayList]()
        savedPlayListCollectionDataSource.delegate = self
        playListDetailVideo()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSModifyPlaylistViewController {
            let controller = segue.destination as? CSModifyPlaylistViewController
            let index = (sender as? Int)!
            controller?.playlist = playList[index]
            controller?.delegate = self
        } else {
            let controller = segue.destination as? CSPlaylistVideoListViewController
            let index = (sender as? Int)!
            controller?.playListId = playList[index].playListId
            controller?.controllerTitle = playList[index].playListName
        }
    }
}
// MARK: - Playlist Delegate
extension CSSavedPlaylistViewController: CSRenamePlaylist {
    func renamedPlaylist(playlistName: String, playlistId: String) {
        guard let index = self.savedPlayListCollectionDataSource.playList.firstIndex(where: {
            $0.playListId == playlistId }) else { return }
        self.savedPlayListCollectionDataSource.playList[index].playListName = playlistName
        self.playList[index].playListName = playlistName
        if let cell = savedPlayListCollection.cellForItem(at:
            IndexPath(item: index, section: 0)) as? CSPlaylistsCollectionViewCell {
            cell.bindData(self.savedPlayListCollectionDataSource.playList[index])
        }
    }
}
// MARK: - Button Action
extension CSSavedPlaylistViewController {
    /// Follow and UnFollow Button Action
    @IBAction func followAndUnfollowPlayList(_ sender: UIButton) {
        let parmeter: [String: String] = [
            "videoSlug": "",
            "videoId": self.playList[sender.tag].playListId]
        CSOptionDropDown.playlistDropdown(popUpButton: sender,
                                          controller: self,
                                          parametr: parmeter)
    }
}
// MARK: - Api Request
extension CSSavedPlaylistViewController {
    /// PlayList Api Call
    func playListDetailVideo() {
        let parameter: [String: String] = ["page": String(currentPage)]
        CSPlayListApiModel.playListingApi(
            parentView: self,
            isPageDisable: currentPage.checkPageNeed(),
            parameters: parameter,
            completionHandler: { responce in
                self.currentPage = responce.responseRequired.playlist.currentPage
                self.lastPage = responce.responseRequired.playlist.lastPage
                self.playList += responce.responseRequired.playlist.playList
                self.bindDataToCollection()
        })
    }
    /// Remove Playlist
    func removePlaylist(_ index: Int) {
        let parameter: [String: String] = ["playlist_id": self.playList[index].playListId]
        CSPlayListApiModel.deletePlayList(
            parentView: self,
            parameters: parameter,
            completionHandler: { _ in
                self.playList.remove(at: index)
                self.savedPlayListCollectionDataSource.playList.remove(at: index)
                self.bindDataToCollection()
        })
    }
}
// MARK: - Private Method
extension CSSavedPlaylistViewController {
    func bindDataToCollection() {
        if self.playList.count < 1 {
            self.addChildView(identifier: "NoPlaylist", storyBoard: alertStoryBoard)
            return
        }
        savedPlayListCollectionDataSource.playList = self.playList
        savedPlayListCollectionDataSource.delegate = self
        savedPlayListCollection.reloadData()
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.savedPlayListCollection, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.savedPlayListCollection, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        self.addLeftBarButton()
    }
}
// MARK: - Private Method
extension CSSavedPlaylistViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView,
                                didSelectItemAt indexPath: IndexPath) {
        if !self.playList.count.checkDataPresent() { return }
        if self.playList[indexPath.row].videoCount < 1 {
            showToastMessageTop(message: "The selected playlist doesn't contain any video's")
            return
        }
        self.performSegue(withIdentifier: "playlistVideo", sender: indexPath.row)
    }
}
// MARK: - Pull to Refresh
extension CSSavedPlaylistViewController: PullToRefreshManagerDelegate {
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
extension CSSavedPlaylistViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.playListDetailVideo()
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
