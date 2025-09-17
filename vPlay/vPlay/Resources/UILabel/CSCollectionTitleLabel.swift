/*
 * CSCollectionTitleLabel.swift
 * This class  is used as a base collectionView view Title Label
 * @category   Vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */

import UIKit

class CSCollectionTitleLabel: UILabel {
    // MARK: - UILife Cycle of a Button
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customLabelConfiguration()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        customLabelConfiguration()
    }
    // MARK: - Private Method
    /// Customize the button
    func customLabelConfiguration() {
        self.font = .cscollectionLableTitleFont()
        self.textColor = .black
        self.numberOfLines = 2
        self.backgroundColor = UIColor.clear
    }
}
