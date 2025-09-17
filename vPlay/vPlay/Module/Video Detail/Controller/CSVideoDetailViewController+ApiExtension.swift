/*
 * CSVideoDetailViewController+ApiExtension.swift
 * This is a extension of Video Detail Controller which request for requesting Api
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import Foundation
import UIKit
// MARK: - Call Api Request
extension CSVideoDetailViewController {
    // Video Detail
    func fetchVideoDetail() {
        CSVideoDetailApiModel.fetchVideoDetailRequest(
            parentView: self,
            parameters: nil,
            videoId: videoId,
            categoryId: categoryId,
            completionHandler: { [unowned self] responce in
                self.hideSkeleton()
                self.videoDetailData(responce.responseRequired)
                self.videoDetailResponse = responce.responseRequired
                self.bindDataToComment(comment: responce.responseRequired.commentPageData)
                self.dowwnloadLabel.text = NSLocalizedString("Video Download", comment: "VideoDetail")
                if UIApplication.isUserLoginInApplication() {
                    self.checkFileExistInOffline()
                }
        })
    }
    func fetchXray() {
        CSVideoDetailApiModel.fetchXray(parentView: self, parameters: nil, videoId: videoId) { (response) in
            self.xrayResponse = response.response
            //self.xrayCastInfos = response.response.castInfo
            self.customDelegate?.xrayButton.isHidden = self.xrayCastInfos.count == 0 ? true : false
            self.xrayTableView.reloadData()
        }
    }
    /// Web series
    func webSeries() {
        let paramet: [String: String] = [
            "page": String(relatedCurrentPage)]
        CSVideoDetailApiModel.webseriesSeasonBasedRelated(
            parentView: relatedCollection,
            path: String(videoId) + "/" + String(self.showSeasonView.tag),
            isPageDisable: relatedCurrentPage.checkPageNeed(),
            parameters: paramet,
            completionHandler: { responce in
                if let relatedDetail = responce.responseRequired.seasonVideo {
                    self.relatedVideo += relatedDetail.movieList
                    self.relatedLastPage = relatedDetail.lastPage
                    self.relatedCurrentPage = relatedDetail.currentPage
                }
                self.bindDataToRelatedVideo()
        })
    }
    /// Comment List
    func bindDataToComment(comment: CommentResponces) {
        self.lastPage = comment.commentLastPage
        self.currentPage = comment.commentCurrentPage
        self.countView.tag = comment.commentTotal
        self.commentLoadData(comment.commentDetailArray)
    }
    /// Binding Sprite Image
    func bindSpriteImage() {
        if !spriteUrl.isEmpty {
            playerView.setPreviewImage(spriteImage)
        }
    }
    /// Add Video to Favourite
    func addToFavouriteVideo(_ sender: UIButton) {
        let paramet: [String: String] = ["video_slug": String(videoId)]
        CSHomeApiModel.addFavouriteRequest(
            parentView: self, parameters: paramet, buttonObject: sender,
            completionHandler: { [unowned self] _ in
                self.favouriteButton.tag = 1
                self.delegate?.favouriteDelegate(1, videoId: self.videoId)
                self.favouriteButton.setSelected(selected: true, animated: true)
        })
    }
    /// Remove Video from Favourite
    func removeFromFavouriteVideo(_ sender: UIButton) {
        let paramet: [String: String] = ["video_slug": String(videoId)]
        CSHomeApiModel.removeFavouriteRequest(
            parentView: self, parameters: paramet, buttonObject: sender,
            completionHandler: { [unowned self] _ in
                self.favouriteButton.tag = 0
                self.delegate?.favouriteDelegate(0, videoId: self.videoId)
                self.favouriteButton.setSelected(selected: false, animated: true)
        })
    }
    /// Open Option Button
    func setupOption(_ sender: UIButton) {
        let parameter: [String: String] =
            ["videoSlug": self.relatedVideo[sender.tag].slug,
             "videoId": String(self.relatedVideo[sender.tag].movieId),
             "videoImage": self.relatedVideo[sender.tag].posterImage,
             "videoTitle": self.relatedVideo[sender.tag].title,
             "videoDescription": self.relatedVideo[sender.tag].description]
        CSOptionDropDown.dropDownMenu(popUpButton: sender,
                                      controller: self,
                                      parametr: parameter)
    }
    /// Add Comment
    func addCommentToVideo(_ sender: UIButton) {
        let paramet: [String: String] = [ "video_id": String(videoId),
                                          "comment": commentTextView.text!]
        CSVideoDetailApiModel.addCommentToVideo(
            parentView: self, button: sender,
            parameters: paramet,
            completionHandler: { response in
                self.lastPage = response.responseRequired.commentLastPage
                self.currentPage = response.responseRequired.commentCurrentPage
                self.countView.tag = response.responseRequired.commentTotal
                self.commentArray = [CommentsList]()
                self.commentLoadData(response.responseRequired.commentDetailArray)
                self.commentTextView.text! = ""
                self.changePlaceHolderPostion()
                self.heightConstantTextField.constant = 30
                DispatchQueue.main.async {
                    self.scrollView.scrollRectToVisible((self.countView.superview?.frame)!,
                                                        animated: true)
                }
        })
    }
    /// Set Url Video Player
    func setVideoPlayer() {
        //  if isLive { return }
        CSVideoDetailApiModel.setPlayerUrlResolution(
            parentView: self,
            url: self.videoUrl) {(response) in
                self.urlAndResolutionSets = response
                self.autoPlayVideo()
        }
    }
    /// Track The Video
    func trackVideo() {
        if !UIApplication.isUserLoginInApplication() {
            return
        }
        // parameter set
         let paramet: [String: String] = ["video_id": String(videoId)]
        CSVideoDetailApiModel.trackVideo(parentView: self,
                                         parameters: paramet,
                                         videoId: String(self.videoId),
                                         completionHandler: { _ in })
    }
    func newTrackVideo() {
        if !UIApplication.isUserLoginInApplication() {
            return
        }
        // parameters
        let paramet: [String: String] = ["video_slug": String(videoId)]
        CSVideoDetailApiModel.newTrackVideo(self, parameters: paramet,
                                         completionHandler: { _ in })
    }
    func callWatchTime() {
        if isFifteenPrecent && payWallView.isHidden {
            // let duration = String(format: "%f", lastTime)
            let status = (lastTime >= totalDuration) ? "Completed" : "Progress"
            let params: [String: Any] = ["video_slug": currentSlug,
                                            "video_duration": lastTime,
                                            "video_play_status": status]
            print("Params \(params)")
            CSVideoDetailApiModel.watchTimeAPI(self, parameters: params,
                                             completionHandler: { _ in })

        }
    }
    /// Unfollow Playlist
    func followPlaylist() {
        let paramets: [String: String] = ["playlist_slug": String(categoryId)]
        CSHomeApiModel.followPlayListRequest(parentView: self, parameters: paramets,
                                             completionHandler: { _ in
                                                self.playListFollowImage.image = #imageLiteral(resourceName: "playlist-save")
                                                self.playListFollowImage.tag = 1
        })
    }
    /// Follow Playlist
    func unfollowPlaylist() {
        let paramets: [String: String] = ["playlist_slug": String(categoryId)]
        CSHomeApiModel.unfollowPlayListRequest(parentView: self, parameters: paramets,
                                               completionHandler: { _ in
                                                self.playListFollowImage.image = #imageLiteral(resourceName: "playlist-add")
                                                self.playListFollowImage.tag = 0
        })
    }
    /// Like Video or nutural Video
    func likeVideo(isLike: Int, unlikeButton: UIButton) {
        let paramets: [String: String] = ["video_id": String(videoId),
                                          "status": String(isLike)]
        CSHomeApiModel.likeAVideo(parentView: self, parameters: paramets, buttonObject: unlikeButton,
                                  completionHandler: { _ in
                                    self.likeButton.tag = isLike
                                    if self.likeButton.tag == 1 {
                                        self.likeCount.tag += 1
                                    } else {
                                        self.likeCount.tag -= 1
                                    }
                                    self.likeAndNeutral(true)
        })
    }
    /// Unlike Video or nutural Video
    func unlikeVideo(isDisLike: Int, unlikeButton: UIButton) {
        let paramets: [String: String] = ["video_id": String(videoId),
                                          "status": String(isDisLike)]
        CSHomeApiModel.disLikeAVideo(parentView: self, parameters: paramets, buttonObject: unlikeButton,
                                     completionHandler: { _ in
                                        self.unLikeButton.tag = isDisLike
                                        if isDisLike == 1 {
                                            self.disLikeCount.tag += 1
                                        } else {
                                            self.disLikeCount.tag -= 1
                                        }
                                        self.dislikeAndNeutral(true)
        })
    }
    // Comment for api
    func callApiCommentList() {
        let paramet: [String: String] = ["video_id": String(videoId),
                                         "page": String(currentPage)]
        CSVideoDetailApiModel.viewAllCommentToVideo(
            parentView: self, parameters: paramet,
            isPageDisable: currentPage.checkPageNeed(), button: self,
            completionHandler: { responce in
                self.lastPage = responce.responseRequired.commentLastPage
                self.countView.tag = responce.responseRequired.commentTotal
                self.currentPage = responce.responseRequired.commentCurrentPage
                if self.currentPage == 1 {
                    self.commentArray = [CommentsList]()
                }
                self.commentLoadData(responce.responseRequired.commentDetailArray)
        })
    }
    // Recent for api
    func callRelatedVideos() {
        let paramet: [String: String] = [
            "type": "related",
            "id": String(self.videoId),
            "playlist_id": !isPlaylist ? "" : String(self.categoryId),
            "page": String(relatedCurrentPage)]
        CSVideoDetailApiModel.fetchRelatedVideo(
            parentView: self,
            parameters: paramet,
            isPageDisable: false,
            completionHandler: { responce in
                self.relatedCurrentPage = responce.homePageMovieMore.currentPage
                self.relatedLastPage = responce.homePageMovieMore.lastPage
                self.relatedVideo += responce.homePageMovieMore.movieList
                self.bindDataToRelatedVideo()
        })
    }
    func deleteComment(_ sender: UIButton) {
        if self.commentArray.count < 1 { return }
        CSVideoDetailApiModel.deleteCommentAction(
            parentView: sender, commentId: self.commentArray[sender.tag].commentId,
            completionHandler: { [unowned self] _ in
                self.commentArray.remove(at: sender.tag)
                self.countView.tag -= 1
                self.selectComment()
        })
    }
    func fetchDownloadUrlFile() {
        if isLive { return }
        CSVideoDetailApiModel.getDownloadURL(
            parentView: self, videoId: String(videoId),
            completionHandler: { [unowned self] responce in
                self.downloadUrl = (responce.downloadResponc.encPath).aesDoubleDecrypString()
                if !self.downloadUrl.isEmpty {
                    self.didLoadtimeRange(URL.init(string: self.downloadUrl)!)
                }
        })
    }
    /// Check Video is Exist in Offline Mode
    func checkFileExistInOffline() {
        FetchDataBaseData.checkFileExist(
            parentView: self, assertId: String(self.videoId),
            completionHandler: { [unowned self] responce in
                if responce {
                    self.progressBar.isHidden = false
                    self.downloadImage.tintColor = .themeColorButton()
                    self.progressBar.startProgress(to: 100, duration: 1)
                    self.dowwnloadLabel.text = NSLocalizedString("Video Downloaded", comment: "VideoDetail")
                } else {
                    self.fetchDownloadUrlFile()
                }
        })
    }
    /// Add Alert With title and Message
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"),
                                      style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
/// MARK : - Download Delegate
extension CSVideoDetailViewController: CSDownloaderDelegate {
    /// Download api
    func downloadApiCall() {
        if isLive { return }
        if !UIApplication.isUserLoginInApplication() {
            playerView.pause(); self.addLoginCloseIfUserNotLogin(self)
            return
        }
        if !LibraryAPI.sharedInstance.isUserSubscibed() {
            self.performSegue(withIdentifier: "SubscriptionPage", sender: nil)
            return
        }
        if downloadUrl.isEmpty { return }
        if !self.downloadUrl.contains("mp4") {
            self.showAlertView(
                title: NSLocalizedString("Download Error", comment: "Error"),
                message: NSLocalizedString("Unfortunately Download Error",
                                           comment: "Error"))
            return
        }
        self.progressBar.isHidden = false
        let url = URL.init(string: self.downloadUrl)!
        guard let index = CSDownloadManager.shared.activeTracks.firstIndex(where: { (item) -> Bool in
            return item.previewURL == url
        }) else {
            self.progressBar.isHidden = false
            let url = URL.init(string: self.downloadUrl)!
            let data = CSDownloadModel.init()
            data.assertId = String(self.videoId);
            data.title = (self.titleLabel?.text)!
            data.desciption = self.videoDescription;
            data.castCrew = (self.starring?.text)!
            if self.playerImage.image != nil {
                let imageData: Data? = self.playerImage.image!.jpegData(compressionQuality: 0.25) ?? Data()
                let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                data.thumbNail = imageStr
            }
            data.type = url.pathExtension
            CSDownloadManager.shared.addDownloadData(url, videoData: data, parentView: self)
            return
        }
        let track = CSDownloadManager.shared.activeTracks[index]
        if track.downloadData.assertId == String(videoId) {
            if self.dowwnloadLabel.tag == 2 {
                CSDownloadManager.shared.pauseDownload(track)
            } else if self.dowwnloadLabel.tag == 1 {
                CSDownloadManager.shared.resumeDownload(track)
            }
            self.changeDownloadStatusOnNetworkError(url)
        }
    }
    func changeDownloadStatusOnNetworkError(_ url: URL) {
        guard let currentDownloadUrl = URL.init(string: self.downloadUrl), url == currentDownloadUrl,
            let download = CSDownloadManager.shared.activeDownloads[url] else { return }
        let downloadProgress = download.progress
        let downloadPercentage = String(format: "%.2f", (downloadProgress * 100)) + "%"
        DispatchQueue.main.async {
            self.progressBar.isHidden = false
            if !download.isDownloading && (downloadProgress * 100) > 0.01 {
                self.dowwnloadLabel.text = NSLocalizedString("Resume", comment: "Download")
                self.dowwnloadLabel.textAlignment = .left
                self.dowwnloadLabel.tag = 1
            } else {
                self.dowwnloadLabel.tag = 2
                self.dowwnloadLabel.text = downloadPercentage
                self.dowwnloadLabel.textAlignment = .center
            }
        }
    }
    func didLoadtimeRange(_ url: URL) {
        guard let currentDownloadUrl = URL.init(string: self.downloadUrl),
            url == currentDownloadUrl, let download = CSDownloadManager.shared.activeDownloads[url] else { return }
        let downloadProgress = download.progress
        let downloadPercentage = String(format: "%.2f", (downloadProgress * 100)) + "%"
        DispatchQueue.main.async {
            self.progressBar.isHidden = false
            if !download.isDownloading && (downloadProgress * 100) > 0.01 {
                self.dowwnloadLabel.text = NSLocalizedString("Resume", comment: "Download")
                self.dowwnloadLabel.tag = 1
            } else {
                self.dowwnloadLabel.tag = 2
                self.dowwnloadLabel.text = downloadPercentage
                self.dowwnloadLabel.textAlignment = .center
            }
            let data = CGFloat((downloadProgress * 100))
            self.progressBar.startProgress(to: data, duration: 0)
        }
    }
    func didFinishDownloading(_ url: URL) {
        guard let currentDownloadUrl = URL.init(string: self.downloadUrl), url == currentDownloadUrl else { return }
        DispatchQueue.main.async { [unowned self] in
            self.downloadImage.tintColor = .themeColorButton()
            self.progressBar.startProgress(to: 100, duration: 0)
            self.dowwnloadLabel.text = NSLocalizedString("Video Downloaded", comment: "VideoDetail")
            self.dowwnloadLabel.textAlignment = .left
        }
    }
    func didWithErrorFinishDownloading(_ url: URL, error: NSError) {
        if let currentDownloadUrl = URL.init(string: self.downloadUrl), url == currentDownloadUrl {
            DispatchQueue.main.async { [unowned self] in
                self.progressBar.isHidden = true
                self.dowwnloadLabel.text = NSLocalizedString("Video Download", comment: "VideoDetail")
                self.dowwnloadLabel.textAlignment = .left
//                self.showAlertView(error: error)
            }
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
@objc protocol CSVideoDetailDelegate: class {
    func favouriteDelegate(_ favourite: Int, videoId: Int)
    @objc optional func videoDetailReload(_ videoId: Int, category: String)
}
extension CSVideoDetailViewController {
    /* Signal the requested style for the view. */
    func setNavigationBarStyle() {
        self.edgesForExtendedLayout = .all
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.isResetEdgesOnDisappear = false
    }
}
