//
//  CSNotificationSettingTableCell.swift
//  vPlay
//
//  Created by user on 30/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
/// Notification Setting Table Cell
class CSNotificationSettingTableCell: UITableViewCell {
    /// Name Text Label
    @IBOutlet var name: UILabel!
    /// Detail Text Label
    @IBOutlet var detail: UILabel!
    /// On And Off Switch
    @IBOutlet var onAndOffSwitch: UIButton!
    /// Detail View
    @IBOutlet var detailView: UIView!
    /// New Video Button
    @IBOutlet var newVideoSwifch: UISwitch!
    /// Reply Button
    @IBOutlet var replyButtonSwitch: UISwitch!
    /// New Videos
    @IBOutlet var newVideosName: UILabel!
    /// New Videos Details
    @IBOutlet var newVideosDetail: UILabel!
    /// Reply name
    @IBOutlet var replyName: UILabel!
    /// Reply Detail
    @IBOutlet var replyDetail: UILabel!
    /// Separator View
    @IBOutlet var separatorViews: [UIView]!
    /// Override Method
    override func awakeFromNib() {
        replyButtonSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        newVideoSwifch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        rotateAnimation(CGFloat(Double.pi), button: onAndOffSwitch)
    }
    // New Video Notification On Off Button
    @IBAction func addVideoNotifyOnOffAction(_ sender: UISwitch) {
        if sender.isOn {
            updateVideoStatus(1)
        } else {
            updateVideoStatus(0)
        }
    }
    /// Rotate View animator
    func rotateAnimation(_ rotation: CGFloat, button: UIButton) {
        UIView.transition(with: self, duration: 0.5,
                          options: .transitionCrossDissolve, animations: {() -> Void in
                            button.transform = CGAffineTransform(rotationAngle: rotation)
        }, completion: nil)
    }
    // New Video Notification On Off Button
    @IBAction func replyCommentsNotifyOnOffAction(_ sender: UISwitch) {
        if sender.isOn {
            updateReplyComment(1)
        } else {
            updateReplyComment(0)
        }
    }
    /// Notification Status Api
    func updateVideoStatus(_ status: Int) {
        /// Add parmaters
        let paramet: [String: String] = ["new_video": String(status)]
        CSSettingModelApi.notificationStatusUpdate(
            parentView: LibraryAPI.sharedInstance.currentController,
            parameters: paramet,
            completionHandler: { [unowned self] _ in
                self.videoComment(status)
                if LibraryAPI.sharedInstance.currentController is SettingsViewcontroller {
                    let controller = LibraryAPI.sharedInstance.currentController as? SettingsViewcontroller
                    controller?.changeValueVideoComment(status)
                }
        })
    }
    /// Notification Status Api
    func updateReplyComment(_ status: Int) {
        /// Add parmaters
        let paramet: [String: String] = ["reply_comment": String(status)]
        CSSettingModelApi.notificationStatusUpdate(
            parentView: LibraryAPI.sharedInstance.currentController,
            parameters: paramet,
            completionHandler: { [unowned self] _ in
                self.replyComment(status)
                if LibraryAPI.sharedInstance.currentController is SettingsViewcontroller {
                    let controller = LibraryAPI.sharedInstance.currentController as? SettingsViewcontroller
                    controller?.changeValueOfReply(status)
                }
        })
    }
    /// Video Comment
    func videoComment(_ status: Int) {
        if status == 1 {
            self.newVideoSwifch.setOn(true, animated: true)
        } else {
            self.newVideoSwifch.setOn(false, animated: true)
        }
    }
    /// Comment
    func replyComment(_ status: Int) {
        if status == 1 {
            self.replyButtonSwitch.setOn(true, animated: true)
        } else {
            self.replyButtonSwitch.setOn(false, animated: true)
        }
    }
    // Change Theme
    func changeTheme() {
        self.name.textColor = .settingCellTitle
        newVideosName.textColor = .settingCellTitle
        replyName.textColor = .settingCellTitle
        self.detail.textColor = .settingCellDescription
        newVideosDetail.textColor = .settingCellDescription
        replyDetail.textColor = .settingCellDescription
        onAndOffSwitch.tintColor = .settingCellIcon
        detailView.backgroundColor = .navigationBarColor
        separatorViews.forEach({$0.backgroundColor = .separatorColor})
    }
    /// Bind Data
    func setBindData(_ data: [String: Any]) {
        self.name.text = NSLocalizedString((data["title"] as? String)!, comment: "Menu")
        self.detail.text = NSLocalizedString((data["detail"]as? String)!, comment: "Menu")
        replyComment((data["replyStatus"] as? Int) ?? 0)
        videoComment((data["videoStatus"] as? Int) ?? 0)
        changeTheme()
        newVideosName.text = NSLocalizedString("New Videos", comment: "Notification")
        replyName.text = NSLocalizedString("Reply Comments", comment: "Notification")
        newVideosDetail.text = NSLocalizedString("Get notified when new videos added",
                                                 comment: "Notification")
        replyDetail.text = NSLocalizedString("Get notified when someone replied to your comment",
                                             comment: "Notification")
    }
}
