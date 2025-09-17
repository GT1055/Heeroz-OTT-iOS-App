//
//  CSDownloadManager.swift
//  Skempi
//
//  Created by contus on 5/4/18.
//  Copyright © 2018 contus. All rights reserved.
//

import Foundation
import AVFoundation
import UserNotifications
import ObjectMapper
import UIKit
import CoreFoundation
protocol CSDownloaderDelegate: class {
    func didLoadtimeRange(_ url: URL)
    func didFinishDownloading(_ url: URL)
    func didWithErrorFinishDownloading(_ url: URL, error: NSError)
    func changeDownloadStatusOnNetworkError(_ url: URL)
}
// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class CSDownloadManager: NSObject {
    /// Shared Instance
    static let shared = CSDownloadManager()
    /// Active Tracks
    var activeTracks: [CSTrack] = []
    /// Download Track
    var activeDownloads: [URL: CSDownload] = [:]
    /// Delegate
    weak var delegate: CSDownloaderDelegate?
    /// Create a Queue configuration
    private let queue: OperationQueue = {
        let queues = OperationQueue()
        queues.name = "download"
        queues.maxConcurrentOperationCount = 5
        return queues
    }()
    /// Added Url Cache method
    lazy var urlCache: URLCache = {
        let capacity = 5 * 1024 * 1024 // MBs capacity To 5MBS
        let urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
        return urlCache
    }()
    /// Download Session Configuration
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        configuration.sessionSendsLaunchEvents = true
        configuration.allowsCellularAccess = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        UNUserNotificationCenter.current().delegate = self
        return URLSession(configuration: configuration, delegate: self, delegateQueue: queue)
    }()
    // MARK: - Download methods called by TrackCell delegate methods
    /// Add A Video To Download
    func addDownloadData(_ downloadUrl: URL, videoData: CSDownloadModel, parentView: AnyObject) {
        let controller = parentView as? CSParentViewController
        FetchDataBaseData.checkFileExist(
            parentView: parentView,
            assertId: videoData.assertId,
            completionHandler: { [unowned self] responce in
                if !responce {
                    self.startFileDownload(downloadUrl, videoData: videoData)
                } else {
                    controller?.showToastMessageTop(message:
                        NSLocalizedString("You have already download this file. You can view it in Offline mode", comment: "Download") )
                }
        })
    }
    func startFileDownload(_ downloadUrl: URL, videoData: CSDownloadModel) {
        if activeTracks.firstIndex(where: {$0.previewURL == downloadUrl}) != nil {
            return
        }
        // Create JSON String from Model
        let JSONString = Mapper().toJSONString(videoData, prettyPrint: true) ?? ""
        let data = CSTrack.init(previewURL: downloadUrl, video: videoData)
        activeTracks.append(data)
        self.startDownload(data, taskDescription: JSONString)
    }
    func startDownload(_ track: CSTrack, taskDescription: String = String()) {
        let download = CSDownload(track: track)
        download.task = downloadsSession.downloadTask(with: track.previewURL)
        download.task!.resume()
        download.task?.taskDescription = taskDescription
        download.isDownloading = true
        activeDownloads[download.track.previewURL] = download
    }
    func pauseDownload(_ track: CSTrack) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if download.isDownloading {
            download.task!.suspend()
            download.isDownloading = false
        }
    }
    func cancelDownload(_ track: CSTrack) {
        if let download = activeDownloads[track.previewURL] {
            download.task?.cancel()
            guard let index = self.activeTracks.firstIndex(where: { (item) -> Bool in
                return item.previewURL == download.task?.originalRequest?.url
            }) else { return }
            self.activeTracks.remove(at: index)
            activeDownloads[track.previewURL] = nil
        }
    }
    func resumeDownload(_ track: CSTrack) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if !download.isDownloading {
            download.task!.resume()
            download.isDownloading = true
        }
    }
}
extension CSDownloadManager: URLSessionDownloadDelegate {
    // Stores downloaded file
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        let statusCode = (downloadTask.response  as? HTTPURLResponse)!.statusCode
        guard statusCode < 400 else {
            let error = NSError(domain: "HttpError", code: statusCode,
                                userInfo: [NSLocalizedDescriptionKey:
                                    HTTPURLResponse.localizedString(forStatusCode: statusCode)])
            self.errorHandleOFdidFinsh(downloadTask, error: error)
            return
        }
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let dir = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileExtension: String = (downloadTask.currentRequest?.url?.pathExtension)!
        let newFileName = String(Date().toMillis()) + "." + fileExtension
        let docURL = dir?.appendingPathComponent(newFileName)
        let fileManager = FileManager.default
        do {
            try? fileManager.removeItem(at: docURL!)
            try fileManager.copyItem(at: location, to: docURL!)
            try? fileManager.removeItem(at: location)
            if let responceData = Mapper<CSDownloadModel>().map(JSONString: downloadTask.taskDescription!) {
                self.downloadCompleted(true, location: docURL!, downloadUrl: sourceURL,
                                       downloadData: responceData)
            }
            if let download = self.activeDownloads[sourceURL] {
                download.track.downloaded = true
                download.track.isDownloadCompleted = true
                download.track.downloadPath = docURL!.relativePath
                download.progress = 1.0
                self.activeDownloads[sourceURL] = nil
            }
            if self.delegate != nil {
                guard let index = self.activeTracks.firstIndex(where: { (item) -> Bool in
                    return item.previewURL == sourceURL
                }) else { return }
                self.activeTracks.remove(at: index)
                self.delegate?.didFinishDownloading(sourceURL)
            }
        } catch _ {
        }
    }
    func errorHandleOFdidFinsh(_  downloadTask: URLSessionDownloadTask, error: NSError) {
        DispatchQueue.main.async {
            LibraryAPI.sharedInstance.currentController
                .showToastMessageTop(message: NSLocalizedString("Error in downloading file", comment: "error"))
        }
        if self.delegate != nil {
            guard let sourceURL = downloadTask.originalRequest?.url else { return }
            self.activeDownloads[sourceURL] = nil
            guard let index = self.activeTracks.firstIndex(where: { (item) -> Bool in
                return item.previewURL == sourceURL
            }) else { return }
            self.activeTracks.remove(at: index)
            self.delegate?.didWithErrorFinishDownloading(sourceURL, error: error)
        }
    }
    // Updates progress info
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url,
            let download = self.activeDownloads[url]  else { return }
        download.track.downloadData.progress = download.progress
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalFileSize = self.calculateFileSizeInUnit(totalBytesExpectedToWrite)
        let totalFileSizeUnit = self.calculateUnit(totalBytesExpectedToWrite)
        let downloadedFileSize = self.calculateFileSizeInUnit(totalBytesWritten)
        let downloadedSizeUnit = self.calculateUnit(totalBytesWritten)
        download.file = String(format: "%.2f %@", totalFileSize, totalFileSizeUnit)
        download.downloadedFile = String(format: "%.2f %@", downloadedFileSize, downloadedSizeUnit)
        download.track.downloadData.file = download.file
        download.track.downloadData.downloadedFile = download.downloadedFile
        let JSONString = Mapper().toJSONString(download.track.downloadData, prettyPrint: true) ?? ""
        downloadTask.taskDescription = JSONString
        if delegate != nil {
            delegate?.didLoadtimeRange(url)
        }
    }
    /// Save Downloaded File
    func downloadCompleted(_ status: Bool, location: URL, downloadUrl: URL, downloadData: CSDownloadModel) {
        self.presentNotificationForDownload(
            data: downloadData, notifBody: NSLocalizedString("Download Completed", comment: "Download"))
        FetchDataBaseData.saveFileData(parentView: self, downloadUrl: location,
                                       detail: downloadData, completionHandler: { _ in })
    }
    /// Download complete With error
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url, let download = self.activeDownloads[url] else { return }
        let err = error as NSError?
        if (err?.userInfo[NSURLErrorBackgroundTaskCancelledReasonKey] as? NSNumber)?.intValue
            == NSURLErrorCancelledReasonUserForceQuitApplication ||
            (err?.userInfo[NSURLErrorBackgroundTaskCancelledReasonKey] as? NSNumber)?.intValue
            == NSURLErrorCancelledReasonBackgroundUpdatesDisabled {
            let downloadTask = (task as? URLSessionDownloadTask)!
            let resumeData = err?.userInfo[NSURLSessionDownloadTaskResumeData] as? Data ?? Data()
            var newTask = downloadTask
            if self.isValidResumeData(resumeData) {
                newTask = self.downloadsSession.downloadTask(withResumeData: resumeData)
            } else {
                newTask = self.downloadsSession.downloadTask(with: url)
            }
            newTask.taskDescription = downloadTask.taskDescription; download.task = newTask
        } else {
            if err?.code == NSURLErrorCancelled || err == nil {
                guard let index = self.activeTracks.firstIndex(where: { (item) -> Bool in
                    return item.previewURL == url
                }) else { return }
                self.activeTracks.remove(at: index); activeDownloads[url] = nil
                download.isDownloading = false
                if err == nil {
                    self.delegate?.didFinishDownloading(url)
                } else {
                    self.delegate?.didWithErrorFinishDownloading(url, error: err!)
                }
            } else {
                let resumeData = err?.userInfo[NSURLSessionDownloadTaskResumeData] as? Data
                let downloadTask = (task as? URLSessionDownloadTask)!; var newTask = downloadTask
                if self.isValidResumeData(resumeData) == true {
                    newTask = self.downloadsSession.downloadTask(withResumeData: resumeData!)
                } else {
                    newTask = self.downloadsSession.downloadTask(with: url)
                }
                newTask.taskDescription = task.taskDescription
                download.task = newTask; download.isDownloading = true
                if let error = err {
                    self.delegate?.didWithErrorFinishDownloading(url, error: error)
                } else {
                    let error: NSError = NSError(domain: "Heeroz Download", code: 1000,
                                                 userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                    self.delegate?.didWithErrorFinishDownloading(url, error: error)
                }
            }
        }
    }
    fileprivate func isValidResumeData(_ resumeData: Data?) -> Bool {
        guard resumeData != nil || (resumeData?.count ?? 0) > 0 else {
            return false
        }
        return true
    }
    func downloadTasks() {
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        downloadsSession.getTasksWithCompletionHandler { (_, _, downloadTasks) -> Void in
            for tasksdata in downloadTasks {
                if let responceData = Mapper<CSDownloadModel>().map(JSONString: tasksdata.taskDescription!),
                    let downloadUrl = tasksdata.originalRequest?.url {
                    let data = CSTrack.init(previewURL: downloadUrl, video: responceData)
                    self.activeTracks.append(data)
                    let download = CSDownload(track: data)
                    download.task = tasksdata
                    download.progress = responceData.progress
                    download.file = responceData.file
                    download.downloadedFile = responceData.downloadedFile
                    download.task?.taskDescription = tasksdata.taskDescription
                    if tasksdata.state == .running {
                        download.isDownloading = true
                    } else if tasksdata.state == .suspended {
                        download.isDownloading = false
                    }
                    self.activeDownloads[download.track.previewURL] = download
                } else {
                    tasksdata.cancel()
                }
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
extension CSDownloadManager: URLSessionDelegate {
    // Standard background session handler
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler =
                appDelegate.backgroundSessionCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }
    /// Resent Notification
    func presentNotificationForDownload(data: CSDownloadModel,
                                        notifBody: String) {
        let application = UIApplication.shared
        DispatchQueue.main.async {
            let applicationState = application.applicationState
            if applicationState == UIApplication.State.background {
                // Create Notification Content
                let notificationContent = UNMutableNotificationContent()
                // Configure Notification Content
                notificationContent.title = "Heeroz"
                notificationContent.subtitle = data.title
                notificationContent.body = notifBody
                notificationContent.sound = .default
                // Add Trigger
                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                // Create Notification Request
                let notificationRequest = UNNotificationRequest(identifier: "Heeroz",
                                                                content: notificationContent,
                                                                trigger: notificationTrigger)
                // Add Request to User Notification Center
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if error != nil {
                    }
                }
            }
        }
    }
    @objc public func calculateFileSizeInUnit(_ contentLength: Int64) -> Float {
        let dataLength: Float64 = Float64(contentLength)
        if dataLength >= (1024.0*1024.0*1024.0) {
            return Float(dataLength/(1024.0*1024.0*1024.0))
        } else if dataLength >= 1024.0*1024.0 {
            return Float(dataLength/(1024.0*1024.0))
        } else if dataLength >= 1024.0 {
            return Float(dataLength/1024.0)
        } else {
            return Float(dataLength)
        }
    }
    @objc public func calculateUnit(_ contentLength: Int64) -> String {
        if contentLength >= (1024 * 1024 * 1024) {
            return "GB"
        } else if contentLength >= (1024 * 1024) {
            return "MB"
        } else if contentLength >= 1024 {
            return "KB"
        } else {
            return "Bytes"
        }
    }
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
extension CSDownloadManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
extension URL {
    func urlToImage() -> Data {
        do {
            let asset = AVURLAsset(url: self, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 4, timescale: 5), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail.jpegData(compressionQuality: 0.75) ?? Data()
        } catch _ {
            return Data()
        }
    }
}
