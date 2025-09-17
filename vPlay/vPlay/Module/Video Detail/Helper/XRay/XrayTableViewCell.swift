//
//  XrayTableViewCell.swift
//  vPlay
//
//  Created by user on 25/06/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class XrayTableViewCell: UITableViewCell {

    static var identifier = "XrayTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }
    
    func configiureCell(with data: CastInfo) {
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        profileImageView.setImageWithUrl(data.bannerImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
