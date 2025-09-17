//
//  CSTransactionDetailViewController.swift
//  vPlay
//
//  Created by user on 18/10/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
class CSTransactionDetailViewController: CSParentViewController {
    @IBOutlet var subscriptionType: UILabel!
    @IBOutlet var subscriptionLabelType: UILabel!
    @IBOutlet var transactionId: UILabel!
    @IBOutlet var paymentType: UILabel!
    @IBOutlet var videoName: UILabel!
    @IBOutlet var videoNamelabel: UILabel!
    @IBOutlet var videoNameView: UIView!
    @IBOutlet var transactionTime: UILabel!
    @IBOutlet weak var backView: CSCustomView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timeInfoLabel: UILabel!
    @IBOutlet weak var idInfoLabel: UILabel!
    var details: TransactionDataArray!
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkModeNeeds()
        callApi()
    }
    override func callApi() {
        bindData()
    }
    /// To set dark mode needs
    func setDarkModeNeeds() {
        if LibraryAPI.sharedInstance.isDarkMode() {
            backView.backgroundColor = UIColor.navigationColor()
            infoLabel.textColor = UIColor.invertColor(true)
            idInfoLabel.textColor = UIColor.invertColor(true)
            timeInfoLabel.textColor = UIColor.invertColor(true)
            transactionTime.textColor = UIColor.invertColor(true)
            transactionId.textColor = UIColor.invertColor(true)
            videoName.textColor = UIColor.invertColor(true)
            videoNamelabel.textColor = UIColor.invertColor(true)
        }
    }
}
// MARK: - Button Typr
extension CSTransactionDetailViewController {
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Private Method
extension CSTransactionDetailViewController {
    /// Bind Data
    func bindData() {
        if (details.videotransactionList != nil) {
            videoName.text = details.videotransactionList.videoTitle
            videoNameView.isHidden = false
            subscriptionType.isHidden = true
        } else {
            videoNameView.isHidden = true
        }
        subscriptionType.text = NSLocalizedString("Plan type:", comment: "type") + " " + details.planName
        transactionId.text = details.razorTransactionID
        paymentType.text = NSLocalizedString("Net Banking", comment: "type")
        transactionTime.text = CSTimeAgoSinceDate.setDateAsMMMDDYYYY(details.transactionTime)
    }
}
