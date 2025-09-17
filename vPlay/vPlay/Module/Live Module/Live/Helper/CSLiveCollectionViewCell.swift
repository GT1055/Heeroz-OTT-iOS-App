/*
 * CSLiveCollectionViewCell.swift
 * This Controller is used to bind Data in a cell
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSLiveCollectionViewCell: CSBaseCollectionViewCell, UIGestureRecognizerDelegate {
    /// Live image
    @IBOutlet var liveImage: UIImageView!
    /// Live Title
    @IBOutlet var liveTitle: UILabel!
    /// Live Time
    @IBOutlet var liveTime: UILabel!
    /// Premium
    @IBOutlet var premiumView: UIView!
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
//        liveImage.showSkeletionView()
//        liveTitle.showSkeletionView()
//        liveTime.showSkeletionView()
        DispatchQueue.main.async {
            self.contentView.showSkeletionView()
        }
    }
    /// To Hide Skeleton Animation
    func hideSkeletonAnimation() {
//        liveImage.hideSkeleton()
//        liveTitle.hideSkeleton()
//        liveTime.hideSkeleton()
        DispatchQueue.main.async {
         self.contentView.hideSkeleton()
         self.changeTheme()
        }
    }
    func changeTheme() {
        self.liveImage.backgroundColor = UIColor.thumbnailDefaultColor
        self.liveTime.textColor = .dateAndTimeColor
        self.liveTitle.textColor = .labelTextColor
        self.liveTitle.superview?.backgroundColor = .homeCollectionBackground
    }
    /// Bind Data To Live Next video And Todays live
    func bindDataToLiveVideos(_ liveData: UpcomingliveVideosList, index: Int) {
        liveTime.text = CSTimeAgoSinceDate.convertMonthDateYearFormate(date: liveData.starttime)
        liveTitle.text = liveData.title
        liveImage.setImageWithUrl(liveData.imageurl)
        hidePremiumView(liveData.isPremium)
    }
    /// Add Current Live data
    func addLiveData(_ liveData: UpcomingliveVideosList) {
        liveTitle.text = liveData.title
        liveImage.setImageWithUrl(liveData.imageurl)
        hidePremiumView(liveData.isPremium)
    }
    /// Bind Data To Up coming live
    func bindDataToMoreLiveVideos(_ liveData: UpcomingliveVideosList) {
        liveTime.text = CSTimeAgoSinceDate.convertMonthDateYearFormate(date: liveData.starttime)
        liveTitle.text = liveData.title
        liveImage.setImageWithUrl(liveData.imageurl)
        hidePremiumView(liveData.isPremium)
    }
    func hidePremiumView(_ isShow: Int) {
        if isShow == 0 {
            premiumView.isHidden = false
        } else {
            premiumView.isHidden = true
        }
    }
    func addedTapGesture(_ index: Int) {
        self.liveImage.tag = index
        self.liveTitle.tag = index
        ///  Add a gesture recognizer to the slider
        let thumbnailTapGesture =
            UITapGestureRecognizer(target: self, action: #selector(thumbnailTap(_:)))
        thumbnailTapGesture.delegate = self
        liveImage.superview?.addGestureRecognizer(thumbnailTapGesture)
        ///  Live Title super view
        let liveTitleTapGesture =
            UITapGestureRecognizer(target: self, action: #selector(liveTitleTap(_:)))
        liveTitleTapGesture.delegate = self
        liveTitle.superview?.addGestureRecognizer(liveTitleTapGesture)
    }
    @objc func thumbnailTap(_ sender: UIGestureRecognizer) {
        if LibraryAPI.sharedInstance.currentController is CSLiveViewController,
            let controller = LibraryAPI.sharedInstance.currentController as? CSLiveViewController {
            controller.moveToLiveDetail(self.liveTitle.tag)
        }
    }
    @objc func liveTitleTap(_ sender: UIGestureRecognizer) {
        if LibraryAPI.sharedInstance.currentController is CSLiveViewController,
            let controller = LibraryAPI.sharedInstance.currentController as? CSLiveViewController {
            controller.moveToLiveDetail(self.liveTitle.tag)
        }
    }
}
