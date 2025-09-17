/*
 * CSCustomNavigationView.swift
 * This is used as a Navigation View
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import GoogleCast
class CSCustomNavigationView: UIView {
    /// navigation User Profile base View
    @IBOutlet var userView: UIView!
    /// navigation Search view
    @IBOutlet var searchView: UIView!
    /// navigation Search Button
    @IBOutlet var searchButton: UIButton!
    /// navigation Cast Button
    @IBOutlet var castButton: GCKUICastButton!
    /// navigation Notification button
    @IBOutlet var notificationButton: CSCustomBadgeButton!
    /// navigation Notification view
    @IBOutlet var notificationView: UIView!
    /// navigation User Image
    @IBOutlet var userImage: UIImageView!
    /// logo Image
    @IBOutlet var headerLogoImage: UIImageView!
    /// Subscribe Button
    @IBOutlet weak var subscribeButton: UIButton!
    /// Did Move to Super View
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        // Use the layer shadow to draw a one pixel hairline under this view.
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        self.backgroundColor = UIColor.navigationBarColor
        // UINavigationBar's hairline is adaptive, its properties change with
        // the contents it overlies.  You may need to experiment with these
        // values to best match your content.
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOpacity = 0.50
        setModeBasedColor()
        showHideUserView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
    }
    /// To set color based on dark mode
    func setModeBasedColor() {
        let templateSearch = UIImage.localImage("search", template: true)
        let templateNotification = UIImage.localImage("Notification", template: true)
        searchButton.setImage(templateSearch, for: .normal)
        notificationButton.setImage(templateNotification, for: .normal)
        searchButton.tintColor = UIColor.iconColor()
        castButton.tintColor = UIColor.iconColor()
        notificationButton.tintColor = UIColor.iconColor()
        let imageName = (LibraryAPI.sharedInstance.isDarkMode()) ? "logo-dark" : "logo"
        headerLogoImage.image = UIImage(named: imageName)
    }
    // You can present the instructions on how to use Google Cast on
    // the first time the user uses you app
    @objc func castDeviceDidChange(_ notification: Notification) {
        if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
            castButton.superview?.isHidden = false
        } else {
            castButton.superview?.isHidden = true
        }
    }
    func showHideUserView() {
        notificationView.isHidden = LibraryAPI.sharedInstance.getUserId().isEmpty
        if userView != nil {
            let value = LibraryAPI.sharedInstance.getUserImageUrl().isEmpty ?
                "" : LibraryAPI.sharedInstance.getUserImageUrl()
            if LibraryAPI.sharedInstance.getUserId().isEmpty {
                userImage.image = UIImage(named: "navigUser")
                userImage.tintColor = UIColor.iconColor()
            } else {
                userImage.setProfileImageWithUrl(value)
            }
        }
        subscribeButton.isHidden = (LibraryAPI.sharedInstance.getUserId().isEmpty) ? false : (LibraryAPI.sharedInstance.isUserSubscibed()) ? true : false
        subscribeButton.setTitle(NSLocalizedString("SUBSCRIBE NOW", comment: ""), for: .normal)
    }
    /// Set Notification Count
    func showNotificationCount() {
        notificationButton.setBadgeCount(LibraryAPI.sharedInstance.getNotificationCount())
    }
}
