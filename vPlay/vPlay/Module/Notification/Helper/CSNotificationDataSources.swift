/*
 * CSNotificationDataSources.swift
 * This class as a data source for Notification Table view in Notification Controller
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSNotificationDataSources: NSObject, UITableViewDelegate, UITableViewDataSource {
    // Notification List
    var notificationList = [CSNotificationList]()
    /// Delegate
    weak var delegate: CSTableViewDelegate?
    /// MARK:- Table view Delegate functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    /// table height set
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
            NotificationTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor.backgroundColor()
        cell.setDarkModeNeeds()
        cell.bindDataToNotification(notificationList[indexPath.row])
        cell.openOptionButton.tag = indexPath.row
        cell.openOptionButton.superview?.tag = tableView.tag
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableviewDelegate(tableView, didSelectRowAt: indexPath)
    }
}
