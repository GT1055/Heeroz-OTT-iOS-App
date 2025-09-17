/*
 * CSCustomBadgeButton.swift
 * This class is for creation of Badge Count button in Notification
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
class CSCustomBadgeButton: UIButton {
    // Label Creation
    var badgeLabel: UILabel!
    // MARK: - UILife Cycle of a Button
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBadgeLabel()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBadgeLabel()
    }
    override func didMoveToSuperview() {
        if LibraryAPI.sharedInstance.currentController is CSNotificationViewController {
            LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: "0")
        }
        setBadgeCount(LibraryAPI.sharedInstance.getNotificationCount())
    }
    // MARK: - Private Methods
    /// Add bagge To Button
    func addBadgeLabel() {
        self.frame.size = CGSize(width: 30, height: 30)
        for view in self.subviews where view.tag == 101 {
            view.removeFromSuperview()
        }
        badgeLabel = UILabel(frame: CGRect(x: self.bounds.width - 12,
                                           y: 5,
                                           width: 18, height: 18))
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.layer.masksToBounds = true
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = .themeColorButton()
        badgeLabel.tag = 101
        self.addSubview(badgeLabel)
    }
    /// Change Badge Count
    func setBadgeCount(_ count: Int) {
        if count > 99 {
            badgeLabel.font = UIFont.systemFont(ofSize: 7)
            badgeLabel.text = "99+"
            badgeLabel.isHidden = false
        } else if count > 9 {
            badgeLabel.font = UIFont.systemFont(ofSize: 8)
            badgeLabel.text = "9+"
            badgeLabel.isHidden = false
        } else if count > 0 {
            badgeLabel.font = UIFont.systemFont(ofSize: 8)
            badgeLabel.text = String(count)
            badgeLabel.isHidden = false
        } else {
            badgeLabel.text = "0"
            badgeLabel.isHidden = true
        }
    }
}
