//
//  This class is used to bind all the data to Transaction Table Cell
//  category   vplay
//  package    com.contus.vplay
//  CSTransactionListTableViewCell.swift
//  vPlay
//
//  Created by user on 29/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SkeletonView
class CSTransactionListTableViewCell: UITableViewCell {
    // The Transaction Table View
    @IBOutlet var transactionTableIcon: UIView!
    // The Transaction Table View
    @IBOutlet var plantypeLabelConstant: NSLayoutConstraint!
    // The Transaction Table View
    @IBOutlet var transactionTableIconWidth: NSLayoutConstraint!
    // Plan type label
    @IBOutlet weak var subscriptionPlanType: UILabel!
    // Transaction Status Label
    @IBOutlet weak var transactionStatus: UILabel!
    // Transaction Time Label
    @IBOutlet weak var transactionTime: UILabel!
    // Transaction Amount Label
    @IBOutlet weak var transactionAmount: UILabel!
    // Transaction ID Label
    @IBOutlet weak var transactionID: UILabel!
    // First Letter
    @IBOutlet weak var subscriptionPlanFirstLetter: UILabel!
    // Back View
    @IBOutlet weak var backView: CSCustomView!
    // Separator View
    @IBOutlet weak var separatorView: UIView!
    // Bind Data
    var countryCode = ["INR","USD","CAD","MXN","GBP","EUR","NZD","JPY","DKK","SEK","NOK","PLN","BRL","AUD","PKR","MYR","AED"]
    var countryCurrency = ["₹","$","CA$","Mex$","£","€","NZ$","¥","Kr.","kr","kr","zł","R$","A$","Rs","RM","د.إ"]
    
    func bindData(_ data: TransactionDataArray) {
        let geocurrency: String =  String(data.currencytype)
               let indexes = countryCode.enumerated().filter {
                   $0.element.contains(geocurrency)
                   }.map{$0.offset}
               let index = indexes[0]

        subscriptionPlanType.text = data.planName.isEmpty ? data.videotransactionList.videoTitle : data.planName
        subscriptionPlanFirstLetter.text = data.planName.isEmpty ? data.videotransactionList.videoTitle.first?.description.uppercased() : data.planName.first?.description.uppercased()
        transactionTime.text = CSTimeAgoSinceDate.setDateAsMMMDDYYYY(data.transactionTime)
        if data.transactionStatus.uppercased() == "paid".uppercased() {
            transactionStatus.text = NSLocalizedString("Success", comment: "transcation")
            transactionStatus.textColor = UIColor.transcationColor()
        } else {
            transactionStatus.text = NSLocalizedString("Failed", comment: "transcation")
            transactionStatus.textColor = UIColor.red
        }
        transactionStatus.text = NSLocalizedString(data.transactionStatus, comment: "")
        subscriptionPlanFirstLetter.textColor = .white
        let array = String(data.subscription.geoprice.amout.removeZerosFromEnd())
        transactionAmount.text = countryCurrency[index] + array
        transactionTableIconWidth.constant = data.planName.isEmpty ? 0 : 35
        plantypeLabelConstant.constant = data.planName.isEmpty ? 0 : 10
    }
    /// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDarkModeNeeds()
        self.showSkelectionView()
    }
    /// To set default things for the dark mode
    func setDarkModeNeeds() {
        backView.backgroundColor = .transcationCellBackground
        separatorView.backgroundColor = .separatorColor
        subscriptionPlanType.textColor = UIColor.invertColor(true)
        transactionAmount.textColor = UIColor.invertColor(true)
        transactionTime.textColor = UIColor.invertColor(true)
    }
    /// Show Skelection View
    func showSkelectionView() {
        self.backView.showSkeletionView()
        /*
         subscriptionPlanType.showSkeletionView()
         transactionStatus.showSkeletionView()
         transactionAmount.showSkeletionView()
         transactionTime.showSkeletionView()
         subscriptionPlanFirstLetter.superview?.showSkeletionView()
         */
    }
    /// Hides Skeleton Animation
    func hideSkeletonAnimation() {
        self.backView.hideSkeleton()
        /*
         subscriptionPlanType.hideSkeleton()
         transactionStatus.hideSkeleton()
         transactionAmount.hideSkeleton()
         transactionTime.hideSkeleton()
         subscriptionPlanFirstLetter.superview?.hideSkeleton()
         */
    }
}
