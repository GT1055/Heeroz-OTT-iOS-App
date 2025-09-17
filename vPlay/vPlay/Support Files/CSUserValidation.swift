/*
 * CSUserDetailValidation.Swift
 * This class  is used to controll Validate the user Details
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSUserValidation: NSObject {
    /// validateEmail Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateEmail(textField: AnyObject, viewController: UIViewController) -> Bool {
        let email = textField as? UITextField
        if email?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter your E-mail id",
                                  comment: "Email"))
            return false
        }
        if !((email?.text?.validateEmail(true))!) {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a vaild E-mail id",
                                  comment: "Email"))
            return false
        }
        return true
    }
    /// validateEmail Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validDailCode(label: AnyObject, viewController: UIViewController) -> Bool {
        let dailCode = label as? UILabel
        if dailCode?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid dail code",
                                  comment: "Email"))
            return false
        }
        return true
    }
    /// validateEmail Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateTextEmail(emailText: String, viewController: UIViewController) -> Bool {
        if emailText.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Update a email id",
                                  comment: "Email"))
            return false
        }
        if !(emailText.validateEmail(true)) {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a vaild E-mail id",
                                  comment: "Email"))
            return false
        }
        return true
    }
    ///  Card Number Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateCardNumber(textField: AnyObject, viewController: UIViewController) -> Bool {
        let number = textField as? UITextField
        if number?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a your card number", comment: "error message"))
            return false
        }
        if (number?.text?.count)! < 19 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid card number", comment: "error message"))
            return false
        }
        return true
    }
    ///  Card Month  Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateCardMonth(textField: AnyObject, viewController: UIViewController) -> Bool {
        let number = textField as? UITextField
        if number?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a your expire Month", comment: "error message"))
            return false
        }
        if (number?.text?.count)! < 2 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid expire Month", comment: "error message"))
            return false
        }
        return true
    }
    ///  Card Month  Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateCardYear(textField: AnyObject, viewController: UIViewController) -> Bool {
        let number = textField as? UITextField
        if number?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a your expire Year", comment: "error message"))
            return false
        }
        if (number?.text?.count)! < 2 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid expire Year", comment: "error message"))
            return false
        }
        return true
    }
    ///  Card Month  Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateCardCVV(textField: AnyObject, viewController: UIViewController) -> Bool {
        let number = textField as? UITextField
        if number?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a your CVV Number", comment: "error message"))
            return false
        }
        if (number?.text?.count)! < 2 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid CVV Number", comment: "error message"))
            return false
        }
        return true
    }
    ///  Name Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateName(textField: AnyObject, viewController: UIViewController) -> Bool {
        let name = textField as? UITextField
        if name?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a your name", comment: "error message"))
            return false
        }
        if (name?.text?.count)! < 3 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid name", comment: "error message"))
            return false
        }
        return true
    }
    /// Alert Message
    class func validateAlertMessage(title: String, message: String, textfield: AnyObject,
                                    viewController: UIViewController) {
        viewController.showToastMessageTop(message: NSLocalizedString(message, comment: title))
//        let name = textfield as? UITextField
//        if name?.tag == 0 {
//            let alertController = UIAlertController(title: NSLocalizedString(title, comment: "User Name"),
//                                                    message: NSLocalizedString(message, comment: "User Name"),
//                                                    preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel,
//                                                    handler: { _ in
//                                                        name?.tag = 1
//            }))
//            viewController.present(alertController, animated: true, completion: nil)
//        }
    }
    ///  Phone Number Validation
    class func validateAlertMessageForPhoneNumber(textField: AnyObject, viewController: UIViewController) -> Bool {
        viewController.showToastMessageTop(message:
            NSLocalizedString("Your mobile number should contain 10 characters", comment: "error message"))
        return false
    }
    /// validate Password Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validatePassword(textField: AnyObject, viewController: UIViewController) -> Bool {
        let password = textField as? UITextField
        if password?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Password field is required",
                                  comment: "password"))
            return false
        }
        if (password?.text?.count)! < 6 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Password must be atleast 6 Characters",
                                  comment: "password"))
            return false
        }
        return true
    }
    /// Phone Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validatePhone(textField: AnyObject, viewController: UIViewController) -> Bool {
        let phone = textField as? UITextField
        if (viewController is CSEditProfileViewController && phone?.text?.count == 0){
            return true
        }
    
        if (phone?.text!.isEmpty)! {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid moble Number",
                                  comment: "error message"))
            return false
        }
        if (phone?.text!.count)! < 10 {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Mobile number must be atleast 10 Characters",
                                  comment: "error message"))
            return false
        }
        if phone?.text?.validatePhone() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please enter a valid moble Number", comment: "error message"))
            return false
        }
        return true
    }
    /// validate Age Validation
    ///
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validateAge(textField: AnyObject, viewController: UIViewController) -> Bool {
        let ageField = textField as? UITextField
        if (viewController is CSEditProfileViewController && ageField?.text?.count == 0){
            return true
        }
        if ageField?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please select your date of Birth",
                                  comment: "Date Of Birth"))
            return false
        }
        return true
    }
    /// Validate Download Url
    /// - Parameters:
    ///   - viewController: self
    ///   - stringUrl: Download Url is present or not
    /// - Returns: true or false
    class func isPaidDownload(viewController: UIViewController, stringUrl: String, isDemo: Int) -> Bool {
        if isDemo == 1 {
            viewController.showToastMessageTop(message: NSLocalizedString("Please contact Heeroz team",
                                                                          comment: "Subscription"))
            return false
        }
        if stringUrl.isEmpty {
            viewController.showToastMessageTop(message: NSLocalizedString("No attachment found",
                                                                          comment: "Attachement"))
            return false
        }
        return true
    }
    /// Validate Playlist
    /// - Parameter textField: textfield
    /// - Returns: true or false
    class func validatePlayList(textField: AnyObject, viewController: UIViewController) -> Bool {
        let playlist = textField as? UITextField
        if playlist?.text?.validateNotEmpty() == false {
            viewController.showToastMessageTop(message:
                NSLocalizedString("Please give a name to your playlist",
                                  comment: "Playlist"))
            return false
        }
        return true
    }
}
extension String {
    /// Add Price
    func addPrice() -> String {
        if self.isEmpty {
            return NSLocalizedString("$ ", comment: "ammount") + "0"
        }
        return NSLocalizedString("$ ", comment: "ammount") + self
    }
    /**
     This method is used Validate a Non Empty Condition
     @return bool Value '0' if it is empty  '1' if it is non empty
     */
    func validateNotEmpty() -> Bool {
        var string: String = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.isEqual(NSNull()) {
            string = ""
        }
        return ((string.count) != 0)
    }
    /// Trims the WhiteSpace
    /// - Returns: A sring Value
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    /**
     This method Validates Email
     @return bool value '1'if it is a valid Email, '0' if it is not a valid Email
     */
    func validateEmail(_ stricterFilter: Bool) -> Bool {
        let stricterFilterString: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let laxString: String = ".+@.+\\.[A-Za-z]{2}[A-Za-z]*"
        let emailRegex: String = stricterFilter ? stricterFilterString: laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    /**
     This method Validates All International Phone Numbers
     @return bool value
     */
    func validatePhone() -> Bool {
        let phoneRegex: String = "^((\\+)|(0)|())[0-9]{5,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let phoneValidates: Bool = phoneTest.evaluate(with: self)
        return phoneValidates
    }
    // String Extensions to get the current time
    func getCurrentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let someDateTime = formatter.string(from: currentDate)
        return someDateTime
    }
    /// First Letter Captilaizing
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    /**
     This method is used to remove the html string
     @return string
     */
    func removeHtmlFromString() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;",
                                                                 with: "", options: .regularExpression, range: nil)
    }
    // Allow Only Digits
    func allowOnlyDigits() -> Bool {
        let allowedCharacters = CharacterSet.init(charactersIn: "0123456789-")
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
