//
//  CSCategoriesCollectionCell.swift
//  vPlay
//
//  Created by user on 30/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CSCategoriesCollectionCell: CSBaseCollectionViewCell {
    /// Category Image
    @IBOutlet var categoryImage: UIImageView!
    /// Category Title
    @IBOutlet var categoryTitle: UILabel!
    /// Category Title View
    @IBOutlet weak var categoryTitleView: UIView!
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.categoryTitle.isHidden = true
            self.contentView.showSkeletionView()
        }
    }
    /// Bind Data
    func bindData(_ data: CSCategoryList) {
        categoryImage.setImageWithUrl(data.categoryImage)
        categoryTitle.text = data.categoryTitle.uppercased()
    }
    /// Hide Skeleton Animation
    func hideSkeletonAnimation() {
        categoryTitleView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.categoryTitle.isHidden = false
        self.contentView.hideSkeleton()
    }
}
