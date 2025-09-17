/*
 * CSInternetBankingViewController.swift
 * This class  is used to create an internet banking screen
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSInternetBankingViewController: CSParentViewController {
    /// Selected Label
    @IBOutlet var showSelectedLabel: UILabel!
    /// Cost Label
    @IBOutlet var costLabel: UILabel!
    /// Plan Name
    var subscriptionPlanId = PlanList()
    /// Validation of Video page
    var isVideoPage = false
    // MARK: - UIView controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setTitleToLabel()
    }
}
// MARK: - Private Method
extension CSInternetBankingViewController {
    // it adds the notification bar.
    func setupNavigation() {
        // costLabel.superview?.backgroundColor = .navigationBarColor
        addGradientBackGround()
        addLeftBarButton()
    }
    /// Title label
    func setTitleToLabel() {
        let cost = "$" + String(subscriptionPlanId.planAmount) + "/"
        let duration = String(subscriptionPlanId.planType)
        let text = NSLocalizedString("Subscription for", comment: "Subscription") + " " + cost + duration
        attributeTextProperty(amount: cost, duration: duration, color: UIColor.themeColorButton(),
                              text: text)
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
}
// MARK: - Button Action
extension CSInternetBankingViewController {
    /// Selecte banking option
    @IBAction func selecteBankingOption(_ sender: UIButton) {
        CSOptionDropDown.bankListingDropdown(label: showSelectedLabel,
            completionHandler: { _ in })
    }
}
