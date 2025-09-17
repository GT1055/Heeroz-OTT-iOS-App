/*
 * SettingsViewcontroller
 * This Controller is used to change the settings
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper

class SettingsViewcontroller: CSParentViewController {
    /// Data Source Of Table View
    @IBOutlet weak var settingDataSource: CSSettingTableDataSource!
    /// Table View
    @IBOutlet weak var settingTable: UITableView!
    // Setting Constant Value
    var settingConstant = [[String: Any]]()
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        settingTable.tableFooterView = UIView()
        settingTable.separatorColor = .separatorColor
        settingDataSource.delegate = self
        settingConstant = constant
        self.registerKeyboardNotifications()
        callApi()
    }
    override func callApi() {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            if controllerTitle == NSLocalizedString("Language", comment: "Language")
            {
               removeUnwantedDataForLanguage()
            }else{
                self.removeUnwantedDataIfUserIsNotLogin()
            }
            return
        }
        self.getNotificationStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SettingsViewcontroller: CSTableViewDelegate {
    func tableviewDelegate(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // settingTable.reloadData()
    }
}
// MARK: - notification Methods
extension SettingsViewcontroller {
    /// register Notification
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(SettingsViewcontroller.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(SettingsViewcontroller.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// Unregister Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    /// Content Inset Change on Keybord Show
    /// - Parameter notification: self.Notification
    @objc func keyboardDidShow(notification: NSNotification) {
        let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        var contentInsets = UIEdgeInsets()
        contentInsets = UIEdgeInsets(top: 0, left: 0,
                                     bottom: (keyboardSize?.height)!, right: 0)
        self.settingTable.contentInset = contentInsets
    }
    /// Content Inset Change on Keybord Hide
    /// - Parameter notification: self.Notification
    @objc func keyboardWillHide(notification: NSNotification) {
        self.settingTable.contentInset = UIEdgeInsets.zero
    }
}
// MARK: - Tap gesture action add for dismiss the view
extension SettingsViewcontroller {
    /// Change Password Validation
    func validateChangePassword(_ cell: CSSettingChangePasswordTableCell) {
        self.view.endEditing(true)
        if !CSUserValidation.validatePassword(textField: cell.oldPassword,
                                              viewController: self) { return }
        if !CSUserValidation.validatePassword(textField: cell.newPassword,
                                              viewController: self) { return }
        if !CSUserValidation.validatePassword(textField: cell.confirmPassword,
                                              viewController: self) { return }
        if cell.oldPassword.text! == cell.newPassword.text! {
            self.showToastMessageTop(message:
                NSLocalizedString("Your new password and old password are same", comment: "password"))
            return
        }
        if cell.newPassword.text! != cell.confirmPassword.text! {
            self.showToastMessageTop(message:
                NSLocalizedString("Your new password and confirm password are not same", comment: "password"))
            return
        }
        self.changePassword(cell)
    }
    func changeLangaugeAction(_ sender: UIButton) {
        CSOptionDropDown.langaugeListingDropdown(
            button: sender,
            completionHandler: { [unowned self] index in
                if index == 0 {
                    CSLanguage.setAppleLAnguageTo(lang: "en")
                }else {
                    CSLanguage.setAppleLAnguageTo(lang: "pa-IN")
                }
                self.refreshNavigation()
        })
    }
    func rotateAnimation(_ rotation: CGFloat, button: UIButton) {
        UIView.transition(with: self.view, duration: 0.5,
                          options: .transitionCrossDissolve, animations: {() -> Void in
                            button.transform = CGAffineTransform(rotationAngle: rotation)
                            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
// MARK: - Api Call
extension SettingsViewcontroller {
    /// Change Password
    func changePassword(_ cell: CSSettingChangePasswordTableCell) {
        /// Add parmaters
        let paramet: [String: String] = [
            "old_password": cell.oldPassword.text!,
            "password": cell.newPassword.text!,
            "password_confirmation": cell.confirmPassword.text!
        ]
        CSSettingModelApi.changePasswordRequest(
            parentView: self,
            parameters: paramet,
            completionHandler: { [unowned self] responce in
                self.showSuccessToastMessage(message: responce.message)
                cell.oldPassword.text = ""
                cell.newPassword.text = ""
                cell.confirmPassword.text = ""
        })
    }
    /// Get Notification Status
    func getNotificationStatus() {
        if controllerTitle == NSLocalizedString("Language", comment: "Language")
        {
           removeUnwantedDataForLanguage()
            return
        }
        CSSettingModelApi.notificationStatusUpdate(
            parentView: self,
            parameters: nil,
            completionHandler: {[unowned self] responce in
                self.changeValueOfReplyAndVideoComment(
                    responce.responseRequired.notificationSetting.replyComment,
                    videoStatus: responce.responseRequired.notificationSetting.newVideo)
                self.changeValueOfAutoPlayVideos(responce.responseRequired.notificationSetting.autoPlay)
                if let index = self.settingConstant.firstIndex(
                    where: { ($0["title"] as? String)! == "Dark Theme" }) {
                    if LibraryAPI.sharedInstance.isDarkMode() {
                        self.settingConstant[index]["status"] = 1
                    } else {
                        self.settingConstant[index]["status"] = 0
                    }
                }
                if let index = self.settingConstant.firstIndex(
                    where: { ($0["title"] as? String)! == "Subscription" }) {
                    if responce.responseRequired.notificationSetting.isSubscribed != 1 {
                        self.settingConstant.remove(at: index)
                    }
                }
                if let index = self.settingConstant.firstIndex(
                    where: { ($0["title"] as? String)! == "Language" }) {
                    if responce.responseRequired.notificationSetting.isSubscribed != 1 {
                        self.settingConstant.remove(at: index)
                    }
                }
                if LibraryAPI.sharedInstance.isSocialLogin() {
                    if let index = self.settingConstant.firstIndex(
                        where: { ($0["title"] as? String)! == "Change Password" }) {
                        self.settingConstant.remove(at: index)
                    }
                }
                self.settingDataSource.settingDataSource = self.settingConstant
                self.settingTable.reloadData()
        })
    }
    /// Cancel Subscription API
    func cancelSubscription() {
        CSSettingModelApi.cancelSubscription(
            parentView: self,
            completionHandler: { _ in
                if let index = self.settingConstant.firstIndex(
                    where: { ($0["title"] as? String)! == "Subscription" }) {
                    self.settingConstant.remove(at: index)
                }
                LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed",
                                                          value: "0")
                LibraryAPI.sharedInstance.setUserDefaults(key: "planName", value: "")
            self.settingDataSource.settingDataSource = self.settingConstant
            self.settingTable.reloadData()
    })
}
}
extension SettingsViewcontroller {
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if (self.settingDataSource.settingDataSource[sender.tag]["title"] as? String)! == "Subscription" {
            self.showAlertView(
                title: NSLocalizedString("Cancel Subscription", comment: ""),
                message: NSLocalizedString("Are you sure you want to cancel subscription?", comment: ""))
        } else if (self.settingDataSource.settingDataSource[sender.tag]["title"] as? String)! == "Language" {
            self.changeLangaugeAction(sender)
        }
    }
    @IBAction func changePasswordAction(_ sender: UIButton) {
        if (self.settingDataSource.settingDataSource[sender.tag]["isExpand"] as? Int)! == 0 {
            self.settingDataSource.settingDataSource[sender.tag]["isExpand"] = 1
            self.settingDataSource.settingDataSource[sender.tag]["normalHeight"] = 350
            self.rotateAnimation(0, button: sender)
        } else {
            self.settingDataSource.settingDataSource[sender.tag]["isExpand"] = 0
            self.settingDataSource.settingDataSource[sender.tag]["normalHeight"] = 70
            self.rotateAnimation(CGFloat(Double.pi), button: sender)
        }
        settingTable.beginUpdates()
        settingTable.endUpdates()
    }
    @IBAction func openNotificationAction(_ sender: UIButton) {
        if (self.settingDataSource.settingDataSource[sender.tag]["isExpand"] as? Int)! == 0 {
            self.settingDataSource.settingDataSource[sender.tag]["isExpand"] = 1
            self.settingDataSource.settingDataSource[sender.tag]["normalHeight"] = 220
            self.rotateAnimation(0, button: sender)
        } else {
            self.settingDataSource.settingDataSource[sender.tag]["isExpand"] = 0
            self.settingDataSource.settingDataSource[sender.tag]["normalHeight"] = 69
            self.rotateAnimation(CGFloat(Double.pi), button: sender)
        }
        settingTable.beginUpdates()
        settingTable.endUpdates()
    }
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        let indexPath = IndexPath.init(row: sender.tag, section: 0)
        if let cell = settingTable.cellForRow(at: indexPath) as? CSSettingChangePasswordTableCell {
            self.validateChangePassword(cell)
        }
    }
}
var constant = [
    ["title": "Autoplay Videos",
     "detail": "On/Off videos playing automatically",
     "type": "switch",
     "status": 0],
    ["title": "Dark Theme",
     "detail": "Enable dark theme throughout the app",
     "type": "switch",
     "status": 0],
    ["title": "Language",
     "detail": "Select a language you prefer",
     "type": "Button",
     "status": 0],
    ["title": "Subscription",
     "detail": "You can cancel your subscription",
     "type": "Button",
     "status": 0],
    ["title": "All Notification",
     "detail": "On/Off message notification",
     "type": "notification",
     "isExpand": 0,
     "normalHeight": 69,
     "replyStatus": 0,
     "videoStatus": 0],
    ["title": "Change Password",
     "detail": "Chosse your account password",
     "type": "Password",
     "isExpand": 0,
     "normalHeight": 70]
]
