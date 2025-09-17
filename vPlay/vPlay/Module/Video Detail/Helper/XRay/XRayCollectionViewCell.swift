//
//  XRayCollectionViewCell.swift
//  vPlay
//
//  Created by user on 26/06/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class XRayCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "XRayCollectionViewCell"
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(with xrayData: XrayDetail) {
        profileImage.setImageWithUrl(xrayData.artistImage ?? "")
        nameLabel.text = xrayData.artistName
    }
}
