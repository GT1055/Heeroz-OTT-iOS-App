/*
 * CSBaseCollectionViewCell
 * This class  is used as a base collectionView cell for all collectionviewcell class
 * @category   Vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */

import UIKit

class CSBaseCollectionViewCell: UICollectionViewCell {
    /// Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /// Animation to display the content in collection view
    func collectionViewDisplayAnimation() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        self.layer.transform = CATransform3DMakeScale(0.85, 0.85, 0.85)
        UIView.beginAnimations("scaleTableViewCellAnimationID", context: nil)
        UIView.setAnimationDuration(0.5)
        self.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        self.alpha = 1
        self.layer.transform = CATransform3DIdentity
        UIView.commitAnimations()
    }
    /// Add Shadown and Animation
    func addShadownAndAnimation() {
        self.layer.transform = CATransform3DMakeScale(0.85, 0.85, 0.85)
        UIView.beginAnimations("scaleTableViewCellAnimationID", context: nil)
        UIView.setAnimationDuration(0.5)
        self.alpha = 1
        self.layer.transform = CATransform3DIdentity
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.20
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.cornerRadius).cgPath
        UIView.commitAnimations()
    }
}
