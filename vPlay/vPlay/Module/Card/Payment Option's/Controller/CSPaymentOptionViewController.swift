/*
 * CSPaymentOptionViewController.swift
 * This class  is used to Show the payment Option
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit

class CSPaymentOptionViewController: CSParentViewController {
    /// UPPER VIEW Height
    @IBOutlet var upperViewHeight: NSLayoutConstraint!
    /// count VIEW Height
    @IBOutlet var countViewHeight: NSLayoutConstraint!
    /// count VIEW
    @IBOutlet var countView: UIView!
    /// UPPER VIEW
    @IBOutlet var upperView: UIView!
    /// UPPER VIEW Height
    @IBOutlet var costViewHeight: NSLayoutConstraint!
    ///  imageview
    @IBOutlet weak var contentImageview: UIImageView!
    ///  imageview
    @IBOutlet weak var viewIconOutlet: UIImageView!
    ///  head label
    @IBOutlet weak var headLabel: UILabel!
    ///  content label
    @IBOutlet weak var contentLabel: UILabel!
    ///  View count label
    @IBOutlet weak var viewcountLabel: UILabel!
    ///  amount label
    @IBOutlet weak var amountLabel: UILabel!
    /// Top View
    @IBOutlet weak var topView: UIView!
    /// info Label
    @IBOutlet weak var infoLabel: UILabel!
    /// Cost Label
    @IBOutlet var costLabel: UILabel!
    /// Saved Card IbOutlet
    @IBOutlet var savedCard: UIView!
    /// Payment stack
    @IBOutlet weak var paymentStack: UIStackView!
    /// video data
    var videodetailContent : VideoResponse!
    /// Card Listing Array
    var cardListArray = [CSCardList]()
    /// Plan Name
    var subscriptionPlanId = PlanList()
    /// Validation of Video page
    var isVideoPage = false
    // MARK: - UIViewController Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setDarkModeNeeds()
        setTitleToLabel()
        callApi()
    }
    override func callApi() {
        if (videodetailContent != nil) {
            viewcountLabel.text = "YOU CAN WATCH THIS VIDEO \(String(videodetailContent.videoDict.globalViewCount)) TIMES"
            setData(videodetailContent)
            costViewHeight.constant = 0
        } else {
            countView.isHidden = true
            upperView.isHidden = true
            countViewHeight.constant = 0
            upperViewHeight.constant = 0 }
         carListing()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CSPayAsYouGoViewController {
            let controller = segue.destination as? CSPayAsYouGoViewController
            controller?.subscriptionPlanId = subscriptionPlanId
            controller?.videodetailContent = videodetailContent
            controller?.controllerTitle = NSLocalizedString("Credit or Debit Card", comment: "cards")
            controller?.isVideoPage = isVideoPage
        } else if  segue.destination is CSPayBySavedCardViewController {
            let controller = segue.destination as? CSPayBySavedCardViewController
            controller?.subscriptionPlanId = subscriptionPlanId
            controller?.videodetailContent = videodetailContent
            controller?.controllerTitle = NSLocalizedString("Saved Cards", comment: "cards")
            controller?.isVideoPage = isVideoPage
            controller?.cardListArray = cardListArray
        } else if  segue.destination is CSInternetBankingViewController {
            let controller = segue.destination as? CSInternetBankingViewController
            controller?.subscriptionPlanId = subscriptionPlanId
            controller?.controllerTitle = NSLocalizedString("Net Banking", comment: "cards")
            controller?.isVideoPage = isVideoPage
        }
    }
    /// set content image
    func setData(_ videoContent: VideoResponse) {
        headLabel.text = videoContent.videoDict.responseTitle
        contentLabel.text = videoContent.videoDict.responseDescription
        contentImageview.setImageWithUrl(videoContent.videoDict.responceThumbnailImage)
        if contentImageview.image == nil {
            contentImageview.backgroundColor = UIColor.thumbnailDefaultColor
        }
        let array = String(videoContent.videoDict.price).components(separatedBy: ".")
        if Int(array[1]) == 0 || Int(array[1]) == 00 {
            amountLabel.text = "$" + array[0]
        } else {
            amountLabel.text = "$" + String(videoContent.videoDict.price)
        }
    }
    /// To set dark mode needs
    func setDarkModeNeeds() {
        upperView.backgroundColor = .navigationBarColor
        viewIconOutlet.tintColor = ContactUsLightMode.icon
        viewcountLabel.textColor = UIColor.black
        headLabel.textColor = UIColor.invertColor(true)
        contentLabel.textColor = UIColor.invertColor(true)
        infoLabel.textColor = UIColor.contentColor()
        costLabel.textColor = UIColor.invertColor(true)
        countView.backgroundColor = .backgroundViewColor
        for subView in paymentStack.subviews where subView.tag == 200 {
            subView.backgroundColor = (LibraryAPI.sharedInstance.isDarkMode()) ? UIColor.navigationColor() : UIColor.invertColor(false)
            for current in subView.subviews where current.tag == 100 {
                let currentLabel = (current as? UILabel)!
                currentLabel.textColor = UIColor.invertColor(true)
            }
        }
    }
}
// MARK: - Private
extension CSPaymentOptionViewController {
    /// Title label
    func setTitleToLabel() {
        let cost = "$" + String(subscriptionPlanId.planAmount) + "/"
        let duration = String(subscriptionPlanId.planType)
        let text = NSLocalizedString("Subscription for", comment: "Subscription") + " " + cost + duration
        //costLabel.text = "$" + String(subscriptionPlanId.planAmount)
        attributeTextProperty(amount: cost, duration: duration, color: UIColor.themeColorButton(),
                              text: text)
    }
    /// Attribute Text Color
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
    /// Card is Exit and show the Saved Card section
    func checkCardIsExits() {
        if self.cardListArray.count < 1 {
            savedCard.isHidden = true
        } else {
            savedCard.isHidden = false
        }
    }
    // It adds the notification bar.
    func setupNavigation() {
        addGradientBackGround()
        addLeftBarButton()
    }
}
// MARK: - Api request
extension CSPaymentOptionViewController {
    /// Card Listing View controller
    func carListing() {
        CSCardApiModel.fetchCardApi(
            parentView: self,
            parameters: nil,
            completionHandler: { (response) in
                self.cardListArray = response.responce.cardListArray
                self.checkCardIsExits()
        })
    }
}
