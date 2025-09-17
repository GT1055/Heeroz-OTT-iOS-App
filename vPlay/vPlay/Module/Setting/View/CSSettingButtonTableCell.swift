//
//  CSSettingButtonTableCell.swift
//  vPlay
//
//  Created by user on 30/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
/// Setting Table Button Cell With Button
class CSSettingButtonTableCell: UITableViewCell {
    /// Name Text Label
    @IBOutlet var name: UILabel!
    /// Detail Text Label
    @IBOutlet var detail: UILabel!
    /// On And Off Switch
    @IBOutlet var settingButton: UIButton!
    // Change Theme
    func changeTheme() {
        self.name.textColor = .settingCellTitle
        self.detail.textColor = .settingCellDescription
    }
    /// Bind Data
    func setBindData(_ data: [String: Any]) {
        self.name.text = NSLocalizedString((data["title"] as? String)!, comment: "Menu")
        self.detail.text = NSLocalizedString((data["detail"]as? String)!, comment: "Menu")
        changeTheme()
        if (data["title"] as? String)!.uppercased() == "Subscription".uppercased() {
           self.settingButton.setTitle(NSLocalizedString("Cancel", comment: "Language"), for: .normal)
          return
        }
        if CSLanguage.currentAppleLanguage() == "pa-IN" {
            self.settingButton.setTitle(NSLocalizedString("Punjabi", comment: "Language"), for: .normal)
        } else if CSLanguage.currentAppleLanguage() == "hi" {
            self.settingButton.setTitle(NSLocalizedString("Hindi", comment: "Language"), for: .normal)
        } else {
            self.settingButton.setTitle(NSLocalizedString("English", comment: "Language"), for: .normal)
        }
    }
}
