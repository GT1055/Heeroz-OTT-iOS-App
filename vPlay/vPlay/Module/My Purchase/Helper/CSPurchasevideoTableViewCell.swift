//
//  CSPurchasevideoTableViewCell.swift
//  vPlay
//
//  Created by user on 10/07/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class CSPurchasevideoTableViewCell: UITableViewCell {
    // Back View
    @IBOutlet weak var backView: CSCustomView!
    // Separator View
    @IBOutlet weak var separatorView: UIView!
    // Thumbnail View
    @IBOutlet weak var thumbnailImageView: UIImageView!
    // title label
    @IBOutlet weak var titleLabel: UILabel!
    // Time and date label
    @IBOutlet weak var timeLabel: UILabel!
    // status label
    @IBOutlet weak var statusLabel: UILabel!
    // Maximun video count label
    @IBOutlet weak var maximunCountLabel: UILabel!
    // currentCountLabel
    @IBOutlet weak var currentCountLabel: UILabel!
    // currentCountLabel
    @IBOutlet weak var slashLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setDarkModeNeeds()
        // Initialization code
    }
    func configureCell(with data: PurchaseDetail) {
        let video = data.video
        thumbnailImageView.setImageWithUrl(video?.thumbnailImage)
        if thumbnailImageView.image == nil {
            thumbnailImageView.backgroundColor = UIColor.thumbnailDefaultColor
        }
        titleLabel.text = video?.title
        statusLabel.text = data.status
        statusLabel.textColor = UIColor.green
        timeLabel.text = CSTimeAgoSinceDate.setDateAsMMMDDYYYY(data.createdAt)
        maximunCountLabel.text = "\(data.globalVideoViewCount)"
        currentCountLabel.text = "\(data.customerVideoViewCount)"
        if maximunCountLabel.text == currentCountLabel.text {
            statusLabel.text = "Expired"
            statusLabel.textColor = UIColor.red
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setDarkModeNeeds() {
        backView.backgroundColor = .transcationCellBackground
        separatorView.backgroundColor = .separatorColor
        timeLabel.textColor = UIColor.invertColor(true)
        titleLabel.textColor = UIColor.invertColor(true)
        statusLabel.textColor = UIColor.invertColor(true)
        maximunCountLabel.textColor = UIColor.invertColor(true)
        currentCountLabel.textColor = UIColor.invertColor(true)
        slashLabel.textColor = UIColor.invertColor(true)
    }
}
