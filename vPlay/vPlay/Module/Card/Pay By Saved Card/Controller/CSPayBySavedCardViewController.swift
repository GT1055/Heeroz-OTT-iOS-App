/*
 * CSPayBySavedCardViewController.swift
 * This class is used to list all card and choose any one of the card and make purchase
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSPayBySavedCardViewController: CSParentViewController {
    /// Pay button
    @IBOutlet weak var payButton: UIButton!
    /// Top View
    @IBOutlet weak var topView: UIView!
    /// Top View Height
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    /// info Label
    @IBOutlet weak var infoLabel: UILabel!
    /// Scroll View
    @IBOutlet var saveCardScrollView: UIScrollView!
    /// Cost Label
    @IBOutlet var costLabel: UILabel!
    /// Card Listing Array
    var cardListArray = [CSCardList]()
    /// Card List in collection Data Sources
    @IBOutlet var cardListCollectionDataSources: CSCardListingDataSource!
    /// Card List in collection View
    @IBOutlet var cardListCollection: UICollectionView!
    /// Validation of Video page
    var isVideoPage = false
    /// Plan Name
    var subscriptionPlanId = PlanList()
    /// video data
    var videodetailContent : VideoResponse!
    /// Selected Card Id
    var selectedCardId = Int()
    /// Selected Card Cvv
    var selectedCardCvv = String()
    // MARK: - UIView Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setDarkModeNeeds()
        setTitleToLabel()
        callApi()
        // Do any additional setup after loading the view.
    }
    override func callApi() {
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }
    /// To set dark mode needs
    func setDarkModeNeeds() {
       // topView.backgroundColor = UIColor.navigationBarColor
        costLabel.textColor = UIColor.invertColor(true)
        infoLabel.textColor = UIColor.contentColor()
    }
}
// MARK: - Button Action
extension CSPayBySavedCardViewController {
    @IBAction func makePaymentButtonAction(_ sender: UIButton) {
        if self.selectedCardId == 0 {
            self.showToastMessageTop(message:
                NSLocalizedString("Please selected card to make payment",
                                  comment: "card"))
            return
        }
        payButton.isUserInteractionEnabled = false
        if (videodetailContent != nil) {
            transactionPayment() }
        else { makePayment() }
    }
    @IBAction func selectCardNumber(_ sender: UIButton) {
        self.view.endEditing(true)
        let index = IndexPath.init(row: sender.tag, section: 0)
        if let cell = cardListCollection.cellForItem(at: index) as? CSCardCollectionCell {
            if cell.cardCvvNumber.text!.isEmpty {
                cell.cardCvvNumber.becomeFirstResponder()
                self.showToastMessageTop(message:
                    NSLocalizedString("Please add cvv/cvc for the selected card",
                                      comment: "card"))
                return
            }
            if cell.selectCardImage.isHidden {
                cell.selectCardImage.isHidden = false
                selectedCardCvv = cell.cardCvvNumber.text!
                self.selectedCardId = self.cardListArray[sender.tag].cardId
            } else {
                cell.selectCardImage.isHidden = true
                cell.cardCvvNumber.text = ""
                selectedCardCvv = ""
                self.selectedCardId = 0
                cardListCollection.reloadItems(at: [index])
            }
        }
    }
}
// MARK: - Private Method
extension CSPayBySavedCardViewController {
    /// Bind Data To collection View
    func bindData() {
        cardListCollectionDataSources.delegate = self
        cardListCollectionDataSources.cardList = self.cardListArray
        cardListCollection.reloadData()
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
    /// Title label
    func setTitleToLabel() {
        if (videodetailContent != nil) {
            topViewHeight.constant = 0
            costLabel.isHidden = true
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
    func attributeTextProperty(amount: String,
                               duration: String, color: UIColor,
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
}
// MARK: - Collection View Delegate
extension CSPayBySavedCardViewController: CSCollectionViewDelegate {
    func collectionviewDelegate(_ collectionView: UICollectionView,
                                didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}
// MARK: - Api request Method
extension CSPayBySavedCardViewController {
    // Make Payment
    func makePayment() {
        let parameter: [String: String] = ["subscription_plan_id": String(self.subscriptionPlanId.planId),
                                           "payment_method_id": "1",
                                           "card_id": String(selectedCardId)]
        CSCardApiModel.makePaymentApi(
            parentView: self,
            parameters: parameter,
            completionHandler: { responce in
                self.payButton.isUserInteractionEnabled = true
                self.transactionView(responce.responce.transaction)
                LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: "1")
                LibraryAPI.sharedInstance.setUserDefaults(key: "planName",
                                                          value: self.subscriptionPlanId.planName)
                self.navigationController?.isNavigationBarHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.0, execute: {
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
                                    let videoDetail = controller as? CSVideoDetailViewController
                                    videoDetail?.callApi()
                                    self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                })
        })
    } }
// MARK: - Api request Method
extension CSPayBySavedCardViewController {
        // Make Payment
        func transactionPayment() {
            let parameter: [String: String] = ["slug": String(videodetailContent.videoDict.responseId),
                                               "price": String(videodetailContent.videoDict.price),]
            CSCardApiModel.transPaymentApi(
                parentView: self,
                parameters: parameter,
                completionHandler: { responce in
                    print(responce)
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
// MARK: - Textfield Delegate
extension CSPayBySavedCardViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSPayBySavedCardViewController.keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:
            #selector(CSPayBySavedCardViewController.keyboardWillHide(notification:)),
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
        saveCardScrollView.contentInset = contentInsets
        saveCardScrollView.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        saveCardScrollView.contentInset = UIEdgeInsets.zero
        saveCardScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    /// UnRegistering Notifications
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
