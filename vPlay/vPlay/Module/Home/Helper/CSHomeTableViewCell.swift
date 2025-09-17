/*
 * CSHomeTableViewCell.swift
 * A Table Cell user to bind Data to each category And section
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ImageSlideshow

class CSHomeTableViewCell: UITableViewCell {
    /// Collection view inside a table view cell
    @IBOutlet var collectionView: UICollectionView!
    /// header detail lable for description
    @IBOutlet var headerDetail: UILabel!
    /// No Data View
    @IBOutlet var noDataLabel: UILabel!
    /// header title label for title display
    @IBOutlet var headerTitle: UILabel!
    /// header title label for title display
    @IBOutlet var viewAllButton: UIButton!
    
    @IBOutlet weak var BannerView: UIView!
    
    @IBOutlet weak var miniBanner: UIView!
    
    @IBOutlet weak var miniPagination: UIView!
    
    /// Layout Constant
    @IBOutlet var bannarHeight: NSLayoutConstraint!
    /// Banner Slider
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet var bannarTitle: UILabel!
    /// Bannar Description
    @IBOutlet var bannarDescrption: UILabel!
    /// Bannar Premium Video
    @IBOutlet var premiumViewWidthConstant: NSLayoutConstraint!
    /// Bannar Premium Video View
    @IBOutlet var premiumView: UIView!
    /// Bannar Live Video
    @IBOutlet var liveViewWidthConstant: NSLayoutConstraint!
    /// Bannar Live Video View
    @IBOutlet var liveView: UIView!
    // Pagecontrol
    @IBOutlet weak var pageControl: UIPageControl!
    /// A variable to set the Number of sections
    @IBOutlet weak var headerViewHieghtConstant: NSLayoutConstraint!
    @IBOutlet var didBannerClicked: UIButton!
    
    @IBOutlet weak var playButtonIcon: UIButton!
    
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        headerTitle.showSkeletionView()
    }
    /// Hides Skeleton Animation
    func hideSkeletonAnimation() {
        headerTitle.hideSkeleton()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    /// To set color based on dark mode
    func setModeBasedColor() {
        headerTitle.textColor = UIColor.invertColor(true)
    }
    func checkCountAndHideVideo(_ count: Int) {
        if count < 3 {
            viewAllButton.isHidden = true
        } else {
            viewAllButton.isHidden = false
        }
        if count == 0 {
            viewAllButton.isHidden = true
            noDataLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            noDataLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
}
// MARK: - Extension Class For Table Cell to Declare collection view Data sources
extension CSHomeTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>
        (_ dataSourceDelegate: D, forRow row: Int) {
        let nib = UINib(nibName: "CSHomeCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        //Stops collection view if it was scrolling.
        collectionView.setContentOffset(collectionView.contentOffset, animated: false)
        collectionView.reloadData()
    }
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
