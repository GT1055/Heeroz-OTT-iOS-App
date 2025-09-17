/*
 * CSSubscriptionCollectionCell.swift
 * This class is used to bind all the data to collection Cell
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import StoreKit

class CSSubscriptionCollectionCell: CSBaseCollectionViewCell {
    // Price Label Text
    @IBOutlet var priceLabel: UILabel!
    // Description Label Text
    @IBOutlet var planDescription: UILabel!
    // Plan Title Label Text
    @IBOutlet var planTitle: UILabel!
    // Plan Title Text
    @IBOutlet var planShortDescription: UILabel!
    // Subscribe Button
    @IBOutlet var subscriptionButton: UIButton!
    // Subscribe Image
    @IBOutlet var subscribedImage: UIImageView!
    // Back View
    @IBOutlet weak var backView: UIView!
    /// Bind Data To Subscriptio
    var countryCode = ["INR","USD","CAD","MXN","GBP","EUR","NZD","JPY","DKK","SEK","NOK","PLN","BRL","AUD","PKR","MYR","AED"]
    var countryCurrency = ["₹","$","CA$","Mex$","£","€","NZ$","¥","Kr.","kr","kr","zł","R$","A$","Rs","RM","د.إ"]
    
    func bindDataToSubscription(_ data: PlanList) {
        planTitle.text = data.planName.uppercased()
        let geocurrency: String = String(data.geoprice.currency)
        let indexes = countryCode.enumerated().filter {
            $0.element.contains(geocurrency)
            }.map{$0.offset}
        let index = indexes[0]
        let price: String = countryCurrency[index] + String(data.geoprice.amout.removeZerosFromEnd()) + "/ " + data.planType.lowercased()
        let attributedSubscribedString = NSMutableAttributedString(string: price)
        let range1 = (price as NSString).range(of: String(data.planAmount))
        attributedSubscribedString.addAttribute(NSAttributedString.Key.font, value: UIFont.priceFont(),
                                                range: range1)
        let range2 = (price as NSString).range(of: String(data.planType.lowercased()))
        attributedSubscribedString.addAttribute(NSAttributedString.Key.font, value: UIFont.priceRegularFont(),
                                                range: range2)
        priceLabel.attributedText = attributedSubscribedString
        priceLabel.textColor = UIColor.invertColor(true)
        planDescription.text = NSLocalizedString("Stream on your favourite devices", comment: "Subscribe")
        planDescription.textColor = UIColor.contentColor()
        planShortDescription.text = NSLocalizedString("Unlimited films and TV programmes", comment: "Subscribe")
        planShortDescription.textColor = UIColor.contentColor()
    }
    func bindSubscription(_ data: PlanList, product: SKProduct) {
        planTitle.text = data.planName.uppercased()
        if !product.productIdentifier.isEmpty {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            var price = formatter.string(from: product.price)!
            if price.contains(".") {
                if price.components(separatedBy: ".").last! == "00" {
                    price = price.components(separatedBy: ".").first!
                }
            }
            let copyPrice = price.components(separatedBy: .whitespaces).last!
            price = price + "/" + data.planType.lowercased()
            let attributedSubscribedString = NSMutableAttributedString(string: price)
            let range1 = (price as NSString).range(of: copyPrice)
            attributedSubscribedString.addAttribute(NSAttributedString.Key.font, value: UIFont.priceFont(),
                                                    range: range1)
            let range2 = (price as NSString).range(of: String(data.planType.lowercased()))
            attributedSubscribedString.addAttribute(NSAttributedString.Key.font, value: UIFont.priceRegularFont(),
                                                    range: range2)
            priceLabel.attributedText = attributedSubscribedString
        } else {
            priceLabel.text = ""
        }
        priceLabel.textColor = UIColor.invertColor(true)
        planDescription.text = NSLocalizedString("Stream on your favourite devices", comment: "Subscribe")
        planDescription.textColor = UIColor.contentColor()
        planShortDescription.text = NSLocalizedString("Unlimited films and TV programmes", comment: "Subscribe")
        planShortDescription.textColor = UIColor.contentColor()
//        let geocurrency: String =  String(data.geoprice.currency)
//        let indexes = countryCode.enumerated().filter {
//            $0.element.contains(geocurrency)
//            }.map{$0.offset}
//        let index = indexes[0]
//        let price: String = countryCurrency[index] + String(data.geoprice.amout.removeZerosFromEnd()) + "/ " + data.planType.lowercased()
    }
    /// Show Subscribed Image
    func showSubscribedImage(_ isshow: Bool) {
        subscribedImage.isHidden = true
        if isshow {
            subscriptionButton.setTitle(NSLocalizedString("Subscribed", comment: "Subscribe"), for: .normal)
        } else {
            subscriptionButton.setTitle(NSLocalizedString("Subscribe Now", comment: "Subscribe"), for: .normal)
        }
        subscriptionButton.titleLabel?.lineBreakMode = .byWordWrapping
        subscriptionButton.titleLabel?.textAlignment = .center
    }
}
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
