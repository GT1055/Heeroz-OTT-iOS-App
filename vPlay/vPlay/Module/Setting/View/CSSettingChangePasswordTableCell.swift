//
//  CSSettingChangePasswordTableCell.swift
//  vPlay
//
//  Created by user on 30/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
/// Setting Table Password Cell With Button
class CSSettingChangePasswordTableCell: UITableViewCell {
    /// Name Text Label
    @IBOutlet var name: UILabel!
    /// Detail Text Label
    @IBOutlet var detail: UILabel!
    /// Setting Button
    @IBOutlet var settingButton: UIButton!
    /// On And Off Switch
    @IBOutlet var passwordView: UIView!
    /// old Password label
    @IBOutlet var oldPasswordLabel: UILabel!
    /// old password Text Field
    @IBOutlet var oldPassword: UITextField!
    /// new Password label
    @IBOutlet var newPasswordLabel: UILabel!
    /// New password Text Field
    @IBOutlet var newPassword: UITextField!
    /// Confirm Password label
    @IBOutlet var confirmPasswordLabel: UILabel!
    /// Confirm password Text Field
    @IBOutlet var confirmPassword: UITextField!
    /// Update Password
    @IBOutlet var updatePassword: UIButton!
    /// New Password
    @IBOutlet var newPasswordEye: UIButton!
    /// New Password
    @IBOutlet var confirmPasswordEye: UIButton!
    /// New Password
    @IBOutlet var oldPasswordEye: UIButton!
    /// seperator Color in between of PasswordView
    @IBOutlet var separatorView: [UIView]!
    /// Load View
    override func awakeFromNib() {
        rotateAnimation(CGFloat(Double.pi), button: settingButton)
    }
    /// Rotate View animator
    func rotateAnimation(_ rotation: CGFloat, button: UIButton) {
        UIView.transition(with: self, duration: 0.5,
                          options: .transitionCrossDissolve, animations: {() -> Void in
                            button.transform = CGAffineTransform(rotationAngle: rotation)
        }, completion: nil)
    }
    /// Bind Data
    func setBindData(_ data: [String: Any]) {
        self.name.text = NSLocalizedString((data["title"] as? String)!, comment: "Menu")
        self.detail.text = NSLocalizedString((data["detail"]as? String)!, comment: "Menu")
        oldPasswordLabel.text = NSLocalizedString("Current Password", comment: "Guidle Text")
        newPasswordLabel.text = NSLocalizedString("New Password", comment: "Guidle Text")
        confirmPasswordLabel.text = NSLocalizedString("Confirm New Password", comment: "Guidle Text")
        oldPassword.placeholder = NSLocalizedString("Enter Your Current Password", comment: "PlaceHollder")
        newPassword.placeholder = NSLocalizedString("Enter New Password", comment: "PlaceHollder")
        confirmPassword.placeholder = NSLocalizedString("Enter Confirm New Password", comment: "PlaceHollder")
        updatePassword.setTitle(NSLocalizedString("Update Button", comment: "PlaceHollder"), for: .normal)
        changeTheme()
    }
}
// MARK: - UITextFieldDelegate
extension CSSettingChangePasswordTableCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassword {
            newPassword.becomeFirstResponder()
        } else if textField == newPassword {
            confirmPassword.becomeFirstResponder()
        } else {
            confirmPassword.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == oldPassword {
            CSUserValidation.validateAlertMessage(
                title: "Password",
                message: "Your password should be maximum of 15 characters",
                textfield: textField,
                viewController: LibraryAPI.sharedInstance.currentController)
        }
        return true
    }
}
extension CSSettingChangePasswordTableCell {
    /// Current Password View Show
    @IBAction func currentPasswordView(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage.init(named: "passwordViewIcon"), for: .normal)
        } else {
            sender.tag = 0
            sender.setImage(UIImage.init(named: "PasswordHideIcon"), for: .normal)
        }
        oldPassword.togglePasswordVisibility()
    }
    /// New Password View Show
    @IBAction func showNewPasswordView(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage.init(named: "passwordViewIcon"), for: .normal)
        } else {
            sender.tag = 0
            sender.setImage(UIImage.init(named: "PasswordHideIcon"), for: .normal)
        }
        newPassword.togglePasswordVisibility()
    }
    /// Confirm Password View Show
    @IBAction func showConfirmPasswordView(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage.init(named: "passwordViewIcon"), for: .normal)
        } else {
            sender.tag = 0
            sender.setImage(UIImage.init(named: "PasswordHideIcon"), for: .normal)
        }
        confirmPassword.togglePasswordVisibility()
    }
    // Change Theme
    func changeTheme() {
        /* Text and Description Colour change based on Mode */
        self.name.textColor = .settingCellTitle
        oldPasswordLabel.textColor = .settingCellTitle
        newPasswordLabel.textColor = .settingCellTitle
        confirmPasswordLabel.textColor = .settingCellTitle
        self.detail.textColor = .settingCellDescription
        /* Icon Colour change based on Mode */
        newPasswordEye.tintColor = .settingCellIcon
        confirmPasswordEye.tintColor = .settingCellIcon
        oldPasswordEye.tintColor = .settingCellIcon
        settingButton.tintColor = .settingCellIcon
        /* To change Text Field Dark and Light Mode Typeing Color */
        oldPassword.textColor = .textFieldTextColor
        newPassword.textColor = .textFieldTextColor
        confirmPassword.textColor = .textFieldTextColor
        /* To change Text Field Place Holder Color Dark and Light Mode Typeing Color */
        oldPassword.placeHolderColor = .textFieldPlaceHolderColor
        newPassword.placeHolderColor = .textFieldPlaceHolderColor
        confirmPassword.placeHolderColor = .textFieldPlaceHolderColor
        passwordView.backgroundColor = .navigationBarColor
        separatorView.forEach({ $0.backgroundColor = .separatorColor})
    }
}
class VSSeperatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
      self.backgroundColor = .separatorColor
    }
}
