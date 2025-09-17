/*
 * CSFavouritesTableViewCell
 * This cell is used to display the settings outlets
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSFavouritesTableViewCell: UITableViewCell {
    /// Fav options
    @IBOutlet weak var favOption: UIButton!
    /// Fav ThumbNail Image
    @IBOutlet weak var favThumbNailImge: UIImageView!
    /// Fav Created Date
    @IBOutlet weak var favCreatedDate: UILabel!
    /// Outlets fav Video Detail Title
    @IBOutlet weak var favVideoTitle: UILabel!
    /// Parent view contant all view
    @IBOutlet var parentView: UIView!
    /// Parent content view contain only text field
    @IBOutlet var parentContentview: UIView!
    /// Imageview contian only image and duration view
    @IBOutlet var imageParentView: UIView!
    /// play button as image view
    @IBOutlet var cellVideoImage: UIImageView!
    /// share url
    var shareVideoURL: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Initialization code and Corner Radius setting
        self.parentView.layer.cornerRadius = 3
        self.parentView.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    /// Bind Data At Sources
    func bindDataSources(_ data: CommenResponceData) {
        favVideoTitle.text = data.responseTitle
        shareVideoURL = data.responseSlug
        favCreatedDate.text = CSTimeAgoSinceDate.convertDateFormatter(date: data.responceCreatedAt)
        favThumbNailImge.setImageWithUrl(data.responceThumbnailImage)
    }
}
