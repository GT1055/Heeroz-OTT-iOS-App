//
//  LIveChatTableViewCell.swift
//  vPlay
//
//  Created by user on 23/08/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class LIveChatTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backgroundcellView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUIComponents()
    }
    func configureCell(with messageSnapshot: DataSnapshot ) {
        guard let message = messageSnapshot.value as? [String:String] else { print("nomessage"); return }
        setUIComponents()
        nameLabel.text = message["name"] ?? ""
        descriptionLabel.text = message["text"] ?? ""
        timeLabel.text = message["time"] ?? ""
        if message["photoUrl"]!.isEmpty {
            profileImageView.image = UIImage.init(named: "placeholder")
        } else {
            profileImageView.setImageWithUrl(message["photoUrl"])
        }
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
    }
    func setUIComponents() {
        nameLabel.textColor = .namelabelColor
        descriptionLabel.textColor = .descriptionColor
        timeLabel.textColor = .timeLabelColor
        backgroundcellView.backgroundColor = .backgroundCellColor
    }
    
}
