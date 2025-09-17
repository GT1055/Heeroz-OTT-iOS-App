/*
 * CSLiveTableViewCell
 * This cell is used to display the Live videos
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSLiveTableViewCell: UITableViewCell {
    /// Collection view inside a table view cell
    @IBOutlet var collectionView: UICollectionView!
    /// header title label for title display
    @IBOutlet var headerTitle: UILabel!
    /// header title label for title display
    @IBOutlet var viewAllButton: UIButton!
    // MARK: - Life Cycle Method
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        headerTitle.showSkeletionView()
    }
    /// To Hide Skeleton Animation
    func hideSkeletonAnimation() {
        headerTitle.hideSkeleton()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    /// Check The Count
    func checkCountAndHideVideo(_ count: Int) {
        if count < 3 {
            viewAllButton.isHidden = true
        } else {
            viewAllButton.isHidden = false
        }
        if count == 0 {
            viewAllButton.isHidden = true
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
    /// To set dark mode needs
    func setDarkModeNeeds() {
        headerTitle.textColor = UIColor.invertColor(true)
    }
}
// MARK: - Extension Class For Table Cell to Declare collection view Data sources
extension CSLiveTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>
        (_ dataSourceDelegate: D, forRow row: Int) {
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
