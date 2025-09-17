//
//  VSOfflienTableViewCell.swift
//  vPlay
//
//  Created by user on 22/01/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
class VSOfflienTableViewCell: UITableViewCell {
    // Download Image
    @IBOutlet var videoDetailImage: UIImageView!
    // title Image
    @IBOutlet var videoTitle: UILabel!
    // title Image
    @IBOutlet var deleteButton: UIButton!
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDarkModeNeeds()
    }
    /// To set default things for the dark mode
    func setDarkModeNeeds() {
        videoDetailImage.superview?.backgroundColor = UIColor.navigationColor()
        videoTitle.textColor = UIColor.invertColor(true)
        deleteButton.tintColor = UIColor.iconColor()
    }
    /// bind Data To Offline Video
    func bindDataToAssert(_ assertInfo: AssertDetails) {
        videoTitle.text = assertInfo.title
        DispatchQueue.main.async(execute: { [unowned self] in
            let dataDecoded: Data = Data(base64Encoded: assertInfo.thumbnail ?? "",
                                         options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            self.videoDetailImage.image = decodedimage
        })
    }
}
