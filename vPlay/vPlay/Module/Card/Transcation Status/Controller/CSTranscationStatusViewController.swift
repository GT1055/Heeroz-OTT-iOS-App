//
//  CSTranscationStatusViewController.swift
//  vPlay
//
//  Created by user on 15/10/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CSTranscationStatusViewController: CSParentViewController {
    @IBOutlet var subscriptionType: UILabel!
    @IBOutlet var subscriptionView: UILabel!
    @IBOutlet var videoName: UILabel!
    @IBOutlet var transactionId: UILabel!
    @IBOutlet var paymentType: UILabel!
    @IBOutlet var transactionTime: UILabel!
    var details: CSTransaction!
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //videoName.textColor = UIColor.invertColor(true)
        callApi()
    }
    override func callApi() {
        bindData()
    }
}
// MARK: - Private Method
extension CSTranscationStatusViewController {
    /// Bind Data
    func bindData() {
        subscriptionType.text = details.planName
        if details.planName.isEmpty {
            subscriptionView.isHidden = true
            subscriptionType.isHidden = true
        }
        transactionId.text = details.transactionId
        paymentType.text = NSLocalizedString("Net Banking", comment: "Transcation")
        transactionTime.text = details.transactionTime
    }
}
