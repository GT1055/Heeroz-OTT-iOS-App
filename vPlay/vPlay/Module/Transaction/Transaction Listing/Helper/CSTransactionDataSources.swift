//
//  CSTransactionDataSources.swift
//  These class acts as a Data source for Transaction Table
//  vPlay
//
//  Created by user on 29/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SkeletonView
class CSTransactionDataSources: NSObject, SkeletonTableViewDataSource, UITableViewDelegate {
    /// transaction Data Array
    var transactionList = [TransactionDataArray]()
    /// Delegate
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionList.count.countCheck()
    }
    /// table height set
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            CSTransactionListTableViewCell else { return UITableViewCell() }
        if !transactionList.count.checkDataPresent() { return cell }
        if indexPath.row == 0 {
            LibraryAPI.sharedInstance.setUserDefaults(key: "planStartDate", value: transactionList[indexPath.row].transactionTime)
            LibraryAPI.sharedInstance.setUserDefaults(key: "planDuration", value: transactionList[indexPath.row].subscription.planDuration)
        }
        cell.bindData(transactionList[indexPath.row])
        cell.hideSkeletonAnimation()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
