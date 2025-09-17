/*
 * CSVideoDetailViewController+Extension.swift
 * This is a extenstion class for video Detail page which contain Player method and Private
 *  method or user Definied Method
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import Foundation
import UIKit
import Alamofire
// MARK: - Private Method
extension CSVideoDetailViewController {
    /// Bind Video Data
    func bindVideoData(_ videoData: VedioDetail) {
        self.currentSlug = videoData.responseSlug
        self.sharedData = CSSharedObject.init(
            videoId: String(videoData.responseId), videoSlug: videoData.responseSlug,
            thumbNail: videoData.responcePosterImage, videoTitle: videoData.responseTitle,
            videoDescription: videoData.responseDescription)
        if videoData.isLive == 1 {
            LibraryAPI.sharedInstance.setUserDefaults(key: "videoId", value: String(videoData.responseId)) }
        titleLabel.text = videoData.responseTitle
        let array = String(videoData.price).components(separatedBy: ".")
        if Int(array[1]) == 0 || Int(array[1]) == 00 {
           buyButton.setTitle("BUY $" + String(array[0]), for: .normal)
        } else {
           buyButton.setTitle("BUY $" + String(videoData.price), for: .normal)
        }
        isPrice = videoData.price
        self.isLive = videoData.isLive == 1 ? true : false
        self.videoDescription =
            videoData.responseDescription.withoutHtmlTags.removingWhitespacesAndNewlines
        hideAndShowPremium(videoData.isPremium);
        googleAds(videoData.adsUrl, isPremium:videoData.isPremium)
        setDemoUser(videoData.reponceDemoStatus)
        // self.showVideoCountView(videoData.responceViewsCount)
        self.setDescription()
        playerImage.setBannerImageWithUrl(videoData.responcePosterImage)
        videoUrl = videoData.responceHLSPlaylistUrl.addingPercentEncoding(withAllowedCharacters:
            NSCharacterSet.urlQueryAllowed)!
        currentSub = videoData.subtitle
        if let playerViewable = (playerView.customControlView as? BMPlayerCustomControlView) {
            playerViewable.currentSubTitles = currentSub
        }
        spriteUrl = videoData.spriteImage
        if !spriteUrl.isEmpty {
            Alamofire.request(spriteUrl, method: .get)
                .validate()
                .responseData(completionHandler: { (responseData) in
                    self.spriteImage.image = UIImage(data: responseData.data!)
                    self.bindSpriteImage()
                })
        }
        getStartTimer(videoData.startTimer)
        isFenced = videoData.isRestricted
        self.setAutoPlayUser(videoData.responceAutoPlay)
        favouriteButton.tag = videoData.responceIsFavorite
        var newCategory = ""
        for content in videoData.newCategoryList {
            newCategory = newCategory + ", " + content
        }
        newCategory = String(newCategory.dropFirst(2))
        formateData(newCategory)
        if !isLive {
            videoCategory.text = CSTimeAgoSinceDate.setVideoDateAsMMMDDYYYY(videoData.responcePublished)
            videoCategory.isHidden = false
        } else {
            videoCategory.isHidden = true
        }
        setAgeClassification(videoData.ageRestriction)
        ageView.layoutIfNeeded()
        // showVideoCatgeoryAndGener(newCategory, videoData.generName)
        self.setFavouriteOrUnFavourite(videoData.responceIsFavorite)
        if videoData.responceThumbnailImage.isEmpty {
            let imageString: String = videoData.responceThumbnailImage.addingPercentEncoding(
                withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            thumbNailString = imageString}
        self.likeCount.tag = videoData.responceLikeCount
        self.disLikeCount.tag = videoData.responceDislikeCount; showLikeAndUnlikeCount()
        self.likeButton.tag = videoData.responceIsLike; likeAndNeutral(false)
        self.unLikeButton.tag = videoData.responceIsDislike
        dislikeAndNeutral(false); showLiveView()
        likeAndUnlikeView.isHidden = true
        setDataToStarring(videoData.starring)
        getTheVideoKey(videoData.videoKey)
        playVideoButton.isHidden = false
        restrictUI(videoData.responceAutoPlay)
    }
    // Restrict UI FOR TVOD & GEO FENCING
    func restrictUI(_ checkAutoplay: Int){
        if isPrice > 0 && isBought == 0 && !LibraryAPI.sharedInstance.isUserSubscibed() {
            //buyButtonView.isHidden = isFenced == 0 ? false : true
            playVideoButton.isHidden = self.isPremiumVideo == 1 && isFenced == 0 ? false : true
        } else {
            buyButtonView.isHidden = true
            if isPremiumVideo == 1 && isBought == 1 || LibraryAPI.sharedInstance.isUserSubscibed() && isBought == 0 {
                if checkAutoplay == 1 && isFenced == 0 { setVideoPlayer() }
            }
        }
        fencedContent.isHidden = isFenced == 0 ? true : true
    }
    /// Google ads
    func googleAds(_ adsURL: String, isPremium: Int) {
        isGoogleAds = (isPremium == 1) ? false : !adsURL.isEmpty
        kTestAppAdTagUrl = adsURL
        //self.setUpAdsLoader()
    }
    /// Get Video Key
    func getTheVideoKey(_ key: String) {
        print("Viedeo key Phrass:\(key)")
        let timeKey = key.aesDoubleDecrypString()
        self.videoKey = Int64(timeKey) ?? Int64()
        if isLive && !LibraryAPI.sharedInstance.isUserSubscibed() {
            self.addPlayerTimer()
        }
    }
    /// Video Count
    func showVideoCountView(_ count: Int) {
        self.viewsCount.text =  Double(count).shortStringRepresentation
        if viewsCount.text!.isEmpty {
            self.viewsCount.superview?.isHidden = true
        } else {
            self.viewsCount.superview?.isHidden = false
        }
    }
    /// To show skeleton view
    func showSkeleton() {
        self.playerImage.superview?.showSkeletionView()
        self.likeAndUnlikeView.showSkeletionView()
        self.relatedTitle.showSkeletionView()
        self.titleLabel.showSkeletionView()
        self.publishView.showSkeletionView()
        self.ageView.showSkeletionView()
        self.ageView.isHidden = true
        self.descriptionLabel.showSkeletionView()
        self.starring.showSkeletionView()
        self.starringTitle.showSkeletionView()
        self.favouriteShareNadPlaylist.showSkeletionView()
        self.commentCount.showSkeletionView()
        self.profileImage.superview?.showSkeletionView()
        self.buyButtonView.showSkeletionView()
    }
    /// To hide skeleton view
    func hideSkeleton() {
        self.playerImage.superview?.hideSkeleton()
        self.relatedTitle.hideSkeleton()
        self.titleLabel.hideSkeleton()
        self.publishView.hideSkeleton()
        self.ageView.hideSkeleton()
        self.ageView.isHidden = false
        self.descriptionLabel.hideSkeleton()
        self.starring.hideSkeleton()
        self.starringTitle.hideSkeleton()
        self.favouriteShareNadPlaylist.hideSkeleton()
        self.commentCount.hideSkeleton()
        self.likeAndUnlikeView.hideSkeleton()
        self.profileImage.superview?.hideSkeleton()
        self.buyButtonView.hideSkeleton()
    }
    func showVideoCatgeoryAndGener(_ category: String, _ gener: String) {
        var text = String()
        if category.isEmpty && gener.isEmpty {
            text = ""
        } else if category.isEmpty && !gener.isEmpty { text = gener
        } else if !category.isEmpty && gener.isEmpty { text = category
        } else {  text = category + " \u{2022} " + gener }
        videoCategory.attributedText = text.attributeTextProperty(
            appendtext: " \u{2022} ", color: UIColor.videoDetailStaticText, font: UIFont.fontNewLight())
    }
    /// To set dark mode needs
    func setDarkModeNeeds() {
        self.addGradientBackGround()
        /* Separator View Background */
        separatorLine.forEach({$0.backgroundColor = .separatorColor})
        dynamicTextLabel.forEach({$0.textColor = .labelTextColor})
        staticTextLabel.forEach({$0.textColor = .videoDetailStaticText})
        self.playerImage.superview?.backgroundColor = .background
        /* Related View Background */
        releatedHeaderView.backgroundColor = .navigationBarColor
        relatedCollection.backgroundColor = .navigationBarColor
        /* Comment View Background */
        commentTextView.textColor = .textFieldTextColor
        commentPlaceHolder.textColor = .videoDetailStaticText
        commentBackgroundView.backgroundColor = .navigationBarColor
    }
    /// Changes label color
    func setLabelColor(_ someViews: [UILabel]) {
        for currentLabel in someViews { currentLabel.textColor = UIColor.white }
    }
    /// Show Required View's
    func showView() {
        commentCount.isHidden = false
        likeAndUnlikeView.superview?.isHidden = false
        commenterView.isHidden = false
        likeAndUnlikeView.isHidden = false
        favouriteShareNadPlaylist.isHidden = false
    }
    /// Set Favourite Or UnFavourite
    func setFavouriteOrUnFavourite(_ status: Int) {
        favouriteButton.tag = status
        let isFavourite = status == 1 ? true : false
        favouriteButton.setSelected(selected: isFavourite, animated: !isFavourite)
    }
    /// Hide And Show Premium
    func hideAndShowPremium(_ isPremium: Int) {
        self.isPremiumVideo = isPremium
        hideShowPremium.constant = isPremium == 1 ? 0 : 0
    }
    /// Demo user Or Not
    func setDemoUser(_ isDemo: Int) {
        if isDemo == 1 {
            LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
        } else {
            LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "0")
        }
    }
    /// Auto Play On
    func setAutoPlayUser(_ isAutoPlay: Int) {
        self.playerView.isHidden = true
        if isScheduledLiveVideo {
            playNowButton.isHidden = true
            return
        }
        for view in (playerImage.superview?.subviews)! { view.isHidden = false }
        if isPremiumVideo == 1 && !LibraryAPI.sharedInstance.isUserSubscibed() {
            return
        }
        if  isPremiumVideo == 0 && !UIApplication.isUserLoginInApplication() {
            return
        }
        if isAutoPlay == 1 && isFenced == 0 { setVideoPlayer() }
    }
    /// Staring Data to cast and crew
    func setDataToStarring(_ starring: String) {
        if starring.isEmpty {
            self.starringTitle.text = ""
            self.starring.text = ""
        } else {
            self.starring.text = starring
            self.starringTitle.text = NSLocalizedString("Starring", comment: "videoDetail")
        }
    }
    /// Like And UnLike Count
    func showLikeAndUnlikeCount() {
        if self.likeCount.tag > 0 {
            self.likeCount.text = Double(self.likeCount.tag).shortStringRepresentation
        } else { self.likeCount.text = "" }
        if self.disLikeCount.tag > 0 {
            self.disLikeCount.text = Double(self.disLikeCount.tag).shortStringRepresentation
        } else { self.disLikeCount.text = "" }
    }
    /// Buration Formater
    func formateDuration(_ duration: String) {
        if duration.isEmpty {
            videoDuration.superview?.isHidden = true
            publishedDateHeight.constant = 17
            return
        }
        videoDuration.superview?.isHidden = false
        videoDuration.text = duration
    }
    /// Date Formater
    func formateData(_ date: String) {
        if date.isEmpty {
            publishedDate.superview?.isHidden = true
            return
        }
        publishedDateHeight.constant = (date.count > 20) ? 34 : 17
        publishedDate.superview?.isHidden = false
        publishedDate.text = date // CSTimeAgoSinceDate.setVideoDateAsMMMDDYYYY(date)
    }
    func setAgeClassification(_ age: String) {
        if age.isEmpty || age == "null" {
            ageView.isHidden = true
            ageHConstraint.constant = 0
            return
        }
        ageHConstraint.constant = 17
        if publishedDateHeight.constant == 34 {
            ageTopConstraint.constant = 20
        }
        ageView.isHidden = false
        ageClassification.text = age
    }
    /// Play List View
    func playListView(_ isfollow: Int) {
        self.playListFollowImage.tag = isFollow
        self.playListFollowImage.image = #imageLiteral(resourceName: "playlist-add")
        if isPlaylist {
            relatedTitle.text = controllerTitle
            relatedCollection.tag = 6
        } else {
            relatedCollection.tag = 4
        }
    }
    /// Comment And Queestion
    func selectComment() {
        commentTable.isHidden = true
        commentTable.tag = 0
        if countView.tag < 1 {
            countLabel.text = ""
            countView.isHidden = true
        } else {
            countView.isHidden = false
            countLabel.text = String(countView.tag)
        }
        let width = countView.frame.width
        countView.layer.cornerRadius = width/2
        countView.layer.masksToBounds = true
        noDataForTable.isHidden = true
        if isLive {
            self.commentArray.removeAll()
        }
        self.commentTableDataSource.commentList = self.commentArray
        if self.commentArray.count < 1 {
            noDataForTable.isHidden = false
            commentTable.isHidden = true
        }
        self.commentTable.reloadData()
        self.commentTable.layoutIfNeeded()
    }
    /// like And Neutral
    func likeAndNeutral(_ isAnimate: Bool) {
        if self.likeButton.tag == 1 {
            likeButton.setSelected(selected: true, animated: isAnimate)
            if unLikeButton.tag == 1 {
                self.unLikeButton.tag = 0
                unLikeButton.setSelected(selected: false, animated: false)
                self.disLikeCount.tag -= 1
            }
        } else {
            likeButton.setSelected(selected: false, animated: isAnimate)
        }
        showLikeAndUnlikeCount()
    }
    /// Dislike And Neutral
    func dislikeAndNeutral(_ isAnimate: Bool) {
        if unLikeButton.tag == 1 {
            unLikeButton.setSelected(selected: true, animated: isAnimate)
            if likeButton.tag == 1 {
                self.likeButton.tag = 0
                likeButton.setSelected(selected: false, animated: false)
                self.likeCount.tag -= 1
            }
        } else {
            unLikeButton.setSelected(selected: false, animated: isAnimate)
        }
        showLikeAndUnlikeCount()
    }
    /// Bind Data to related
    func bindDataToRelatedVideo() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.relatedCollectionHeight.constant = 225
        } else {
            relatedCollectionHeight.constant = 180
        }
        if relatedVideo.count > 0 && !isLive {
            if isPlaylist { relatedTitle.text = controllerTitle }
            relatedYAxis.constant = 10
            relatedCollection.isHidden = false
            relatedMore.isHidden = false
            relatedMore.superview?.isHidden = false
            relatedCollectionDataSource.delegate = self
            relatedCollectionDataSource.relatedVideo = relatedVideo
            relatedCollection.reloadData()
            relatedCollection.layoutIfNeeded()
            relatedCollectionHeight.constant = relatedCollection.contentSize.height
        } else {
            relatedYAxis.constant = 0
            relatedTitle.text = ""
            relatedCollection.isHidden = true
            relatedMore.isHidden = true
            relatedCollectionHeight.constant = 0
            relatedMore.superview?.isHidden = true
        }
        relatedMore.isHidden = true
    }
    /// Video Detail Responce
    func videoDetailData(_ responce: VideoResponse) {
        isBought = responce.paymentInformation?.isBought ?? 0
        transactionId = responce.paymentInformation?.transactionId ?? "0"
        if let videoData = responce.videoDict {
            LibraryAPI.sharedInstance.getMedia(videoData.responcePosterImage, videoData.responceThumbnailImage,
            title: videoData.responseTitle, url: videoData.responceHLSPlaylistUrl)
            self.bindVideoData(videoData)
            self.showSeasonLabel.text = videoData.selectedSeasonName.uppercased()
            self.showSeasonView.tag = videoData.selectedSeasonId
            self.seasonDropDownList = self.seasonList(responce.season,
                                                      categoryName: responce.videoDict.categoryName)
        }
        if let relatedDetail = responce.relatedVedioArray {
            self.relatedVideo = relatedDetail.data
            self.relatedLastPage = responce.relatedVedioArray.lastPage
            self.relatedCurrentPage = responce.relatedVedioArray.currentPage
        }
        relatedMore.isHidden = true
        self.bindDataToRelatedVideo()
    }
    /// Load Data To Comment View
    func commentLoadData(_ commentsList: [CommentsList]) {
        // Comment And Reply
        var commentListing = [CommentsList]()
        for comment in commentsList {
            commentListing.append(comment)
        }
        self.commentArray += commentListing
        self.selectComment()
    }
    /// Add reply Comment View
    func addReplyCommentView(_ commentData: CommentsList) {
        let controller = videoDetailStoryBoard.instantiateViewController(withIdentifier:
            "CSReplyCommentViewController") as? CSReplyCommentViewController
        controller?.replyDelegate = self
        controller?.commentData = commentData
        controller?.videoId = videoId
        controller?.view.frame = self.replyCommentBaseView.bounds
        controller?.willMove(toParent: self)
        self.replyCommentBaseView.addSubview((controller?.view)!)
        self.addChild(controller!)
        controller?.didMove(toParent: self)
        self.replyCommentBaseView.isHidden = true
        replyCommentBaseView.tag = 1
        LibraryAPI.sharedInstance.currentController = self
    }
    /// Add Observer to Table of comment
    func addObserverToTable() {
        tableContentSize = commentTable.observe(
            \UITableView.contentSize,
            options: [.new],
            changeHandler: { _, value  in
                if let contentSize = value.newValue {
                    if self.commentTableDataSource.commentList.count != 0 {
                        self.commentTableHeight.constant = 0
                    } else {
                        self.commentTableHeight.constant = 0
                    }
                }
        })
    }
    /// Season list
    func seasonList(_ seasonList: [CSSeason], categoryName: String) -> [String] {
        self.seasonList = [CSSeason]()
        self.seasonList = seasonList
        var seasonData = [String]()
        for season in seasonList {
            seasonData.append(season.seasonTitle.uppercased())
        }
        self.formateDuration(String(seasonData.count))
        isWebSeries = seasonData.count > 0 ? 1 : 0
        if seasonData.count < 2 {
            seasonDownImageWidth.constant = 0
        } else {
            seasonDownImageWidth.constant = 8
        }
        setUpWebseries(isWebSeries, categoryName: categoryName)
        return seasonData
    }
    /// Add Tap Gesture method
    func addTabGesture() {
        tapgesture = UITapGestureRecognizer(
            target: self, action: #selector(CSVideoDetailViewController.handleTap(sender:)))
        tapgesture.delegate = self
        self.view.addGestureRecognizer(tapgesture)
        tapgesture.isEnabled = false
    }
    @objc func handleTap(sender: Any) {
        self.view.endEditing(true)
    }
}
