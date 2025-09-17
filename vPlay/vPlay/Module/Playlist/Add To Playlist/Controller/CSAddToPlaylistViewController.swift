/*
 * CSAddToPlaylistViewController.swift
 * These class is for Creating and PlayList and Add video to playlist
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSAddToPlaylistViewController: CSParentViewController {
    /// Create Playlist View
    @IBOutlet var createPlaylist: UIView!
    /// Play List view
    @IBOutlet var playListingView: UIView!
    /// Play List Table
    @IBOutlet var playListingTable: UITableView!
    /// Play List Height Constant
    @IBOutlet var playListingTableHeightConstant: NSLayoutConstraint!
    /// Play List Data Source
    @IBOutlet var playListingDataSource: CSAddPlaylistDataSource!
    /// Playlist Test Field
    @IBOutlet var playListTextField: UITextField!
    /// UIScroll View
    @IBOutlet var scrollView: UIScrollView!
    /// Video Id
    var videoId = Int()
    // Page Index
    var lastPage = 0
    // Current Index
    var currentPage = 0
    /// Playlisr Video Listing
    var playList = [CSPlayList]()
    /// Playlisr Video Listing
    var previousController: CSParentViewController!
    /// Pull to refresh declaration
    fileprivate var refreshManager: PullToRefreshManager!
    /// Pagination manger declaration
    fileprivate var paginatioManager: PaginationManager!
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        registerRefreshIndicator()
        createPlaylist.isHidden = true
        playListingView.isHidden = true
        previousController = LibraryAPI.sharedInstance.currentController
        callApi()
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.currentPage = 1
        self.playList = [CSPlayList]()
        self.playListApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// Follow and UnFollow Button Action
    @IBAction func closeAction(_ sender: UIButton) {
        LibraryAPI.sharedInstance.currentController = previousController
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Button Action
extension CSAddToPlaylistViewController {
    /// Load Data
    func loadData() {
        if self.playList.count < 1 {
            self.createPlaylist.isHidden = false
            self.playListingView.isHidden = true
            self.playListTextField.becomeFirstResponder()
            return
        }
        self.createPlaylist.isHidden = true
        self.playListingView.isHidden = false
        playListingDataSource.delegate = self
        playListingDataSource.playList = self.playList
        playListingTable.reloadData()
        playListingTable.layoutIfNeeded()
        if playListingTable.contentSize.height > 150 {
            playListingTableHeightConstant.constant = 150
        } else {
            playListingTableHeightConstant.constant = self.playListingTable.contentSize.height
        }
    }
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        // If you want to use Pull To Refresh
        self.refreshManager = PullToRefreshManager(scrollView: self.playListingTable, delegate: self)
        self.refreshManager.updateActivityIndicatorStyle(.white)
        self.refreshManager.updateActivityIndicatorColor(UIColor.invertColor(true))
        // If you want to use Pagination
        self.paginatioManager = PaginationManager(scrollView: self.playListingTable, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.invertColor(true))
    }
    /// Add Or Remove Playlist
    func addOrRemoveFromPlaylist(_ index: Int) {
        if self.playListingDataSource.playList[index].isExist == 1 {
            self.removeFromPlayList(playListingDataSource.playList[index].playListName,
                                    playListId: playListingDataSource.playList[index].playListId)
        } else {
            self.addToPlayList(playListingDataSource.playList[index].playListName,
                               playListId: playListingDataSource.playList[index].playListId)
        }
    }
    /// Change Status PLaylist
    func changeStatusOfPlaylist(_ playlistId: String, isStatus: Int) {
        let index = self.playListingDataSource.playList.firstIndex(where: { $0.playListId == playlistId })
        self.self.playListingDataSource.playList[index!].isExist = isStatus
        self.playList[index!].isExist = isStatus
        if let cell = self.playListingTable.cellForRow(at:
            IndexPath(row: index!, section: 0)) as? CSPlaylistTableCell {
            cell.checkIsExist(isStatus)
        }
    }
}
// MARK: - Button Action
extension CSAddToPlaylistViewController {
    @IBAction func savedPlaylist(_ sender: UIButton) {
        if !CSUserValidation.validatePlayList(textField: playListTextField, viewController: self) { return }
        self.createPlayList()
    }
    /// Cancel Playlist
    @IBAction func cancePlaylist(_ sender: Any) {
        playListTextField.text = ""
        playListTextField.resignFirstResponder()
        if playListingDataSource.playList.count > 1 {
            self.createPlaylist.isHidden = true
            self.playListingView.isHidden = false
            return
        }
        LibraryAPI.sharedInstance.currentController = previousController
        self.dismiss(animated: true, completion: nil)
    }
    /// Creat Playlist Button
    @IBAction func creatPlaylistButton(_ sender: UIButton) {
        self.createPlaylist.isHidden = false
        self.playListingView.isHidden = true
        playListTextField.becomeFirstResponder()
    }
}
// MARK: - Delegate For Text Field Method
extension CSAddToPlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - Table Delegate
extension CSAddToPlaylistViewController: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addOrRemoveFromPlaylist(indexPath.row)
    }
}
// MARK: - Api Request
extension CSAddToPlaylistViewController {
    /// PlayList Api Call
    func playListApiCall() {
        let parameter: [String: String] = ["page": String(currentPage),
                                           "video_id": String(self.videoId)]
        CSPlayListApiModel.playListingApi(
            parentView: self,
            isPageDisable: currentPage.checkPageNeed(),
            parameters: parameter,
            completionHandler: { responce in
                self.currentPage = responce.responseRequired.playlist.currentPage
                self.lastPage = responce.responseRequired.playlist.lastPage
                self.playList += responce.responseRequired.playlist.playList
                self.loadData()
        })
    }
    /// Create Playlist
    func createPlayList() {
        self.view.endEditing(true)
        let paramete: [String: String] = ["name": playListTextField.text!.capitalizingFirstLetter(),
                                          "videos": String(self.videoId)]
        CSPlayListApiModel.createEditAndAddPlayListVideo(
            parentView: self,
            parameters: paramete,
            completionHandler: { _ in
                self.playListTextField.text = ""
                self.view.endEditing(true)
                self.callApi()
        })
    }
    /// add To Playlist
    func addToPlayList(_ name: String, playListId: String) {
        let paramete: [String: String] = ["id": playListId,
                                          "videos": String(self.videoId),
                                          "name": name]
        CSPlayListApiModel.createEditAndAddPlayListVideo(
            parentView: self,
            parameters: paramete,
            completionHandler: { _ in
                self.changeStatusOfPlaylist(playListId, isStatus: 1)
        })
    }
    // Delete playlist Video
    func removeFromPlayList(_ name: String, playListId: String) {
        let parameter: [String: String] = ["video_id": String(self.videoId),
                                           "playlist_id": playListId]
        CSPlayListApiModel.deletePlayListVideo(
            parentView: self,
            parameters: parameter,
            completionHandler: { _ in
                self.changeStatusOfPlaylist(playListId, isStatus: 0)
        })
    }
}
// MARK: - Key board Method
extension CSAddToPlaylistViewController {
    /// Register Notification
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSAddToPlaylistViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSAddToPlaylistViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                    bottom: (keyboardSize?.height)!, right: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.scrollView.isScrollEnabled = false
        })
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                        bottom: 0, right: 0)
        })
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - Pull to Refresh
extension CSAddToPlaylistViewController: PullToRefreshManagerDelegate {
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
extension CSAddToPlaylistViewController: PaginationManagerDelegate {
    /// Pagiantion Manager start loading
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.playListApiCall()
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
