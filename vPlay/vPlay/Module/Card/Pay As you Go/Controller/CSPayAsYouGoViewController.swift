/*
 * CSPayAsYouGoViewController.swift
 * This class  is used to Create a new Card View and save it if nessary
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSPayAsYouGoViewController: CSParentViewController {
    let characterBreak = 4, intervalString = "-"
    /// Plan Name
    var subscriptionPlanId = PlanList()
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
    /// Dummy label
    @IBOutlet weak var dummyInfoLabel: UILabel!
    /// Top View
    @IBOutlet weak var topView: UIView!
    /// Top View Height
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    /// Cost Label
    @IBOutlet var costLabel: UILabel!
    /// Update button in manage View
    @IBOutlet weak var payButton: UIButton!
    /// Add Card Scroll View
    /// Pay as you go stackview
    @IBOutlet weak var paymentStack: UIStackView!
    @IBOutlet var addCardScrollView: UIScrollView!
    /// Card Input number text field
    @IBOutlet weak var cardNumberTextField: CSNumberTextField!
    /// month inuput text field two digit MM
    @IBOutlet weak var monthInputTextField: CSNumberTextField!
    /// Year inuput text field two digit YY
    @IBOutlet weak var yearInputTextField: CSNumberTextField!
    /// CVC inuput text field two digit cvc in secure field
    @IBOutlet weak var cvcInputTextField: CSNumberTextField!
    /// Card number Background View
    @IBOutlet weak var cardNumberView: UIView!
    /// saveCardView View
    @IBOutlet weak var saveCardView: UIView!
    /// Expiry Date Background View
    @IBOutlet weak var expiryDateView: UIView!
    /// CVV Background View
    @IBOutlet weak var cvvView: UIView!
    /// Card Holder Name Background View
    @IBOutlet weak var cardHolderNameView: UIView!
    ///Month and Year seperator label
    @IBOutlet weak var seperatorLabel: UILabel!
    /// Card holder name
    @IBOutlet var name: UITextField!
    /// set UView
    @IBOutlet var selectCardView: UIView!
    /// Validation of Video page
    var isVideoPage = false
    /// video data
    var videodetailContent : VideoResponse!
    // MARK: - UIView Controller Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setDarkModeNeeds()
        setTitleToLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }
}
// MARK: - Button Action
extension CSPayAsYouGoViewController {
    /// Action to take place when close button is enabled
    /// - Parameter sender: Any
    @IBAction func saveCardOnChecked(_ sender: UIButton) {
        selectCardView.isHidden = !selectCardView.isHidden
    }
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
    /// To set dark mode needs
    func setDarkModeNeeds() {
        // topView.backgroundColor = .navigationBarColor
        costLabel.textColor = UIColor.invertColor(true)
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
        dummyInfoLabel.textColor = UIColor.contentColor()
        seperatorLabel.textColor = UIColor.disabledTextFieldTextColor
        let color = (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.navigationBarColor : UIColor.invertColor(false)
        cardNumberView.backgroundColor = color
        expiryDateView.backgroundColor = color
        cvvView.backgroundColor = color
        cardHolderNameView.backgroundColor = color
    }
}
// MARK: - Private Method
extension CSPayAsYouGoViewController {
    /// Title label
    func setTitleToLabel() {
        if (videodetailContent != nil) {
            topViewHeight.constant = 0
            costLabel.isHidden = true
            saveCardView.isHidden = true
            let cost = "$" + String(videodetailContent.videoDict.price)
            let text = NSLocalizedString("Subscription for", comment: "Subscription") + " " + cost
            attributeTextProperty(amount: cost, color: UIColor.themeColorButton(),
                                  text: text)
        } else {
        let cost = "$" + String(subscriptionPlanId.planAmount) + "/"
        let duration = String(subscriptionPlanId.planType)
        let text = NSLocalizedString("Subscription for", comment: "Subscription") + " " + cost + duration
        attributeTextProperty(amount: cost, duration: duration, color: UIColor.themeColorButton(),
                              text: text) }
    }
    /// Attribute TExt Color
    func attributeTextProperty(amount: String, color: UIColor,
                               text: String) {
        let attrib = NSMutableAttributedString(string: text, attributes: [.font: UIFont.costAndDurationCardPage()])
        let range1 = (text as NSString).range(of: amount)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.alignment = .center
        attrib.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle,
                            range: NSRange(location: 0, length: attrib.length))
        attrib.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        costLabel.attributedText = attrib
    }
    /// Attribute TExt Color
    func attributeTextProperty(amount: String, duration: String, color: UIColor,
                               text: String) {
        let attrib = NSMutableAttributedString(string: text, attributes: [.font: UIFont.costAndDurationCardPage()])
        let range1 = (text as NSString).range(of: amount)
        let range2 = (text as NSString).range(of: duration)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.alignment = .center
        attrib.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle,
                            range: NSRange(location: 0, length: attrib.length))
        attrib.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range1)
        attrib.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range2)
        costLabel.attributedText = attrib
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
}
/// MARK: - Api request
extension CSPayAsYouGoViewController {
    // Make Payment
    func makePayment() {
        let cardNumber = self.cardNumberTextField.text!.replacingOccurrences(of: "-", with: "")
        var parameter: [String: String] = ["subscription_plan_id": String(self.subscriptionPlanId.planId),
                                           "payment_method_id": "1",
                                           "name": self.name.text!,
                                           "card_number": cardNumber,
                                           "cvv": self.cvcInputTextField.text!,
                                           "month": self.monthInputTextField.text!,
                                           "year": self.yearInputTextField.text!,
                                           "type": "credit"]
        if !selectCardView.isHidden {
            parameter["is_save"] = "1"
        } else {
            parameter["is_save"] = "0"
        }
        CSCardApiModel.makePaymentApi(
            parentView: self,
            parameters: parameter,
            completionHandler: { responce in
                self.emptyCardInfoDetails()
                self.payButton.isUserInteractionEnabled = true
                self.transactionView(responce.responce.transaction)
                self.navigationController?.isNavigationBarHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.0, execute: {
                    LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
                    LibraryAPI.sharedInstance.setUserDefaults(key: "planName",
                                                              value: self.subscriptionPlanId.planName)
                    self.navigationController?.isNavigationBarHidden = false
                    if let viewControllers = self.navigationController?.viewControllers {
                        if !self.isVideoPage {
                            for controller in viewControllers
                                where controller is CSSlideMenuViewController {
                                    let slideMenu = controller as? CSSlideMenuViewController
                                    slideMenu?.callApi()
                                    self.navigationController?.popToViewController(controller, animated: true)
                            }
                        } else {
                            for controller in viewControllers
                                where controller is CSVideoDetailViewController {
                                    let videoDetail = (controller as? CSVideoDetailViewController)!
                                    videoDetail.callApi()
                                    self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                })
        })
    }
    /// add addChildView
    func transactionView(_ details: CSTransaction) {
        let controller = (subscriptionStoryBoard.instantiateViewController(withIdentifier:
            "CSTransactionStatusViewController") as? CSTranscationStatusViewController)!
        controller.details = details
        controller.view.frame = self.view.bounds
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
}
// MARK: - Text Field Delegate
extension CSPayAsYouGoViewController: UITextFieldDelegate {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSPayAsYouGoViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSPayAsYouGoViewController.keyboardWillHide(notification:)),
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
extension CSPayAsYouGoViewController {
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
                NSLocalizedString("Please enter a card exprie year",
                                  comment: "error message"))
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
        };
        payButton.isUserInteractionEnabled = false
        if (videodetailContent != nil) {
            transactionPayment() }
        else { makePayment() }
    }
}
// MARK: - Api request Method
extension CSPayAsYouGoViewController {
    // Make Payment
    func transactionPayment() {
        let parameter: [String: String] = ["slug": String(videodetailContent.videoDict.responseId),
                                           "price": String(videodetailContent.videoDict.price),]
        CSCardApiModel.transPaymentApi(
            parentView: self,
            parameters: parameter,
            completionHandler: { responce in
                self.payButton.isUserInteractionEnabled = true
                self.transactionView(responce.responce.transaction)
                self.navigationController?.isNavigationBarHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.0, execute: {
                    self.navigationController?.isNavigationBarHidden = false
                    if let viewControllers = self.navigationController?.viewControllers {
                        for controller in viewControllers
                            where controller is CSVideoDetailViewController {
                                let videoDetail = controller as? CSVideoDetailViewController
                                videoDetail?.callApi()
                                self.navigationController?.popToViewController(controller, animated: true)
                        }
                    }
                })
        })
    }
}
