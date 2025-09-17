//
//  CSPurchasevideoDatasource.swift
//  vPlay
//
//  Created by user on 10/07/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SkeletonView
class CSPurchasevideoDatasource: NSObject, SkeletonTableViewDataSource, UITableViewDelegate {
    /// Delegate
    weak var delegate: CSTableViewDelegate?
    var purchaseDetails = [PurchaseDetail]()
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseDetails.count
    }
    /// table height set
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            CSPurchasevideoTableViewCell else { return UITableViewCell() }
        cell.configureCell(with: purchaseDetails[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
