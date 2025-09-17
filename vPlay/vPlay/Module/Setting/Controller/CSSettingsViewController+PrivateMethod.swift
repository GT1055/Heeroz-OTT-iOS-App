//
//  CSSettingsViewController+PrivateMethod.swift
//  vPlay
//
//  Created by user on 22/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
// MARK: - Private Method
extension SettingsViewcontroller {
    // It adds the notification bar.
    func setupNavigation() {
//        controllerTitle = NSLocalizedString("Settings", comment: "Menu")
        addGradientBackGround()
        addLeftBarButton()
    }
    /// Add Alert With title and Message
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""),
                                      style: .default, handler: { _ in }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""),
                                      style: .destructive, handler: { _ in
                                        self.cancelSubscription() }))
        self.present(alert, animated: true, completion: nil)
    }
    /// Auto Play Video
    func changeValueOfAutoPlayVideos(_ status: Int) {
        if let index = self.settingConstant.firstIndex(
            where: { ($0["title"] as? String)! == "Autoplay Videos" }) {
            self.settingConstant[index]["status"] = status
        }
    }
    /// Remove Unwanted Data
    func removeUnwantedDataIfUserIsNotLogin() {
       let data = ["Subscription", "Change Password", "All Notification", "Autoplay Videos", "Language"]
        for string in data {
            if let index = self.settingConstant.firstIndex(
                where: { ($0["title"] as? String)! == string }) {
                self.settingConstant.remove(at: index)
            }
        }
        if let index = self.settingConstant.firstIndex(
            where: { ($0["title"] as? String)! == "Dark Theme" }) {
            if LibraryAPI.sharedInstance.isDarkMode() {
                self.settingConstant[index]["status"] = 1
            } else {
                self.settingConstant[index]["status"] = 0
            }
        }
        self.settingDataSource.settingDataSource = self.settingConstant
        self.settingTable.reloadData()
    }
    /// Remove Unwanted Data
    func removeUnwantedDataForLanguage() {
       let data = ["Subscription", "Change Password", "All Notification", "Autoplay Videos", "Dark Theme"]
        for string in data {
            if let index = self.settingConstant.firstIndex(
                where: { ($0["title"] as? String)! == string }) {
                self.settingConstant.remove(at: index)
            }
        }
        if let index = self.settingConstant.firstIndex(
            where: { ($0["title"] as? String)! == "Dark Theme" }) {
            if LibraryAPI.sharedInstance.isDarkMode() {
                self.settingConstant[index]["status"] = 1
            } else {
                self.settingConstant[index]["status"] = 0
            }
        }
        self.settingDataSource.settingDataSource = self.settingConstant
        self.settingTable.reloadData()
    }
    /// Reply and Video Comment Status Handler
    func changeValueOfReplyAndVideoComment(_ replyStatus: Int, videoStatus: Int) {
        self.changeValueVideoComment(videoStatus)
        self.changeValueOfReply(replyStatus)
    }
    /// Video  Status Handler
    func changeValueVideoComment(_ videoStatus: Int) {
        if let index = self.settingConstant.firstIndex(
            where: { ($0["title"] as? String)! == "All Notification" }) {
            self.settingConstant[index]["videoStatus"] = videoStatus
        }
    }
    /// Reply Comment
    func changeValueOfReply(_ replyStatus: Int) {
        if let index = self.settingConstant.firstIndex(
            where: { ($0["title"] as? String)! == "All Notification" }) {
            self.settingConstant[index]["replyStatus"] = replyStatus
        }
    }
    /// To refresh navigation fully
    func refreshNavigation() {
        for barButton in self.navigationItem.leftBarButtonItems! {
            if let view = barButton.customView, view is UILabel {
                let titleLabel = view as? UILabel
                if controllerTitle == NSLocalizedString("Language", comment: "Language")
                {
                    titleLabel?.text = NSLocalizedString("Language", comment: "Menu")
                }else{
                    titleLabel?.text = NSLocalizedString("Settings", comment: "Settings")
                }
                
                titleLabel?.textColor = .contentColor()
            }
            if let view = barButton.customView, view is UIButton {
                let button = view as? UIButton
                button?.tintColor = .iconColor()
            }
        }
        if let statusbar = UIApplication.shared.statusBarUIView {
            statusbar.backgroundColor = .navigationBarColor
        }
        setNeedsStatusBarAppearanceUpdate()
        if self.tabBarController is CSParentTabBarViewController {
            let tab = self.tabBarController as? CSParentTabBarViewController
            tab?.setTabBarColor()
        }
        if self.tabBarController is CSParentTabBarViewController {
            let tab = self.tabBarController as? CSParentTabBarViewController
            tab?.setTabBarItemLangauges()
        }
        addGradientBackGround()
        settingTable.separatorColor = .separatorColor
        self.navigationController?.navigationBar.backgroundColor = UIColor.navigationBarColor
        self.setDarkThemeData()
        self.setSelectedHeightOfNotification()
        self.setSelectedHeightOfPassword()
        self.settingDataSource.settingDataSource = self.settingConstant
        self.settingTable.reloadData()
    }
    /// Dark Theme Data
    func setDarkThemeData() {
        if let index = self.settingConstant.firstIndex(
            where: { ($0["title"] as? String)! == "Dark Theme" }) {
            if LibraryAPI.sharedInstance.isDarkMode() {
                self.settingConstant[index]["status"] = 1
            } else {
                self.settingConstant[index]["status"] = 0
            }
        }
    }
    /// Selected Height Of notifiacitpn
    func setSelectedHeightOfNotification() {
        if let indexDataSource = self.settingDataSource.settingDataSource.firstIndex(
            where: {($0["title"] as? String)! == "All Notification"}) {
            if let index = self.settingConstant.firstIndex(where: {($0["title"] as? String)! == "All Notification"}) {
                let height = (self.settingDataSource.settingDataSource[indexDataSource]["normalHeight"] as? Int)!
                self.settingConstant[index]["normalHeight"] = height
            }
        }
    }
    /// Selected Height Of notifiacitpn
    func setSelectedHeightOfPassword() {
        if let indexDataSource = self.settingDataSource.settingDataSource.firstIndex(
            where: {($0["title"] as? String)! == "Change Password"}) {
            if let index = self.settingConstant.firstIndex(where: {($0["title"] as? String)! == "Change Password"}) {
                let height = (self.settingDataSource.settingDataSource[indexDataSource]["normalHeight"] as? Int)!
                self.settingConstant[index]["normalHeight"] = height
            }
        }
    }
}
