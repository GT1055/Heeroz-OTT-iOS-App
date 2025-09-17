/*
 * CSPlaylistsCollectionViewCell
 * This cell is used to display the Playlist TableView Cell design and its outlet
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSPlaylistsCollectionViewCell: CSBaseCollectionViewCell {
    /// An outlet to Display the VideoCount
    @IBOutlet var videoCount: UILabel!
    /// AN outlet to Display the Image
    @IBOutlet var playListDetailImage: UIImageView!
    /// AN outlet to Display the Image
    @IBOutlet var playListCountImage: UIImageView!
    /// play list image
    @IBOutlet var followImage: UIImageView!
    /// An Outlet to display the TitleLabel
    @IBOutlet var titleLabel: UILabel!
    /// An Outlet to perform follow and unfollow action
    @IBOutlet var followButton: UIButton!
    // Title View
    @IBOutlet var titleView: UIView!
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
//        playListDetailImage.showSkeletionView()
//        videoCount.showSkeletionView()
//        titleLabel.showSkeletionView()
//        playListCountImage.showSkeletionView()
//        if let follow = followImage { follow.showSkeletionView() }
    }
    /// Hides Skeleton Animation
    func hideSkeletonAnimation() {
        self.contentView.hideSkeleton()
//        playListDetailImage.hideSkeleton()
//        videoCount.hideSkeleton()
//        titleLabel.hideSkeleton()
//        playListCountImage.hideSkeleton()
       changeTheme()
//        if let follow = followImage { follow.hideSkeleton() }
    }
    func changeTheme() {
        self.titleLabel.textColor = .labelTextColor
        self.titleView.backgroundColor = .homeCollectionBackground
        followImage.tintColor = .navigationIconColor
    }
    // Bind Data
    func bindData(_ data: CSPlayList) {
        playListDetailImage.setImageWithUrl(data.playlistImage)
        titleLabel.text = data.playListName
        videoCount.text = String(data.videoCount)
        if followImage != nil {
            followImage.image = #imageLiteral(resourceName: "dot")
        }
    }
    /// Follow And UnFollow
    func checkFollowing(_ status: Int) {
        if status == 1 {
            followImage.image = #imageLiteral(resourceName: "playlist-save")
        } else {
            followImage.image = #imageLiteral(resourceName: "playlist-add")
        }
    }
}
