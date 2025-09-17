//
//  CSOfflineViewController.swift
//  vPlay
//
//  Created by user on 19/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import GoogleCast
class CSOfflineViewController: CSParentViewController, GCKSessionManagerListener, GCKRemoteMediaClientListener {
    // Offline Table View
    @IBOutlet var offlineTableView: UITableView!
    /// Data Source
    @IBOutlet var offlineTableDataSource: CSOfflineDataSources!
    /// Offline Collection Height
    @IBOutlet var offlineTableViewHeight: NSLayoutConstraint!
    /// Downloading Table View
    @IBOutlet var downloadTable: UITableView!
    /// Data Source
    @IBOutlet var downloadingDataSource: DownloadListDataSources!
    /// download Table Height
    @IBOutlet var downloadTableHeight: NSLayoutConstraint!
    /// assert Data
    var assertList = [AssertDetails]()
    /// download List Table
    var downloadTableContentSize: NSKeyValueObservation?
    /// offline List Table
    var offlineTableContentSize: NSKeyValueObservation?
    /// Alert Controller tag
    let alertControllerViewTag: Int = 500
    //Mediaclient
    var mediaClient: GCKRemoteMediaClient!
    //queue array
    var queueArray = [AnyObject]()
    //castsession
    var castSession: GCKCastSession!
    //QueueRequest
    var queueRequest: GCKRequest!
    //queue
    var queueList: GCKMediaQueue!
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverToTable()
        self.addLeftBarButton()
        self.addGradientBackGround()
        offlineTableDataSource.delegate = self
        downloadingDataSource.delegate = self
        CSDownloadManager.shared.delegate = self
        if GCKCastContext.sharedInstance().sessionManager.hasConnectedSession() {
        mediaClient = GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient
            mediaClient.add(self)
            self.queueList = GCKMediaQueue.init(remoteMediaClient: mediaClient)
            self.queueList.add(self)
            if controllerTitle == "Queue List" {
            UserDefaults.standard.set(controllerTitle, forKey: "Queue")
                self.addLeftPresentBarButton()
                if let castContext = mediaClient.mediaStatus?.queueItemCount {
                    if castContext != 0 {
                        for index in 0..<mediaClient.mediaStatus!.queueItemCount {
                            queueArray.append(mediaClient.mediaStatus!.queueItem(at: index)!)
                        }
                        offlineTableDataSource.assertList = (queueArray as? [AssertDetails])!
                        self.offlineTableView.reloadData()
                        queueList.reload()
                    } else {
                        self.showToastMessageTop(message: NSLocalizedString("No videos in queue", comment: "Success"))
                    } }
            } }
        if controllerTitle != "Queue List" {
            UserDefaults.standard.removeObject(forKey: "Queue")
            callApi() }
    }
    override func callApi() {
        getDownloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if controllerTitle == "Queue List" {
            return
        } else {
            if segue.destination is CSOfflineVideoViewController {
                let controller = segue.destination as? CSOfflineVideoViewController
                let index = (sender as? Int)!
                controller?.assertData = self.assertList[index]
            }
        }
    }
    /// Add Observer to Table of comment
    func addObserverToTable() {
        downloadTableContentSize = downloadTable.observe(
            \UITableView.contentSize,
            options: [.new],
            changeHandler: { _, value  in
                if let contentSize = value.newValue {
                    if CSDownloadManager.shared.activeTracks.count != 0 {
                        self.downloadTableHeight.constant = contentSize.height
                    } else {
                        self.downloadTableHeight.constant = 0
                    }
                }
        })
        offlineTableContentSize = offlineTableView.observe(
            \UITableView.contentSize,
            options: [.new],
            changeHandler: { _, value  in
                if let contentSize = value.newValue {
                    if self.offlineTableDataSource.assertList.count != 0 {
                        self.offlineTableViewHeight.constant = contentSize.height
                    } else {
                        self.offlineTableViewHeight.constant = 0
                    }
                }
        })
    }
    deinit {
        downloadTableContentSize?.invalidate()
        offlineTableContentSize?.invalidate()
    }
}
// MARK: - Button Action
extension CSOfflineViewController {
    @IBAction func deleteAVideo(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "",
            message: NSLocalizedString("Are you sure you want to remove this download?", comment: "Option"),
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("No", comment: "Option"), style: UIAlertAction.Style.cancel,
            handler: { _ in }))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Yes", comment: "Option"), style: UIAlertAction.Style.default,
            handler: { _ in
                self.deleteCurrentVideo(sender.tag)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func cancelVideoDownload(_ sender: UIButton) {
        self.showAlertViewMessage(sender.tag)
    }
}
// MARK: - Private Method
extension CSOfflineViewController {
    /// Load Data To Collection
    func loadDataToCollection() {
        if assertList.count > 0 || CSDownloadManager.shared.activeTracks.count > 0 {
            offlineTableDataSource.assertList = assertList
            offlineTableView.reloadData()
            resizeDownloadTable()
        } else {
            self.addChildViewController(identifier: "NoOfflineRecord", storyBoard: alertStoryBoard)
        }
    }
}
// MARK: - Request For fetch Data
extension CSOfflineViewController {
    /// Fetch all Audio Data
    func getDownloadData() {
        FetchDataBaseData.fetchSavedData(
            parentView: self, completionHandler: { [unowned self] responce in
                self.assertList = responce
                self.loadDataToCollection()
        })
    }
    /// Fetch all Audio Data
    func deleteCurrentVideo(_ index: Int) {
        if controllerTitle == "Queue List" {
            let item: GCKMediaQueueItem? = mediaClient.mediaStatus?.queueItem(at: UInt(index))
            if item != nil {
                start(mediaClient.queueRemoveItem(withID: (item?.itemID)!))
            }
            self.showToastMessageTop(message: "Video is removed from queue")
        } else {
        FetchDataBaseData.deleteAssert(parentView: self, assertId: assertList[index].assertId ?? "",
                                       completionHandler: { [unowned self] _ in
                                        self.assertList.remove(at: index)
                                        self.loadDataToCollection()
        }) }
    }
    /// Delete All Videos
    func deleteAllVideo() {
        FetchDataBaseData.deleteAllRecords(parentView: self,
                                           completionHandler: { [unowned self] _ in
                                            self.assertList.removeAll()
                                            self.loadDataToCollection()
        })
    }
}
/// MARK : - Download Delegate
extension CSOfflineViewController: CSDownloaderDelegate {
    func didLoadtimeRange(_ url: URL) {
        DispatchQueue.main.async {
            guard let index = CSDownloadManager.shared.activeTracks.firstIndex(where: { (item) -> Bool in
                return item.previewURL == url
            }) else { return }
            if let cell = self.downloadTable.cellForRow(at:
                IndexPath(row: index, section: 0)) as? CSDownloadingTableCell {
                guard let download = CSDownloadManager.shared.activeDownloads[url] else { return }
                cell.changeDownloadProgress(download: download)
            }
        }
    }
    func changeDownloadStatusOnNetworkError(_ url: URL) {
        DispatchQueue.main.async {
            guard let index = CSDownloadManager.shared.activeTracks.firstIndex(where: { (item) -> Bool in
                return item.previewURL == url
            }) else { return }
            if let cell = self.downloadTable.cellForRow(at:
                IndexPath(row: index, section: 0)) as? CSDownloadingTableCell {
                guard let download = CSDownloadManager.shared.activeDownloads[url] else { return }
                cell.changeDownloadStatus(downloaded: download.isDownloading)
            }
        }
    }
    func didFinishDownloading(_ url: URL) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { [unowned self] in
            self.resizeDownloadTable()
            self.callApi()
            self.safeDismissAlert()
        })
    }
    func safeDismissAlert() {
        if let controller = self.presentedViewController {
            guard controller is UIAlertController && controller.view.tag == self.alertControllerViewTag else {
                return
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
    func resizeDownloadTable() {
        self.downloadTable.reloadData()
    }
    func didWithErrorFinishDownloading(_ url: URL, error: NSError) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { [unowned self] in
            self.resizeDownloadTable()
            self.callApi()
            self.safeDismissAlert()
        })
    }
    /// Add Alert With title and Message
    func showAlertView(error: NSError) {
        let alert = UIAlertController(title: error.domain, message: error.description,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"),
                                      style: .destructive, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - Delegate Method
extension CSOfflineViewController: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == offlineTableView {
            if UserDefaults.standard.string(forKey: "Queue") == "Queue List" {
                let item: GCKMediaQueueItem? = self.mediaClient.mediaStatus?.queueItem(at: UInt(indexPath.row))
                if item != nil {
                    start(self.mediaClient.queueJumpToItem(withID: (item?.itemID)!))
                }
            } else {
                self.performSegue(withIdentifier: "offlineVideoView", sender: indexPath.row) }
        }
    }
}
// MARK: - Button Action
extension CSOfflineViewController {
    @IBAction func stopAndStartDownload(_ sender: UIButton) {
        if sender.titleLabel!.text == "Pause" {
            self.pauseTapped(sender)
        } else {
            self.resumeTapped(sender)
        }
    }
}
// MARK: - Private Method
extension CSOfflineViewController {
    /// Alert Message
    func showAlertViewMessage(_ index: Int) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Download Option", comment: "Option"),
            message: NSLocalizedString("Are you sure you want to remove this download?", comment: "Option"),
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Yes", comment: "Option"), style: UIAlertAction.Style.default,
            handler: { _ in
                self.cancelTapped(index)
        }))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("No", comment: "Option"), style: UIAlertAction.Style.cancel,
            handler: { _ in }))
        alertController.view.tag = alertControllerViewTag
        self.present(alertController, animated: true, completion: nil)
    }
    // Pause The Download Button Action
    func pauseTapped(_ sender: UIButton) {
        if !Connectivity.isConnectedToInternet() {
            self.showToastMessageTop(message:
                NSLocalizedString("No Internet Connection Found. Please connect to internet",
                                  comment: "Internet"))
            return
        }
        let track = CSDownloadManager.shared.activeTracks[sender.tag]
        CSDownloadManager.shared.pauseDownload(track)
        reloadData(sender.tag)
    }
    // Resume The Download Button Action
    func resumeTapped(_ sender: UIButton) {
        if !Connectivity.isConnectedToInternet() {
            self.showToastMessageTop(message:
                NSLocalizedString("No Internet Connection Found. Please connect to internet",
                                                                comment: "Internet"))
            return
        }
        let track = CSDownloadManager.shared.activeTracks[sender.tag]
        CSDownloadManager.shared.resumeDownload(track)
        reloadData(sender.tag)
    }
    // Cancel The Download Button Action
    func cancelTapped(_ index: Int) {
        if !Connectivity.isConnectedToInternet() {
            self.showToastMessageTop(message:
                NSLocalizedString("No Internet Connection Found. Please connect to internet",
                                  comment: "Internet"))
            return
        }
        let track = CSDownloadManager.shared.activeTracks[index]
        CSDownloadManager.shared.cancelDownload(track)
        self.resizeDownloadTable()
        self.loadDataToCollection()
    }
    // Reload Action
    func reloadData(_ row: Int) {
        DispatchQueue.main.async { [unowned self] in
            let track = CSDownloadManager.shared.activeTracks[row]
            if let cell = self.downloadTable.cellForRow(at:
                IndexPath(row: row, section: 0)) as? CSDownloadingTableCell {
                cell.configure(track: track,
                               download: CSDownloadManager.shared.activeDownloads[track.previewURL])
            }
        }
    }
}
extension CSOfflineViewController: GCKMediaQueueDelegate {
    // Delete queue
    func mediaQueue(_ queue: GCKMediaQueue, didRemoveItemsAtIndexes indexes: [NSNumber]) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Request scheduling
    func start(_ request: GCKRequest) {
        queueRequest = request
        queueRequest.delegate = self
    }
    // MARK: - GCKRequestDelegate
    func requestDidComplete(_ request: GCKRequest) {
        if request == queueRequest {
            queueRequest = nil
        }
    }
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        if request == queueRequest {
            queueRequest = nil
        }
    }
    func requestWasReplaced(_ request: GCKRequest) {
        if request == queueRequest {
            queueRequest = nil
        }
    }
}
