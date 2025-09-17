//
//  CSSettingButtonCell.swift
//  vPlay
//
//  Created by user on 29/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
/// Setting Table Cell With Switch
class CSSettingTableCell: UITableViewCell {
    /// Name Text Label
    @IBOutlet var name: UILabel!
    /// Detail Text Label
    @IBOutlet var detail: UILabel!
    /// On And Off Switch
    @IBOutlet var onAndOffSwitch: UISwitch!
    override func awakeFromNib() {
        onAndOffSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    /// AutoPlay Status Api
    func updateAutoPlay(_ status: Int) {
        /// Add parmaters
        let paramet: [String: String] = ["auto_play": String(status)]
        CSSettingModelApi.notificationStatusUpdate(
            parentView: LibraryAPI.sharedInstance.currentController,
            parameters: paramet,
            completionHandler: { [unowned self] _ in
                self.autoPlay(status)
                if LibraryAPI.sharedInstance.currentController is SettingsViewcontroller {
                    let controller = LibraryAPI.sharedInstance.currentController as? SettingsViewcontroller
                    controller?.changeValueOfAutoPlayVideos(status)
                }
        })
    }
    /// Auto Play
    func autoPlay(_ status: Int) {
        if status == 1 {
            self.onAndOffSwitch.setOn(true, animated: true)
        } else {
            self.onAndOffSwitch.setOn(false, animated: true)
        }
    }
    /// Auto Play
    func autoEnableAndDisable() {
        if onAndOffSwitch.isOn {
            updateAutoPlay(0)
        } else {
            updateAutoPlay(1)
        }
    }
    /// Bind Data
    func setBindData(_ data: [String: Any]) {
        self.name.text = NSLocalizedString((data["title"] as? String)!, comment: "Menu")
        self.detail.text = NSLocalizedString((data["detail"]as? String)!, comment: "Menu")
        autoPlay((data["status"] as? Int)!)
        changeTheme()
    }
    /// Dark Theme
    func darkTheme() {
        self.onAndOffSwitch.setOn(LibraryAPI.sharedInstance.isDarkMode(), animated: true)
        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "DarkMode", value: onAndOffSwitch.isOn)
        if LibraryAPI.sharedInstance.currentController is SettingsViewcontroller {
            let controller = LibraryAPI.sharedInstance.currentController as? SettingsViewcontroller
            controller?.refreshNavigation()
        }
    }
    // Change Theme
    func changeTheme() {
        self.name.textColor = .settingCellTitle
        self.detail.textColor = .settingCellDescription
    }
}
