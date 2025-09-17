/*
 * CSCreateNewCardViewController.swift
 * This class  is used to Create a new Card View
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSCreateNewCardViewController: CSParentViewController {
    let characterBreak = 4, intervalString = "-"
    /// card number label
    @IBOutlet weak var cardNumberLabel: UILabel!
    /// expiry label
    @IBOutlet weak var expiryLabel: UILabel!
    /// ccv label
    @IBOutlet weak var ccvLabel: UILabel!
    /// card holder label
    @IBOutlet weak var cardHolderLabel: UILabel!
    /// info label
    @IBOutlet weak var infoLabel: UILabel!
    /// Update button in manage View
    @IBOutlet weak var payButton: UIButton!
    /// Add Card Scroll View
    @IBOutlet var addCardScrollView: UIScrollView!
    /// Card Input number text field
    @IBOutlet weak var cardNumberTextField: CSNumberTextField!
    /// month inuput text field two digit MM
    @IBOutlet weak var monthInputTextField: CSNumberTextField!
    /// Year inuput text field two digit YY
    @IBOutlet weak var yearInputTextField: CSNumberTextField!
    /// CVC inuput text field two digit cvc in secure field
    @IBOutlet weak var cvcInputTextField: CSNumberTextField!
    /// Card holder name
    @IBOutlet var name: UITextField!
    /// Card number Background View
    @IBOutlet weak var cardNumberView: UIView!
    /// Expiry Date Background View
    @IBOutlet weak var expiryDateView: UIView!
    /// CVV Background View
    @IBOutlet weak var cvvView: UIView!
    /// Card Holder Name Background View
    @IBOutlet weak var cardHolderNameView: UIView!
    ///Month and Year seperator label
    @IBOutlet weak var seperatorLabel: UILabel!
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        setModeBasedColor()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }
    // To set dark mode needs
    func setModeBasedColor() {
        infoLabel.textColor = UIColor.contentColor()
        cardHolderLabel.textColor = UIColor.invertColor(true)
        ccvLabel.textColor = UIColor.invertColor(true)
        expiryLabel.textColor = UIColor.invertColor(true)
        cardNumberLabel.textColor = UIColor.invertColor(true)
        yearInputTextField.textColor = UIColor.invertColor(true)
        monthInputTextField.textColor = UIColor.invertColor(true)
        monthInputTextField.placeHolderColor = UIColor.disabledTextFieldTextColor
        yearInputTextField.placeHolderColor = UIColor.disabledTextFieldTextColor
        cardNumberTextField.textColor = UIColor.invertColor(true)
        cvcInputTextField.textColor = UIColor.invertColor(true)
        name.textColor = UIColor.invertColor(true)
        seperatorLabel.textColor = UIColor.disabledTextFieldTextColor
        let color = (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.navigationBarColor : UIColor.invertColor(false)
        cardNumberView.backgroundColor = color
        expiryDateView.backgroundColor = color
        cvvView.backgroundColor = color
        cardHolderNameView.backgroundColor = color
    }
}
// MARK: - Private Method
extension CSCreateNewCardViewController {
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        controllerTitle = NSLocalizedString("Add Credit / Debit Card", comment: "Card")
        addLeftBarButton()
    }
}
/// MARK: - Button Action
extension CSCreateNewCardViewController {
    /// Action to take place when update button is enabled
    /// - Parameter sender: Any
    @IBAction func updateAction(_ sender: Any) {
        validatingTextField()
    }
    /// End Editing
    /// - Parameter sender: Any
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
}
// MARK: - Text Field Delegate
extension CSCreateNewCardViewController: UITextFieldDelegate {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSCreateNewCardViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSCreateNewCardViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = (notification.userInfo as NSDictionary?)!
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0,
                                         bottom: (keyboardSize?.height)!,
                                         right: 0)
        addCardScrollView.contentInset = contentInsets
        addCardScrollView.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        addCardScrollView.contentInset = UIEdgeInsets.zero
        addCardScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    func changeBorderColor(_ textField: UITextField, isActive: Int) {
        if let view = textField.superview {
            let color = isActive == 1 ? UIColor.customBackGroundColor() : UIColor.navigationHeaderColor()
            view.layer.borderColor = color.cgColor
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.changeBorderColor(textField, isActive: 1)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.changeBorderColor(textField, isActive: 0)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardNumberTextField {
            monthInputTextField.becomeFirstResponder()
        } else if textField == monthInputTextField {
            yearInputTextField.becomeFirstResponder()
        } else if textField == yearInputTextField {
            cvcInputTextField.becomeFirstResponder()
        } else if textField == cvcInputTextField {
            name.becomeFirstResponder()
        } else if textField == name {
            self.view.endEditing(true)
        }
        return true
    }
}
// MARK: - Card Validation Private Method
extension CSCreateNewCardViewController {
    /// emptyCard Info Details
    func emptyCardInfoDetails() {
        monthInputTextField.text = ""
        yearInputTextField.text = ""
        cvcInputTextField.text = ""
        name.text = ""
        cardNumberTextField.text = ""
        self.view.endEditing(true)
    }
    /// Validating textfield
    func validatingTextField() {
        self.view.endEditing(true)
        /// Card Validating
        if !cardNumberTextField.text!.validateNotEmpty() {
            self.showToastMessageTop(message:
                NSLocalizedString("Please enter a card number", comment: "error message"))
            return
        }
        if !CSUserValidation.validateCardNumber(textField: cardNumberTextField,
                                                viewController: self) { return }
        if !monthInputTextField.text!.validateNotEmpty() {
            self.showToastMessageTop(message:
                NSLocalizedString("Please enter a card exprie month", comment: "error message"))
            return
        }
        if !CSUserValidation.validateCardMonth(textField: monthInputTextField,
                                               viewController: self) { return }
        if !yearInputTextField.text!.validateNotEmpty() {
            self.showToastMessageTop(message:
                NSLocalizedString("Please enter a card exprie year", comment: "error message"))
            return
        }
        if !CSUserValidation.validateCardYear(textField: yearInputTextField,
                                              viewController: self) { return }
        if !cvcInputTextField.text!.validateNotEmpty() {
            self.showToastMessageTop(message:
                NSLocalizedString("Please enter a card cvv number", comment: "error message"))
            return
        }
        if !CSUserValidation.validateCardCVV(textField: cvcInputTextField,
                                             viewController: self) { return }
        if !CSUserValidation.validateName(textField: name,
                                          viewController: self) { return }
        if monthInputTextField.tag == 1, yearInputTextField.tag == 1 {
            self.showToastMessageTop(message:
                NSLocalizedString("Your card has been expied", comment: "error message"))
            return
        }
        addNewCard()
    }
}
// MARK: - card validation and Getting of card details
extension CSCreateNewCardViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == cardNumberTextField {
            return self.cardNumberValidation(textField, shouldChangeCharactersIn: range,
                                             replacementString: string)
        } else if textField == monthInputTextField {
            return self.monthValidation(textField, shouldChangeCharactersIn: range,
                                        replacementString: string)
        } else if textField == yearInputTextField {
            return self.yearValidation(textField, shouldChangeCharactersIn: range,
                                       replacementString: string)
        } else if textField == cvcInputTextField {
            if range.location == 3 {
                name.becomeFirstResponder()
                return false
            }
        }
        return true
    }
    /// Card Number and insert a "-" or " "
    func canInsert(atLocation value: Int) -> Bool {
        return ((1 + value)%(characterBreak + 1) == 0) ? true : false
    }
    /// Rearrange the word of a array
    func canRemove(atLocation value: Int) -> Bool {
        return (value != 0) ? (value%(characterBreak + 1) == 0) : false
    }
    /// Month And Year are In Valid
    func monthAndYearFalse() {
        monthInputTextField.textColor = .red
        yearInputTextField.textColor = .red
        monthInputTextField.tag = 1
        yearInputTextField.tag = 1
    }
    /// Month And Year are Valid
    func monthAndYearTrue() {
        monthInputTextField.textColor = UIColor.invertColor(true)
        yearInputTextField.textColor = UIColor.invertColor(true)
        monthInputTextField.tag = 0
        yearInputTextField.tag = 0
    }
    /// Card Number Validation
    func cardNumberValidation(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                              replacementString string: String) -> Bool {
        let nsText = textField.text! as NSString
        if range.location == 19 {
            monthInputTextField.becomeFirstResponder()
            return false
        }
        if range.length == 0 && canInsert(atLocation: range.location) {
            textField.text! = textField.text! + intervalString + string
            return false
        }
        if range.length == 1 && canRemove(atLocation: range.location) {
            textField.text! = nsText.replacingCharacters(in: NSRange(location: range.location-1, length: 2),
                                                         with: "")
            return false
        }
        return string.allowOnlyDigits()
    }
    /// Month validation
    func monthValidation(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                         replacementString string: String) -> Bool {
        let currentYear =  Date().getYearName()
        let enterYear = Int(yearInputTextField.text!) ?? 0
        if string == "1" || string == "0" && range.location == 0 {
            return true
        } else if range.location == 1 {
            let value = textField.text! + string
            monthInputTextField.textColor = .black
            let monthNumber: Int = Int(value) ?? 0
            if monthNumber < 13 && monthNumber != 0 {
                if enterYear != 0 && enterYear == currentYear {
                    monthAndYearTrue()
                } else {
                    monthAndYearFalse()
                }
                return true
            } else {
                return false
            }
        } else if range.location == 2 {
            yearInputTextField.becomeFirstResponder()
            return false
        } else {
            if string == "" {
                return true
            }
            return false
        }
    }
    /// Year validation
    func yearValidation(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool {
        let month =  Date().getMonthName()
        let currentYear =  Date().getYearName()
        let enterMonth = Int(monthInputTextField.text!) ?? 0
        let value = textField.text! + string
        let enterYear: Int = Int(value) ?? 0
        if range.location == 2 {
            cvcInputTextField.becomeFirstResponder()
            return false
        }
        if value.count < 2 {
            monthAndYearTrue()
            return true
        } else if value.count < 3 && enterYear < 100 {
            if enterYear < currentYear {
                monthAndYearFalse()
            } else if enterYear == currentYear {
                if enterMonth < month {
                    monthAndYearFalse()
                } else {
                    monthAndYearTrue()
                }
            } else {
                monthAndYearTrue()
            }
            return true
        } else {
            return false
        }
    }
}
/// MARK: - Api request
extension CSCreateNewCardViewController {
    /// Add New Card
    func addNewCard() {
        let cardMonth = String(describing: Int((self.monthInputTextField.text)!)!)
        let cardYear = String(describing: Int((self.yearInputTextField.text)!)!)
        let cardNumber = self.cardNumberTextField.text!.replacingOccurrences(of: "-", with: "")
        let parameter: [String: String] = ["name": self.name.text!,
                                           "card_number": cardNumber,
                                           "cvv": self.cvcInputTextField.text!,
                                           "month": cardMonth,
                                           "year": cardYear,
                                           "type": "credit"]
        CSCardApiModel.addCardApi(
            parentView: self,
            parameters: parameter,
            completionHandler: { _ in
                self.emptyCardInfoDetails()
                if let viewControllers = self.navigationController?.viewControllers {
                    for controller in viewControllers where controller is CSCardListViewController {
                        let parent = controller as? CSCardListViewController
                        parent?.callApi()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        })
    }
}
