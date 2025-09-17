/*
 * CSHomeCollectionCell.swift
 * A collection view to Display images in the HomePage
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import FaveButton
import SkeletonView
class CSHomeCollectionCell: CSBaseCollectionViewCell {
    /// Premium
    @IBOutlet weak var premiumView: UIView!
    /// Free
    @IBOutlet weak var freeView: UIView!
    /// video image
    @IBOutlet weak var videoDetailImage: UIImageView!
    /// video Label
    @IBOutlet weak var videoTitle: UILabel!
    /// Option Button
    @IBOutlet weak var openOptionImage: UIImageView!
    /// Favourite Button
    @IBOutlet weak var favouriteButton: FaveButton!
    /// Option Button
    @IBOutlet weak var openOptionButton: UIButton!
    /// Thumbnail View
    @IBOutlet weak var thumbNailView: UIView!
    /// Gesture Recognier
    var tapGesture: UITapGestureRecognizer!
    /// Video ID
    var videoID = Int()
    /// Parameter
    var parmeter = [String: String]()
    // MARK: - UIViewController Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        showSkelectionView()
        addTapGesture()
    }
    /// Show Skelection View
    func showSkelectionView() {
        self.favouriteButton.superview?.isHidden = true
        self.contentView.showSkeletionView()
    }
    /// Change Theme
    func changeTheme() {
        self.videoTitle.textColor = .labelTextColor
        self.videoTitle.superview?.backgroundColor = .homeCollectionBackground
        videoDetailImage.backgroundColor = UIColor.thumbnailDefaultColor
        if openOptionImage != nil {
            openOptionImage.tintColor = .navigationIconColor
        }
    }
    /// Hides Skeleton Animation
    func hideSkeletonAnimation() {
       
            self.contentView.hideSkeleton()
            self.changeTheme()

    }
    /// Web Series Video Data Bind
    func webseriesVideoData(_ vedioDetail: CSMovieData) {
        videoDetailImage.setImageWithUrl(vedioDetail.thumbNailImage)
        videoTitle.text = vedioDetail.categoryName
        hidePremiumView(1)
        hideFreeView(vedioDetail.isPremium)
        handleFavourite(videoFavourite: vedioDetail.isFavourite)
        self.parmeter = [
            "videoSlug": vedioDetail.slug,
            "videoId": String(vedioDetail.movieId),
            "videoImage": vedioDetail.posterImage,
            "videoTitle": vedioDetail.title,
            "videoDescription": vedioDetail.description]
    }
    // Home Page Data Bind
    func homePageVideoDataBind(_ vedioDetail: CSMovieData) {
        videoDetailImage.image = nil
        videoDetailImage.setImageWithUrl(vedioDetail.thumbNailImage)
        videoTitle.text = vedioDetail.title
        videoID = vedioDetail.movieId
        hidePremiumView(1)
        hideFreeView(vedioDetail.isPremium)
        handleFavourite(videoFavourite: vedioDetail.isFavourite)
        self.parmeter = [
            "videoSlug": vedioDetail.slug,
            "videoId": String(vedioDetail.movieId),
            "videoImage": vedioDetail.posterImage,
            "videoTitle": vedioDetail.title,
            "videoDescription": vedioDetail.description]
    }
    // Is Video is Favourite
    func handleFavourite(videoFavourite status: Int, animate: Bool = false) {
        favouriteButton.tag = status
        let select = (status == 0) ? false : true
        favouriteButton.setSelected(selected: select, animated: animate)
    }
    /// Hide Premium View
    func hidePremiumView(_ isShow: Int) {
        if isShow == 0 {
            premiumView.isHidden = false
        } else {
            premiumView.isHidden = true
        }
    }
    /// Free view
    func hideFreeView(_ isShow: Int) {
        if isShow == 0 {
            if LibraryAPI.sharedInstance.isUserSubscibed() {
                freeView.isHidden = true
            } else {
                freeView.isHidden = false
            }
        } else {
            freeView.isHidden = true
        }
    }
    // Handle Tap gesture action
    func addTapGesture() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addFavouriteVideo(_:)))
        self.favouriteButton.superview?.addGestureRecognizer(self.tapGesture)
        self.tapGesture.delegate = self
    }
}
// MARK: Favourite Functionality added
extension CSHomeCollectionCell: UIGestureRecognizerDelegate {
    @IBAction func addFavouriteVideo(_ sender: UITapGestureRecognizer) {
        if !UIApplication.isUserLoginInApplication() {
            LibraryAPI.sharedInstance.currentController.addLoginCloseIfUserNotLogin(
                LibraryAPI.sharedInstance.currentController)
            return
        }
        tapGesture.isEnabled = false
        if favouriteButton.tag == 1 {
            removeFromFavouriteVideo()
        } else {
            addToFavouriteVideo()
        }
    }
    /// Add Video to Favourite
    func addToFavouriteVideo() {
        let paramet: [String: String] = ["video_slug": String(videoID)]
        CSHomeApiModel.addFavouriteRequest(
            parentView: LibraryAPI.sharedInstance.currentController,
            parameters: paramet, buttonObject: favouriteButton,
            completionHandler: { _ in
                self.tapGesture.isEnabled = true
                self.favouriteButton.isUserInteractionEnabled = false
                self.handleFavourite(videoFavourite: 1, animate: true)
        })
    }
    /// Remove Video from Favourite
    func removeFromFavouriteVideo() {
        let paramet: [String: String] = ["video_slug": String(videoID)]
        CSHomeApiModel.removeFavouriteRequest(
            parentView: LibraryAPI.sharedInstance.currentController,
            parameters: paramet, buttonObject: favouriteButton,
            completionHandler: { _ in
                self.tapGesture.isEnabled = true
                self.favouriteButton.isUserInteractionEnabled = false
                self.handleFavourite(videoFavourite: 0, animate: true)
        })
    }
}
// MARK: Option Button Action Functionality added
extension CSHomeCollectionCell {
    /// Open Option Button
    @IBAction func openOptionButton(_ sender: UIButton) {
        CSOptionDropDown.dropDownMenu(popUpButton: openOptionButton,
                                      controller: LibraryAPI.sharedInstance.currentController,
                                      parametr: self.parmeter)
    }
}
