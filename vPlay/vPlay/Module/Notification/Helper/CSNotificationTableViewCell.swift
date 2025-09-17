/*
 * NotificationTableViewCell
 * This cell is used to display the Notifications
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class NotificationTableViewCell: UITableViewCell {
    // Content title is show in notification
    @IBOutlet weak var content: UILabel!
    // Content of notification date
    @IBOutlet weak var date: UILabel!
    // Profile image
    @IBOutlet weak var notificationProfileImage: UIImageView!
    // thumb nail image
    @IBOutlet weak var imageNotification: UIImageView!
    // Read Notification View
    @IBOutlet weak var option: UIView!
    // More option
    @IBOutlet var openOptionButton: UIButton!
    /// Type of Data
    var type: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setDarkModeNeeds() {
        content.textColor = UIColor.invertColor(true)
        date.textColor = (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.white : UIColor.convertHexStringToColor("686868")
    }
    /// Bind Data To Notification
    func bindDataToNotification(_ data: CSNotificationList) {
        date.text = data.datacreated
        content.text = data.content
        if let user = data.customer, data.notificationType == "reply_comment"{
            notificationProfileImage.setProfileImageWithUrl(user.profilePicture)
        } else if  data.notificationType == "subscription" {
            notificationProfileImage.setProfileImageWithUrl(LibraryAPI.sharedInstance.getUserImageUrl())
        } else if  data.notificationType == "new_video" {
            notificationProfileImage.image = UIImage.init(named: "HLogo")
            notificationProfileImage.cornerRadius = 0
        }
        if data.video != nil {
            imageNotification.setImageWithUrl(data.video.thumbNailImage)
        } else {
            if LibraryAPI.sharedInstance.isDarkMode() {
                imageNotification.image = UIImage.init(named: "logo-dark")
            } else {
                imageNotification.image = UIImage.init(named: "logo")
            }
            imageNotification.contentMode = .scaleAspectFit
        }
        checkReadAndUnRead(data.isRead)
    }
    /// Check Read And Un Read
    func checkReadAndUnRead(_ isRead: String) {
        if !isRead.isEmpty {
            option.isHidden = true
            self.backgroundColor =
                (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.black : UIColor.navigationColor()
        } else {
            option.isHidden = false
            self.backgroundColor =
                (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.backgroundColor() : UIColor.white
        }
    }
}
