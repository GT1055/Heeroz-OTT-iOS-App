/*
 * HomeCollectionViewCell
 * A collection view to Display images in the HomePage
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import FaveButton
class HomeCollectionViewCell: CSBaseCollectionViewCell {
    /// Premium
    @IBOutlet var premiumView: UIView!
    /// Video Detail View
    @IBOutlet var videoDetailView: UIView!
    /// Favourite Background View
    @IBOutlet weak var favouriteBackgroundView: UIView!
    /// video image
    @IBOutlet var videoDetailImage: UIImageView!
    /// video Label
    @IBOutlet var videoTitle: UILabel!
    /// Favourite Button
    @IBOutlet var videoFavourite: UIButton!
    /// Favourite Image
    @IBOutlet var videoFavouriteImage: UIImageView!
    /// Option Button
    @IBOutlet var openOptionButton: UIButton!
    /// Option Button
    @IBOutlet var openOptionWidth: NSLayoutConstraint!
    /// Option Button
    @IBOutlet var openOptionImage: UIImageView!
    /// Favourite Button
    @IBOutlet var favouriteButton: FaveButton!
    /// Live View
    @IBOutlet var liveView: UIView!
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showSkelectionView()
    }
    /// Show Skelection View
    func showSkelectionView() {
        DispatchQueue.main.async {
            self.contentView.showSkeletionView()
        }
    }
    func changeTheme() {
        videoDetailImage.backgroundColor = UIColor.thumbnailDefaultColor
        self.videoTitle.textColor = .labelTextColor
        self.videoTitle.superview?.backgroundColor = .homeCollectionBackground
        if openOptionImage != nil {
           openOptionImage.tintColor = .navigationIconColor
        }
    }
    /// Hides Skeleton Animation
    func hideSkeletonAnimation() {
        DispatchQueue.main.async {
            self.contentView.hideSkeleton()
            self.changeTheme()
        }
    }
    /// Video Data Bind
    func videoDataBind(_ vedioDetail: CSMovieData) {
        videoDetailImage.setImageWithUrl(vedioDetail.thumbNailImage)
        videoTitle.text = vedioDetail.title
        hidePremiumView(vedioDetail.isPremium)
    }
    /// Video Data Bind
    func webseriesVideoData(_ vedioDetail: CSMovieData) {
        videoDetailImage.setImageWithUrl(vedioDetail.thumbNailImage)
        videoTitle.text = vedioDetail.categoryName
        hidePremiumView(vedioDetail.isPremium)
    }
    func hidePremiumView(_ isShow: Int) {
        if isShow == 0 {
            if LibraryAPI.sharedInstance.isUserSubscibed() {
                premiumView.isHidden = true
            } else {
                premiumView.isHidden = false
            }
        } else {
            premiumView.isHidden = true
        }
    }
    /// Video Data Bind
    func videoDataBind(_ vedioDetail: CommenResponceData) {
        videoDetailImage.setImageWithUrl(vedioDetail.responceFavouriteThumbnailImage)
        videoTitle.text = vedioDetail.responseTitle
        checkVideoFavourite(vedioDetail.responceIsFavourite)
    }
    /// Video Data For Movie
    func videoDataForMovie(_ vedioDetail: CSMovieData) {
        videoDetailImage.setImageWithUrl(vedioDetail.thumbNailImage)
        videoTitle.text = vedioDetail.title
        checkVideoFavourite(vedioDetail.isFavourite)
        hidePremiumView(vedioDetail.isPremium)
    }
    /// Check Favourite Status Video Detail
    func checkVideoFavourite(_ favouriteStatus: Int) {
        if favouriteStatus == 0 {
            videoFavouriteImage.image = #imageLiteral(resourceName: "Whiteheart")
        } else {
            videoFavouriteImage.image = #imageLiteral(resourceName: "favourite")
        }
    }
    // Bind Video Data
    func bindVideoData(_ videoDetail: VedioDetail) {
        videoDetailImage.setImageWithUrl(videoDetail.responceThumbnailImage)
        videoTitle.text = videoDetail.responseTitle
        checkVideoFavourite(videoDetail.responceIsFavorite)
        hidePremiumView(videoDetail.isPremium)
    }
    /// Search Data
    func bindSearchData(_ videoData: CSMovieData) {
        videoDetailImage.setImageWithUrl(videoData.thumbNailImage)
        videoTitle.text = videoData.title
        hidePremiumView(1) // videoData.isPremium
        hideLiveTag(videoData.isLive)
    }
    func hideLiveTag(_ isLiveFlage: Int) {
        if isLiveFlage == 1 {
            liveView.isHidden = false
        } else {
            liveView.isHidden = true
        }
    }
    /// bind Data To Offline Video
    func bindDataToAssert(_ assertInfo: AssertDetails) {
        videoTitle.text = assertInfo.title
        DispatchQueue.main.async(execute: { [unowned self] in
            let dataDecoded: Data = Data(base64Encoded: assertInfo.thumbnail ?? "",
                                         options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            self.videoDetailImage.image = decodedimage
        })
    }
    // Home Page Data Bind
    func homePageVideoDataBind(_ vedioDetail: CSMovieData) {
        videoDetailImage.setImageWithUrl(vedioDetail.thumbNailImage)
        videoTitle.text = vedioDetail.title
        hidePremiumView(vedioDetail.isPremium)
        handleFavourite(videoFavourite: vedioDetail.isFavourite)
    }
    // Is Video is Favourite
    func handleFavourite(videoFavourite status: Int) {
        favouriteButton.tag = status
        let select = (status == 0) ? false : true
        favouriteButton.setSelected(selected: select, animated: false)
    }
}
extension HomeCollectionViewCell: UIGestureRecognizerDelegate {
    @IBAction func addFavouriteVideo(_ sender: UITapGestureRecognizer) {
        if favouriteButton.tag == 1 {
            handleFavourite(videoFavourite: 0)
        } else {
            handleFavourite(videoFavourite: 1)
        }
    }
}
import SkeletonView
extension UIView {
    func showSkeletionView() {
        let color: UIColor = LibraryAPI.sharedInstance.isDarkMode() ? UIColor.backgroundColor() : UIColor.silver
        let gradient = SkeletonGradient(baseColor: color)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
        self.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        if self is UILabel {
            let label = self as? UILabel
            label?.lastLineFillPercent = 50
            label?.linesCornerRadius = 5
        }
    }
}
