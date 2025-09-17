/*
 * CSVideoDetailViewController+PaginationAnd User Defined Delegated.swift
 * This is a Controller class is used for Video Detail Data  Pagination Value and User Defined Delegates
 * Which controll the Functionality of Video Detail Data
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import GoogleCast
// MARK: - vertical pagenation for
extension CSVideoDetailViewController: PaginationManagerDelegate {
    /// register Refresh controller adding
    func registerRefreshIndicator() {
        profileImage.setProfileImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
        self.paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)
        self.paginatioManager.updateActivityIndicatorColor(UIColor.black)
        /* If you want to use Horizontal Pagination */
        self.horizontalPaginationManager = HorizontalPaginationManager(scrollView: self.relatedCollection, delegate: self)
        self.horizontalPaginationManager.updateActivityIndicatorColor(UIColor.black)
        self.seasonDropImageView.image = UIImage.localImage("dropdownFilledBlack", template: true)
    }
    public func paginationManagerDidStartLoading(_ controller: PaginationManager,
                                                 onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
            self.callApiCommentList()
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
// MARK: - CSReply Delegate
extension CSVideoDetailViewController: CSReplyCommentDelegate {
    /// Close Comment View
    func closeCommentView(_ controller: UIViewController) {
        LibraryAPI.sharedInstance.currentController = self
        self.scrollView.isScrollEnabled = true
        registerKeyboardNotifications()
        self.replyCommentBaseView.isHidden = true
        replyCommentBaseView.tag = 0
        controller.view.removeFromSuperview()
    }
    /// Change Data
    func replyCommentAddedView(_ replyCommentCount: Int, commentTime: String, commentId: String) {
        guard let index = self.commentArray.firstIndex(where: { (item) -> Bool in
            item.commentId == commentId
        }) else { return }
        guard let cell = self.commentTable.cellForRow(at:
            IndexPath(row: index, section: 0)) as? CSVideoQAndATableViewCell else { return }
        self.commentArray[index].commentReplyComment.commentTotal = replyCommentCount
        self.commentArray[index].commentCreatedAt = commentTime
        commentTableDataSource.commentList[index].commentReplyComment.commentTotal = replyCommentCount
        commentTableDataSource.commentList[index].commentCreatedAt = commentTime
        cell.cellCommentsTime.text = commentTime
        cell.showReplyCount(self.commentArray[index].commentReplyComment.commentTotal)
    }
}
// MARK: - Collection View Delegate
extension CSVideoDetailViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callWatchTime()
        self.videoId = self.relatedVideo[indexPath.row].movieId
        self.playerView.pause()
        self.playerView.playerLayer?.resetPlayer()
        customDelegate?.currentTimeLabel.text = "00:00"
        customDelegate?.totalTimeLabel.text = "00:00"
        customDelegate?.timeSlider.value = 0
        customDelegate?.progressView.progress = 0
        self.downloadUrl = ""
        self.progressBar.resetProgress()
        self.progressBar.isHidden = true
        self.dowwnloadLabel.text = NSLocalizedString("Video Download", comment: "VideoDetail")
        self.playerImage.image = nil
        if let timer = timerVideo?.isValid, timer {
            isScheduledLiveVideo = false
            self.hideTimerView()
            timerVideo?.invalidate()
            timerVideo = nil
        }
        if let videoTime = videoKeyTimer?.isValid, videoTime {
            videoKeyTimer?.invalidate()
            videoKeyTimer = nil
        }
        self.commentArray = [CommentsList]()
        self.commentTable.reloadData()
        isFifteenPrecent = false
        callApi()
        DispatchQueue.main.async { self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true) }
        if GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession() {
            LibraryAPI.sharedInstance.getMedia(self.relatedVideo[indexPath.row].posterImage, self.relatedVideo[indexPath.row].thumbNailImage,
                                               title: self.relatedVideo[indexPath.row].title, url: self.relatedVideo[indexPath.row].videoUrl) }
    }
    func collectionViewDidScroll(_ scrollView: UIScrollView) {
    }
}
// MARK: - Delegate
extension CSVideoDetailViewController: CSVideoDetailDelegate {
    func favouriteDelegate(_ favourite: Int, videoId: Int) {
        guard let index = self.relatedCollectionDataSource.relatedVideo.firstIndex(where: { $0.movieId == videoId })
            else { return }
        self.relatedCollectionDataSource.relatedVideo[index].isFavourite = favourite
        self.relatedVideo[index].isFavourite = favourite
        if let cell = self.relatedCollection.cellForItem(at:
            IndexPath(row: index, section: 0)) as? HomeCollectionViewCell {
            cell.checkVideoFavourite(favourite)
        }
        self.delegate?.favouriteDelegate(favourite, videoId: videoId)
    }
    func videoDetailReload(_ videoId: Int, category: String) {
        self.videoId = videoId
        self.categoryId = category
        //self.setHideView(view: self.subscriptionView, hidden: true)
        playerImage.image = nil
        self.fetchVideoDetail()
    }
}
extension CSVideoDetailViewController: HorizontalPaginationManagerDelegate {
    public func horizontalPaginationManagerShouldStartLoading(_ controller: HorizontalPaginationManager) -> Bool {
        if (relatedCurrentPage + 1) <= relatedLastPage {
            relatedCurrentPage += 1
            if self.isWebSeries == 0 && !self.isLive {
                self.callRelatedVideos()
            } else if self.isWebSeries == 1 {
                self.webSeries()
            }
        }
        return false
    }
    public func horizontalPaginationManagerDidStartLoading(_ controller: HorizontalPaginationManager,
                                                           onCompletion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            onCompletion()
        }
    }
}
extension CSVideoDetailViewController: ControlViewDelegate {
    func closeChatview() {
        if let controller = LibraryAPI.sharedInstance.currentController as? CSLiveChatTableView {
            self.view.endEditing(true)
            LibraryAPI.sharedInstance.currentController = self
            self.scrollView.isScrollEnabled = true
            registerKeyboardNotifications()
            self.replyCommentBaseView.isHidden = true
            replyCommentBaseView.tag = 0
            controller.view.removeFromSuperview()
        }
    }
    func didtapXray(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        sender.isSelected ? showXrayView() : dismissXrayView()
        sender.backgroundColor = sender.isSelected ? UIColor.white : UIColor.clear
        sender.setTitleColor(sender.isSelected ? UIColor.black : UIColor.white, for: .normal)
    }
    func didtapChatbutton(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.isSelected  = !sender.isSelected
        liveChatView.isHidden = sender.isSelected ? true : true
        sender.isSelected ? customDelegate?.chatButton.setImage(UIImage.init(named: "chat-show"), for: .selected) : customDelegate?.chatButton.setImage(UIImage.init(named: "chat-hide"), for: .selected)
    }
    func didtapXrayViewAll(_ sender: UIButton) {
        customDelegate?.xrayButton.isSelected = false
        dismissXrayView()
        customDelegate?.xrayButton.backgroundColor = UIColor.clear
        customDelegate?.xrayButton.setTitleColor(UIColor.white, for: .normal)
        self.playerView.pause()
        UIView.animate(withDuration: 0.4) { self.xrayView.alpha = 1 }
    }
    
    func didTapqueue() {
        let castStart = GCKCastContext.sharedInstance().sessionManager
        let castContext = castStart.currentCastSession?.remoteMediaClient?.mediaStatus?.queueItemCount
        if castContext != 0 && castContext != nil {
            let screen = downloadStoryBoard.instantiateViewController(withIdentifier: "CSOfflineViewController") as? CSParentViewController
            screen?.controllerTitle = NSLocalizedString("Queue List", comment: "Menu")
            let navController = UINavigationController(rootViewController: screen!)
            self.present(navController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                LibraryAPI.sharedInstance.currentController
                    .showToastMessageTop(message: NSLocalizedString("No Video is added to queue.", comment: "Success")) }
        }
    }
    /// Post Button Action
    @IBAction func postAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if !UIApplication.isUserLoginInApplication() {
            playerView.pause(); self.addLoginCloseIfUserNotLogin(self)
            return }
        if (commentTextView.text?.isEmpty)! {
            self.showToastMessageTop(message: NSLocalizedString("Please enter a text to post",
                                                                comment: "Video Detail"))
            return }
        addCommentToVideo(sender)
    }
    /// share Action
    @IBAction func liveChatButton(_ sender: UIButton) {
        let controller = videoDetailStoryBoard.instantiateViewController(withIdentifier:
            "CSLiveChatTableView") as? CSLiveChatTableView
        controller?.chatDelegate = self
        controller?.videoId = videoId
        controller?.titleName = titleLabel.text
        controller?.view.frame = self.replyCommentBaseView.bounds
        controller?.willMove(toParent: self)
        self.replyCommentBaseView.addSubview((controller?.view)!)
        self.addChild(controller!)
        controller?.didMove(toParent: self)
        self.replyCommentBaseView.isHidden = true
        replyCommentBaseView.tag = 1
        LibraryAPI.sharedInstance.currentController = self
    }
    /// share Action
    @IBAction func shareAction(_ sender: UIButton) {
        playerView.pause()
        self.deepLinkShare(sharedData, sender: sender, isVideoDetail: true)
    }
    @IBAction func payWallPremiumAction(_ sender: UIButton) {
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        self.performSegue(withIdentifier: "SubscriptionPage", sender: nil)
    }
    /// Like Api Or Nuteural
    @IBAction func likeNuterualAction(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() {
            playerView.pause()
            self.addLoginCloseIfUserNotLogin(self)
            return }
        if likeButton.tag == 0 {
            likeVideo(isLike: 1, unlikeButton: sender)
        } else { likeVideo(isLike: 0, unlikeButton: sender) }
    }
    /// Move To Reply Comment View
    @IBAction func unLikeImage(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() {
            playerView.pause(); self.addLoginCloseIfUserNotLogin(self)
            return }
        if unLikeButton.tag == 0 {
            unlikeVideo(isDisLike: 1, unlikeButton: sender)
        } else { unlikeVideo(isDisLike: 0, unlikeButton: sender) }
    }
    /// Open Option Button
    @IBAction func openOptionButton(_ sender: UIButton) {
        playerView.pause(); setupOption(sender)
    }
    /// Download Video
    @IBAction func downloadButton(_ sender: UIButton) {
        self.downloadApiCall()
    }
    /// Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        if !self.playerImage.superview!.isHidden {
            if let data = playerView {
                data.avPlayer?.replaceCurrentItem(with: nil)
                data.playerLayer?.player = nil
            }
            timerVideo?.invalidate()
            timerVideo = nil
            videoKeyTimer?.invalidate()
            videoKeyTimer = nil
            tableContentSize?.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
    }
    /// Add Related Video To Facourite
    @IBAction func relatedFavouriteVideo(_ sender: UIButton) {
        if !UIApplication.isUserLoginInApplication() {
            playerView.pause(); self.addLoginCloseIfUserNotLogin(self)
            return }
    }
    /// Move To Reply Comment View
    @IBAction func replyCommentAction(_ sender: UIButton) {
        if sender.titleLabel!.text == "Reply" && !UIApplication.isUserLoginInApplication() {
            playerView.pause(); self.addLoginCloseIfUserNotLogin(self)
            return }
        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top),
                                         animated: true)
        self.scrollView.isScrollEnabled = false
        self.addReplyCommentView(commentArray[sender.tag])
    }
    /// Season Button Action
    @IBAction func onClickSeason() {
        if seasonDropDownList.count < 2 { return }
        CSOptionDropDown.seasonDropdown(
            label: showSeasonLabel,
            dataSource: seasonDropDownList,
            completionHandler: { index in
                self.relatedCurrentPage = 0; self.relatedLastPage = 0
                self.relatedVideo = [CSMovieData]()
                self.showSeasonView.tag = self.seasonList[index].seasonId
                self.webSeries()
        })
    }
    /// Season Button Action
    @IBAction func deleteCommentSender(_ sender: UIButton) {
        self.deleteComment(sender) }
}
// MARK: - CSReply Delegate
extension CSVideoDetailViewController: CSChatlistDelegate {
    /// Close Comment View
    func closeChat(_ controller: UIViewController) {
        self.view.endEditing(true)
        LibraryAPI.sharedInstance.currentController = self
        self.scrollView.isScrollEnabled = true
        registerKeyboardNotifications()
        self.replyCommentBaseView.isHidden = true
        replyCommentBaseView.tag = 0
        controller.view.removeFromSuperview()
}
}
