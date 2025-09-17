//
//  CSDownloadingListViewController.swift
//  LearningSpaces
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
protocol  CSDownloadDelegate: class {
    func downloadCompleted(_ task: URL)
    func downloadProgress(_ task: URLSessionTask, progress: Double)
}
class CSDownloadingListViewController: CSParentViewController {
    // Download Table
    @IBOutlet var downloadTable: UITableView!
    // Download Data Source
    @IBOutlet var downloadDataSource: DownloadListDataSources!
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if CSDownloadManager.shared.activeTracks.count < 1 {
            self.addChildViewController(identifier: "NoDownloadFound", storyBoard: alertStoryBoard)
        }
        downloadDataSource.delegate = self
        CSDownloadManager.shared.delegate = self
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
/// MARK : - Download Delegate
extension CSDownloadingListViewController: CSDownloaderDelegate {
    func didLoadtimeRange(_ url: URL) {
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
        DispatchQueue.main.async { [unowned self] in
            if CSDownloadManager.shared.activeTracks.count < 1 {
                self.addChildViewController(identifier: "NoDownloadFound", storyBoard: alertStoryBoard)
                return
            }
            self.downloadTable.reloadData()
        }
    }
    func didWithErrorFinishDownloading(_ url: URL, error: NSError) {
        DispatchQueue.main.async { [unowned self] in
            if CSDownloadManager.shared.activeTracks.count < 1 {
                self.addChildViewController(identifier: "NoDownloadFound", storyBoard: alertStoryBoard)
                return
            }
            self.downloadTable.reloadData()
        }
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
extension CSDownloadingListViewController: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlertViewMessage(indexPath.row)
    }
}
// MARK: - Button Action
extension CSDownloadingListViewController {
    @IBAction func stopAndStartDownload(_ sender: UIButton) {
        if sender.titleLabel!.text == "Pause" {
            self.pauseTapped(sender)
        } else {
            self.resumeTapped(sender)
        }
    }
}
// MARK: - Private Method
extension CSDownloadingListViewController {
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
        self.present(alertController, animated: true, completion: nil)
    }
    // Pause The Download Button Action
    func pauseTapped(_ sender: UIButton) {
        let track = CSDownloadManager.shared.activeTracks[sender.tag]
        CSDownloadManager.shared.pauseDownload(track)
        reloadData(sender.tag)
    }
    // Resume The Download Button Action
    func resumeTapped(_ sender: UIButton) {
        let track = CSDownloadManager.shared.activeTracks[sender.tag]
        CSDownloadManager.shared.resumeDownload(track)
        reloadData(sender.tag)
    }
    // Cancel The Download Button Action
    func cancelTapped(_ index: Int) {
        let track = CSDownloadManager.shared.activeTracks[index]
        CSDownloadManager.shared.cancelDownload(track)
        self.downloadTable.reloadData()
        if CSDownloadManager.shared.activeTracks.count < 1 {
            self.addChildViewController(identifier: "NoDownloadFound", storyBoard: alertStoryBoard)
        }
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
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
        addRightBarButton()
    }
}
