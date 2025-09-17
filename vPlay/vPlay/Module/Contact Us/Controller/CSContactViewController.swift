/*
 * CSContactViewController.swift
 * This class is used to querie the user to admin team or to raise a flag to the admin
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSContactViewController: CSParentViewController {
    /// user name
    @IBOutlet var userName: UITextField!
    /// user Queries
    @IBOutlet var userQueriesText: CSDoneTextView!
    /// phone number
    @IBOutlet var userPhoneNumber: CSNumberTextField!
    /// user mail id
    @IBOutlet var userMailId: UITextField!
    /// queries Height
    @IBOutlet var queriesHeight: NSLayoutConstraint!
    /// An Outlet for country code text field
    @IBOutlet var countryCodeLabel: UILabel!
    /// An Outlet for country code Image
    @IBOutlet var countryImage: UIImageView!
    // Top title Label
    @IBOutlet weak var topTitleLabel: UILabel!
    // Top view
    @IBOutlet weak var topView: UIView!
    // Drop Down Image View
    @IBOutlet weak var dropDown: UIImageView!
    // Uiscrollview
    @IBOutlet var supportScrollView: UIScrollView!
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultCountry()
        setModeBasedColor()
        self.setupNavigation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Register Notifications
        self.registerKeyboardNotifications()
        userQueriesText.isScrollEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        // UnRegister Notifications
        unregisterKeyboardNotifications()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSCountryCodeListViewController {
            let controller = segue.destination as? CSCountryCodeListViewController
            controller?.countryDelegate = self
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setModeBasedColor() {
        self.addGradientBackGround()
        topTitleLabel.textColor = .contactUsLabel
        dropDown.tintColor = .contactUsIcon
        for sub in topView.subviews {
            if sub.tag == 100 {
                let label = sub as? UILabel
                label?.textColor = .labelTextColor
            } else if sub.tag == 105 {
                let userInput = sub as? UITextField
                userInput?.textColor = .textFieldTextColor
            } else if sub.tag == 110 {
                let textView = sub as? UITextView
                textView?.textColor = .textFieldTextColor
                textView?.borderColor = .separatorColor
            } else if sub.tag == 115 {
                sub.backgroundColor = .separatorColor
            }
        }
    }
}
// MARK: - Add Done button to Keyboard
extension CSContactViewController {
    /// Add Notification
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSContactViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSContactViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        userQueriesText.isScrollEnabled = false
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        supportScrollView.contentInset = contentInsets
        supportScrollView.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        supportScrollView.contentInset = UIEdgeInsets.zero
        supportScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - Text Field Delegate
extension CSContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userName {
            userMailId.becomeFirstResponder()
        } else if textField == userMailId {
            userPhoneNumber.becomeFirstResponder()
        } else if textField == userPhoneNumber {
            userQueriesText.becomeFirstResponder()
        }
        return true
    }
}
// MARK: - Text View Delegate
extension CSContactViewController: CSTextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userName {
            CSUserValidation.validateAlertMessage(
                title: "Name",
                message: "Your name should contain minimum of 3 characters and maximum of 30 characters",
                textfield: textField,
                viewController: self)
        } else if textField == userPhoneNumber {
            CSUserValidation.validateAlertMessage(
                title: "Mobile Number",
                message: "Your mobile number should be maximum of 15 characters",
                textfield: textField,
                viewController: self)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        var newFrame = textView.frame
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        queriesHeight.constant = (newFrame.size.height < 120) ? 120 : newFrame.size.height
    }
}
// MARK: - Private Method
extension CSContactViewController {
    /// NavigationBar
    func setupNavigation() {
        self.addLeftBarButton()
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    /// validate Message
    func validateMessage() {
        if !CSUserValidation.validateName(textField: userName,
                                          viewController: self) { return }
        if !CSUserValidation.validateEmail(textField: userMailId,
                                           viewController: self) { return }
        if !CSUserValidation.validDailCode(label: countryCodeLabel,
                                           viewController: self) { return }
        if !CSUserValidation.validatePhone(textField: userPhoneNumber,
                                           viewController: self) { return }
        if userQueriesText.text! == "" {
            self.showToastMessageTop(message: "Please enter a valid message")
            return
        }
        /// call api for posting Question
        self.submitQueries()
    }
    /// Clear All Data
    func clearAllData() {
        self.userPhoneNumber.text! = ""
        self.userQueriesText.text! = ""
        self.userMailId.text = ""
        self.userName.text = ""
    }
    /// Set Default Country
    func setDefaultCountry() {
        CSCountryApiData.fetchCountryData(
            parentView: self,
            completionHandler: { responce in
                if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                    for country in responce where country.countryCode == countryCode {
                        self.countrySelected(countrySelected: country)
                    }
                }
        })
    }
}
// MARK: - Button Action
extension CSContactViewController {
    // Submit Button action
    @IBAction func submitButtonAction(_ sender: Any) {
        self.validateMessage()
    }
    // Tap Gesture action
    @IBAction func tapGestureAction(_  gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    /// done button finction
    @objc func doneTextViewButtonAction() {
        self.view.endEditing(true)
    }
    /// Country Flag
    @IBAction func selectCountryFlag(_ sender: UIButton) {
        self.performSegue(withIdentifier: "countryFlag", sender: self)
    }
}
// MARK: - Api Request
extension CSContactViewController {
    /// Submit if Any Queries
    func submitQueries() {
        self.view.endEditing(true)
        let countryCode = countryCodeLabel.text!
        let code = countryCode.trimmingCharacters(in: .whitespaces)
        let dailCode: String = code.replacingOccurrences(of: "+", with: "") + userPhoneNumber.text!
        let paramets: [String: String] = [
            "email": userMailId.text!,
            "message": userQueriesText.text!,
            "name": userName.text!,
            "phone": dailCode
        ]
        CSContactApiModel.submitQueries(
            parentView: self, parameters: paramets, completionHandler: { responce in
                self.clearAllData()
                self.showSuccessToastMessage(message: responce.message)
        })
    }
}
// MARK: - Country Flag
extension CSContactViewController: CountrySelectedDelegate {
    func countrySelected(countrySelected country: CSCountryList) {
        self.countryCodeLabel.text = country.countryDialCode
        self.countryImage.image = UIImage.init(named: country.countryCode + ".png")
    }
}
