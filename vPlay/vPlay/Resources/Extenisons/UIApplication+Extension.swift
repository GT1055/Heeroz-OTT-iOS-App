/*
 * UIApplication+Extension.swift
 * This class is used to create extension for rootViewController
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import AVFoundation
import GoogleCast
extension UIApplication {
    // "CSParentTabBarViewController"
    /// Set Root View Controller Based on is Login status
    class func setRootControllerBasedOnLogin() {
        UIApplication.shared.keyWindow?.rootViewController = UIApplication.setRootViewController()
    }
    /// Set Tab As Root View Controller
    class func setTabRootViewController() -> UINavigationController {
        let viewController = homeStoryBoard.instantiateViewController(withIdentifier: "HomePageViewController")
        let parentNavigationController = CSParentNavigationController(rootViewController: viewController)
        return parentNavigationController
    }
    /// Set Root View Controller
    class func setRootViewController() -> UINavigationController {
        let viewController = tabStoryBoard.instantiateViewController(withIdentifier:
            "CSParentTabBarViewController")
        let parentNavigationController = CSParentNavigationController(rootViewController: viewController)
        return parentNavigationController
    }
    /// Set Login To root View controller
    class func setLoginToRootViewController() -> UINavigationController {
        let viewController =
            mainStoryBoard.instantiateViewController(withIdentifier: "CSLoginViewController")
        let parentNavigationController = CSParentNavigationController(rootViewController: viewController)
        return parentNavigationController
    }
    /// Set Preference To root View controller
    class func setPrefernceToRootViewController() -> UINavigationController {
        let viewController =
            preferenceStoryBoard.instantiateViewController(withIdentifier: "CSMyPreferenceViewController")
        let parentNavigationController = CSParentNavigationController(rootViewController: viewController)
        return parentNavigationController
    }
    /// User login
    class func isUserLoginInApplication() -> Bool {
        if LibraryAPI.sharedInstance.getUserId().isEmpty {
            return false
        }
        return true
    }
    /// skip up back up in icloud
    func skipBackupiniCloud() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        for dir in paths {
            var urlToExclude = URL(fileURLWithPath: dir)
            do {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try urlToExclude.setResourceValues(resourceValues)
            } catch {
            }
        }
    }
    /// Set Navigation Based On Notification
    /// This method is used to Navigation Based on Notification that is Recived vai apns/fcm
    /// This method requries two input namely Notification Type and Notification id
    /// Based on Type the view is navigated
    class func setNavigationBasedOnNotification(_ notificaionPayLoad: [AnyHashable: Any]) {
        if let notificationData = notificaionPayLoad as? [String: Any] {
            let type = notificationData["notification_type"] as? String ?? ""
            if type == "reply_comment" || type == "video" {
                let videoId = notificationData["video_id"] as? String ?? "0"
                UIApplication.moveToVideoDetailPage(Int(videoId)!)
                return
            } else if type == "subscription" {
                UIApplication.moveToSubscribeDetailPage()
            }
        }
    }
    /// Increment Notification Count on recive the push from apns and alos update in view
    class func toIncrementNotificationCount() {
        var count: Int = LibraryAPI.sharedInstance.getNotificationCount()
        count += 1
        LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: String(count))
        let parent = LibraryAPI.sharedInstance.currentController
        parent.setNotificationCount()
    }
    /// Open the detail page of Video Detail Page on clicking deeplink url
    class func moveToVideoDetailPage(_ videoId: Int) {
        if let window = UIApplication.shared.keyWindow {
            var currentController = window.rootViewController
            if currentController is UITabBarController {
                currentController = (currentController as? UITabBarController)!
            }
            if currentController is UINavigationController {
                currentController = (currentController as? UINavigationController)!.visibleViewController
            }
            if currentController is CSParentViewController {
                let parent = currentController as? CSParentViewController
                parent?.setNotificationCount()
            }
            if currentController is CSVideoDetailViewController {
                let controller = currentController as? CSVideoDetailViewController
                controller?.videoId = videoId
                controller?.callApi()
                return
            } else {
                let controller = videoDetailStoryBoard.instantiateViewController(withIdentifier:
                    "CSVideoDetailViewController") as? CSVideoDetailViewController
                controller?.videoId = videoId
                currentController?.navigationController?.pushViewController(controller!, animated: true)
            }
        }
    }
    /// Open the Subscription Page
    class func moveToSubscribeDetailPage() {
        if let window = UIApplication.shared.keyWindow {
            var currentController = window.rootViewController
            if currentController is UINavigationController {
                currentController = (currentController as? UINavigationController)!.visibleViewController
            }
            if currentController is UITabBarController {
                currentController = (currentController as? UITabBarController)!
            }
            if currentController is CSParentViewController {
                let parent = currentController as? CSParentViewController
                parent?.setNotificationCount()
            }
            if currentController is CSSubscriptionViewController {
                let controller = currentController as? CSSubscriptionViewController
                controller?.callApi()
                return
            } else {
                let controller = subscriptionStoryBoard.instantiateViewController(withIdentifier:
                    "CSSubscriptionViewController") as? CSSubscriptionViewController
                controller?.controllerTitle = NSLocalizedString("Pricing", comment: "Menu")
                currentController?.navigationController?.pushViewController(controller!, animated: true)
            }
        }
    }
    /// Status Bar Color
    func statusBarColor() {
        if let statusbar = statusBarUIView {
            statusbar.backgroundColor = .navigationBarColor
        }
        UINavigationBar.appearance().barStyle = (LibraryAPI.sharedInstance.isDarkMode()) ? .black : .default
    }
    
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
        
    
    /// Set Audio Session
    func setAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback,
                                         mode: .default, options: [])
        } catch {
        }
    }
    // Language extension
    class func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}
extension UIViewController {
    // Offline View Controller Navigation
    func offlineVideoController(_ viewController: UIViewController) {
        let controller = downloadStoryBoard.instantiateViewController(withIdentifier:
            "CSOfflineViewController") as? CSOfflineViewController
        controller?.controllerTitle = NSLocalizedString("Offline Videos", comment: "Menu")
        controller?.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(controller!, animated: true)
    }
}
// MARK: - Working with default values
extension AppDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.gckExpandedMediaControlsTriggered,
                                                  object: nil)
    }
    func setupCastLogging() {
        let logFilter = GCKLoggerFilter()
        let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel",
                            "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
        logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
    }
    @objc func presentExpandedMediaControls() {
        // Segue directly to the ExpandedViewController.
        let navigationController: UINavigationController?
        if useCastContainerViewController {
            let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
            navigationController = (castContainerVC?.contentViewController as? UINavigationController)
        }
        // NOTE: Why aren't we just setting this to nil?
        if let appDelegate = appDelegate, appDelegate.isCastControlBarsEnabled == true {
            appDelegate.isCastControlBarsEnabled = false
        }
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    func populateRegistrationDomain() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        var appDefaults = [String: Any]()
        if let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
            loadDefaults(&appDefaults, fromSettingsPage: "Root", inSettingsBundleAt: settingsBundleURL)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: appDefaults)
        userDefaults.setValue(appVersion, forKey: kPrefAppVersion)
        userDefaults.setValue(kGCKFrameworkVersion, forKey: kPrefSDKVersion)
        userDefaults.synchronize()
    }
    func loadDefaults(_ appDefaults: inout [String: Any], fromSettingsPage plistName: String,
                      inSettingsBundleAt settingsBundleURL: URL) {
        let plistFileName = plistName.appending(".plist")
        let settingsDict = NSDictionary(contentsOf: settingsBundleURL.appendingPathComponent(plistFileName))
        if let prefSpecifierArray = settingsDict?["PreferenceSpecifiers"] as? [[AnyHashable: Any]] {
            for prefItem in prefSpecifierArray {
                let prefItemType = prefItem["Type"] as? String
                let prefItemKey = prefItem["Key"] as? String
                let prefItemDefaultValue = prefItem["DefaultValue"] as? String
                if prefItemType == "PSChildPaneSpecifier" {
                    if let prefItemFile = prefItem["File"]  as? String {
                        loadDefaults(&appDefaults, fromSettingsPage: prefItemFile, inSettingsBundleAt: settingsBundleURL)
                    }
                } else if let prefItemKey = prefItemKey, let prefItemDefaultValue = prefItemDefaultValue {
                    appDefaults[prefItemKey] = prefItemDefaultValue
                }
            }
        }
    }
    func applicationIDFromUserDefaults() -> String? {
        let userDefaults = UserDefaults.standard
        var prefApplicationID = userDefaults.string(forKey: kPrefReceiverAppID)
        if prefApplicationID == kPrefCustomReceiverSelectedValue {
            prefApplicationID = userDefaults.string(forKey: kPrefCustomReceiverAppID)
        }
        if let prefApplicationID = prefApplicationID {
            let appIdRegex = try? NSRegularExpression(pattern: "\\b[0-9A-F]{8}\\b", options: [])
            let rangeToCheck = NSRange(location: 0, length: (prefApplicationID.count))
            let numberOfMatches = appIdRegex?.numberOfMatches(in: prefApplicationID, options: [], range: rangeToCheck)
            if numberOfMatches == 0 {
                let message: String = "\"\(prefApplicationID)\" is not a valid application ID\n" +
                "Please fix the app settings (should be 8 hex digits, in CAPS)"
                showAlert(withTitle: "Invalid Receiver Application ID", message: message)
                return nil
            }
        } else {
            let message: String = "You don't seem to have an application ID.\n" +
            "Please fix the app settings."
            showAlert(withTitle: "Invalid Receiver Application ID", message: message)
            return nil
        }
        return prefApplicationID
    }
    @objc func syncWithUserDefaults() {
        let userDefaults = UserDefaults.standard
        // Forcing no logging from the SDK
        enableSDKLogging = true
        let mediaNotificationsEnabled = userDefaults.bool(forKey: kPrefEnableMediaNotifications)
        GCKLogger.sharedInstance().delegate?.logMessage?("Notifications on? \(mediaNotificationsEnabled)",
            fromFunction: #function)
        if firstUserDefaultsSync || (self.mediaNotificationsEnabled != mediaNotificationsEnabled) {
            self.mediaNotificationsEnabled = mediaNotificationsEnabled
            if useCastContainerViewController {
                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = mediaNotificationsEnabled
            }
        }
        firstUserDefaultsSync = false
    }
}
// MARK: - GCKLoggerDelegate
extension AppDelegate: GCKLoggerDelegate {
    func logMessage(_ message: String, fromFunction function: String) {
        if enableSDKLogging {
            // Send SDK's log messages directly to the console.
        }
    }
}
// MARK: - GCKSessionManagerListener
extension AppDelegate: GCKSessionManagerListener {
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        if error == nil {
            if (window?.rootViewController?.view) != nil {
                // Toast.displayMessage("Session ended", for: 3, in: view)
            }
        } else {
            let message = "Session ended unexpectedly:\n\(error?.localizedDescription ?? "")"
            showAlert(withTitle: "Session error", message: message)
        }
    }
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        let message = "Failed to start session:\n\(error.localizedDescription)"
        showAlert(withTitle: "Session error", message: message)
    }
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertView(title: title, message: message,
                                delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}
// MARK: - GCKUIImagePicker
extension AppDelegate: GCKUIImagePicker {
    func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
        let images = metadata.images
        guard !images().isEmpty else { print("No images available in media metadata."); return nil }
        if images().count > 1 && imageHints.imageType == .background {
            return images()[1] as? GCKImage
        } else {
            return images()[0] as? GCKImage
        }
    }
}
