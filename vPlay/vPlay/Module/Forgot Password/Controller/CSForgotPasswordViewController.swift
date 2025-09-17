/*
 *  CSForgotPasswordViewController
 * forgotpassword Controller for reset the change password from login end
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper

class CSForgotPasswordViewController: CSParentViewController, UITextFieldDelegate {
    //Tap gesture view to resign the textfield
    @IBOutlet var parentView: UIView!
    // email test field
    @IBOutlet weak var emailPaswordEmailId: UITextField!
    // reset button
    @IBOutlet weak var resetPassword: UIButton!
    // Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var separator: UIView!
    //A Bool variable to track the textfield
    var activeField = Bool()
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerKeyboardNotifications()
        activeField=false
        setupNavigation()
        setupDarkModeNeeds()
        /// add tap gesture
        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(CSForgotPasswordViewController.tapAction(_ :)))
        parentView.addGestureRecognizer(tapGesture)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Reset Password Button Customisation
    /// Tap Gesture Action
    /// - Parameter sender: Sender
    @objc func tapAction(_ sender: Any) {
        if activeField == true {
            activeField = false
            self.view.endEditing(true)
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0,
                                     width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - KeyBoard Delegates Methods
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSForgotPasswordViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSForgotPasswordViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        controllerTitle = NSLocalizedString("Back to Sign in", comment: "Sign in")
        addLeftBarButton()
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize?.height)!, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /// To set dark mode basic view needs
    func setupDarkModeNeeds() {
         separator.backgroundColor = .separatorColor
         changeViewColor(parentView)
    }
    /// Change color for the view
    func changeViewColor(_ subView: UIView) {
        for current in subView.subviews {
            if current.tag == 100 {
                let label = current as? UILabel
                label?.textColor = .labelTextColor
            } else if current.tag == 105 {
                let currentTextField = current as? UITextField
                currentTextField?.textColor = .textFieldTextColor
                currentTextField?.placeHolderColor = .textFieldPlaceHolderColor
            }
        }
    }
    // MARK: - Reset button action
    @IBAction func sendPasswordButtonAction(_ sender: Any) {
        self.view.endEditing(false)
        if !CSUserValidation.validateEmail(textField: emailPaswordEmailId, viewController: self) { return }
        self.forgotPasswordApi()
    }
    // MARK: - Api Call
    /// Forgot Password Api
    func forgotPasswordApi() {
        // parameter set
        let paramet: [String: String] = ["email": emailPaswordEmailId.text!]
        CSLoginApiModel.forgotPasswordRequest(parentView: self,
                                              parameters: paramet,
                                              completionHandler: { response in
                        self.showSuccessToastMessage(message: response.message)
                        _ = self.navigationController?.popViewController(animated: true)
        })
    }
}
