//
//  CSSettingTableDataSource.swift
//  vPlay
//
//  Created by user on 29/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CSSettingTableDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    /// Delegate
    weak var delegate: CSTableViewDelegate!
    /// Setting Data Source
    var settingDataSource = [[String: Any]]()
    /// MARK:- Table view Delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDataSource.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    /// table height set
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (settingDataSource[indexPath.row]["title"] as? String)! == "All Notification" {
            return CGFloat((settingDataSource[indexPath.row]["normalHeight"] as? Int)!)
        } else if (settingDataSource[indexPath.row]["title"] as? String)! == "Change Password" {
            return CGFloat((settingDataSource[indexPath.row]["normalHeight"] as? Int)!)
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (settingDataSource[indexPath.row]["type"] as? String)! == "switch" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                CSSettingTableCell else { return UITableViewCell() }
            cell.setBindData(settingDataSource[indexPath.row])
            cell.onAndOffSwitch.tag = indexPath.row
            return cell
        } else if (settingDataSource[indexPath.row]["type"] as? String)! == "Button" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Button", for: indexPath) as?
                CSSettingButtonTableCell else { return UITableViewCell() }
            cell.setBindData(settingDataSource[indexPath.row])
            cell.settingButton.tag = indexPath.row
            return cell
        } else if (settingDataSource[indexPath.row]["type"] as? String)! == "Password" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Password", for: indexPath) as?
                CSSettingChangePasswordTableCell else { return UITableViewCell() }
            cell.setBindData(settingDataSource[indexPath.row])
            cell.settingButton.tag = indexPath.row
            cell.updatePassword.tag = indexPath.row
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Notification", for: indexPath) as?
                CSNotificationSettingTableCell else { return UITableViewCell() }
            cell.setBindData(settingDataSource[indexPath.row])
            cell.onAndOffSwitch.tag = indexPath.row
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if LibraryAPI.sharedInstance.currentController is SettingsViewcontroller {
            let controller = LibraryAPI.sharedInstance.currentController as? SettingsViewcontroller
            controller?.view.endEditing(true)
        }
        if (settingDataSource[indexPath.row]["title"] as? String)! == "All Notification" {
            return
        } else if (settingDataSource[indexPath.row]["title"] as? String)! == "Change Password" {
            return
        } else if (settingDataSource[indexPath.row]["title"] as? String)! == "Dark Theme" {
            let cell = tableView.cellForRow(at: indexPath) as? CSSettingTableCell
            cell?.darkTheme()
        } else if (settingDataSource[indexPath.row]["title"] as? String)! == "Autoplay Videos" {
            let cell = tableView.cellForRow(at: indexPath) as? CSSettingTableCell
            cell?.autoEnableAndDisable()
        }
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
