/*
 * Extension UIViewController
 * This controller  is used to as extention class for all UIViewContoller
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import GoogleCast
import MessageUI
/// Navigation bar Button Creation And Implementation
extension UIViewController {
    /// create Back Bar Button
    /// - Returns: Bar Button for Back
    func setBackBarButton() -> UIBarButtonItem {
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "header"), for: .default)
        let btn1 = UIButton(type: .custom)
        btn1.setImage(#imageLiteral(resourceName: "Back-arrow"), for: .normal)
        btn1.tintColor = .navigationIconColor
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.backdismissAction(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        return item1
    }
    // Creates backbutton bar and dismiss presentviewcontroller
    func setDismissBarButton() -> UIBarButtonItem {
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "header"), for: .default)
        let btn1 = UIButton(type: .custom)
        btn1.setImage(#imageLiteral(resourceName: "Back-arrow"), for: .normal)
        btn1.tintColor = .navigationIconColor
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.onbackdismissAction(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        return item1
    }
    /// Create Space Setting Space
    /// - Returns: BarButtonItem
    func setSapcer() -> UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                     target: nil, action: nil)
        spacer.width = 0
        return spacer }
    /// add Login as Child View Controller
    func addLoginIfUserNotLogin(_ controller: CSParentViewController) {
        if UIApplication.isUserLoginInApplication() { return }
        let login = mainStoryBoard.instantiateViewController(withIdentifier:
            "CSLoginViewController") as? CSLoginViewController
        login?.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(login!, animated: true) }
    /// add Login as Child View Controller for Add playlist
    func addLoginCloseIfUserNotLogin(_ controller: CSParentViewController) {
        if UIApplication.isUserLoginInApplication() { return }
        let login = mainStoryBoard.instantiateViewController(withIdentifier:
            "CSLoginViewController") as? CSLoginViewController
        login?.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(login!, animated: true) }
    /// Remove Login popUp
    func removeLoginPopUp(_ controller: CSParentViewController) {
        for view in controller.view.subviews where view.tag == 1101 {
            view.removeFromSuperview()
            controller.callApi()
            changeTitleForNavigation(controller, title: controller.controllerTitle)
            return } }
    /// Controller title And Navigation title
    func changeTitleForNavigation(_ controller: CSParentViewController, title: String) {
        if let barButton = controller.navigationItem.leftBarButtonItems {
            for view in barButton where view.tag == 1 {
                let titlelabel = view.customView as? UILabel
                titlelabel?.text = controller.controllerTitle }
        } }
    /// Setting Navigation Header Label
    /// - Parameter Header: passed View
    /// - Returns: Label
    func setHeaderTitle(_ header: String) -> UIBarButtonItem {
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 0,
                                               width: UIScreen.main.bounds.size.width - 100.0,
                                               height: 40))
        titleLabel.text = header
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.tag = 1000
        titleLabel.textColor = UIColor.navigationTitleColor
        let leftItem = UIBarButtonItem(customView: titleLabel)
        leftItem.tag = 1
        return leftItem
    } }
// MARK: - Navigation Action For Bar Button
extension UIViewController {
    //Noifation code for Notification
    @objc func navigatePresenttoNotificationPage(sender: UIButton) {
        let controller = notificationStoryBoard.instantiateViewController(withIdentifier:
            "CSNotificationViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    /// Search Controller Navigation
    /// - Parameter sender: Self
    @objc func searchAction(sender: UIButton) {
        let controller = menuStoryBoard.instantiateViewController(withIdentifier:
            "CSSearchViewController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    /// backAction Controller Navigation
    /// - Parameter sender: Self
    @objc func backdismissAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    /// Dismiss action
    @objc func onbackdismissAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Share A Link
import Firebase
extension UIViewController {
       /// Deepl link Shared Link
        func deepLinkShare(_ data: CSSharedObject, sender: Any, isVideoDetail: Bool = false) {
            let button = sender as? UIButton
            button?.startAnimating()
            let videoLink = SHAREURL + "video/" + data.videoSlug + "?videoId=" + String(data.videoId)
            guard let link = URL(string: videoLink) else { return }
    //        let dynamicLinksDomain = DEEPLINKDOMAIN
            let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: "https://heerozios.page.link")
            linkBuilder?.iOSParameters = DynamicLinkIOSParameters.init(bundleID: Bundle.main.bundleIdentifier!)
            linkBuilder?.iOSParameters?.customScheme = CUSTOMURLSCHEME
            linkBuilder?.iOSParameters?.minimumAppVersion = "1.0"
            linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = false
            linkBuilder?.iOSParameters?.appStoreID = "1526786867"
            linkBuilder?.analyticsParameters = DynamicLinkGoogleAnalyticsParameters(source: "vplayed",
                                                                                   medium: "video",
                                                                                   campaign: "Share")
            linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            linkBuilder?.socialMetaTagParameters?.title = data.videoTitle
            linkBuilder?.socialMetaTagParameters?.descriptionText = data.videoShortDescription
            linkBuilder?.socialMetaTagParameters?.imageURL = data.thumbNailimage
            linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: ANDROIDAPPBUNDLE)
            linkBuilder?.options = DynamicLinkComponentsOptions()
            linkBuilder?.options?.pathLength = .short
            guard let longDynamicLink = linkBuilder?.url else { return }
            DynamicLinkComponents.shortenURL(longDynamicLink, options: nil) { url, _, error in
                button?.stopAnimating()
                guard let url = url, error == nil else {
                    LibraryAPI.sharedInstance.currentController.showToastMessageTop(message: error?.localizedDescription)
                    return
                }
                /// item to be shared
                let sharedbaseLink: String = "Watch \(data.videoTitle) on Heeroz"
                let shareItems: Array = ["\(sharedbaseLink) \n\(url.absoluteString)"]
                self.openSharePopUp(sender, sharedItems: shareItems, isVideoDetail: isVideoDetail)
            }
        }
    /// Share details
    /// - Parameter urlToShare: url to be shared string
    func shareVideo(urlToShare: String!, sender: Any) {
        /// checking url is empty
        guard (urlToShare) != nil else {
            return
        }
        let sharedbaseLink: String! =  "web Share =" + BASEURL + "video-detail/" + urlToShare
        let iOSShare = "iOS Share = vplayed://vplay.page.link/video" + "/" + urlToShare
        /// item to be shared
        let shareItems: Array = [sharedbaseLink!, iOSShare] as [Any]
        /// Open Shared Pop Up
        self.openSharePopUp(sender, sharedItems: shareItems)
    }
    /// Open Share Pop Up
    func openSharePopUp(_ sender: Any, sharedItems: [Any], isVideoDetail: Bool = false) {
        /// set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: sharedItems,
                                                              applicationActivities: nil)
        activityViewController.setValue("Check out this video at Heeroz", forKey: "Subject")
        // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceView = self.view
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        /// iPad Devices
        if UIDevice.current.userInterfaceIdiom == .pad {
            let sourceView = sender as? UIView
            activityViewController.popoverPresentationController?.sourceView = sourceView
            activityViewController.popoverPresentationController?.permittedArrowDirections = .any
            if !isVideoDetail {
                activityViewController.popoverPresentationController?.sourceRect =
                    CGRect(x: (sourceView?.frame.size.width)!/2, y: (sourceView?.frame.size.width)!/2,
                           width: 0, height: 0)
            } else {
                activityViewController.popoverPresentationController?.sourceRect =
                    CGRect(x: (sourceView?.frame.size.width ?? 0) / 2,
                           y: (sourceView?.frame.size.height ?? 0) / 2,
                           width: 0, height: 0)
            }
        }
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
// MARK: - Gradient extension
extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.init(red: 75/255.0, green: 112/255.0,
                                     blue: 173/255.0, alpha: 1.0).cgColor,
                        UIColor.init(red: 227/255.0, green: 151/255.0,
                                     blue: 117/255.0, alpha: 1.0).cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return layer
    }
}
// MARK: - SearchBar Extension
extension UISearchBar {
    var textColor: UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                return textField.textColor
            } else { return nil }
        }
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                textField.textColor = newValue } }
    }
}
import MDNotificationView
// MARK: - UIView Controller Extension
extension UIViewController {
    /// Show toast message position bottom
    /// - Parameter message: message to be shown
    func showSuccessToastMessage(message: String!) {
        self.successNotificationMessageTop(message: message)
    }
    /// Show toast message position Top
    /// - Parameter message: message to be shown
    func showToastMessageTop(message: String!) {
        self.notificationMessageTop(message: message)
    }
    /// notification Type error Message display
    /// - Parameter message: Message as String
    func notificationMessageTop(message: String!) {
        let view = CSCustomNotificationView()
        view.frame.size.height = 45.0
        view.textLabel.text = message
        view.textLabel.textColor = UIColor.white
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        let notificationView = MDNotificationView(view: view, position: .top)
        notificationView.backgroundColor = UIColor.themeColorButton()
        self.view.addSubview(notificationView)
        notificationView.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            notificationView.hide()
            notificationView.removeFromSuperview()
        }
    }
    /// notification Type error Message display
    /// - Parameter message: Message as String
    func successNotificationMessageTop(message: String!) {
        let view = CSCustomNotificationView()
        view.frame.size.height = 45.0
        view.textLabel.text = message
        view.textLabel.textColor = UIColor.white
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        let notificationView = MDNotificationView(view: view, position: .top)
        notificationView.backgroundColor = UIColor.themeColorButton()
        self.view.addSubview(notificationView)
        notificationView.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            notificationView.hide()
            notificationView.removeFromSuperview()
        }}
}
// MARK: - Check Page is need
extension Int {
    /// Chaeck Page is need
    func checkPageNeed() -> Bool {
        return (self > 1) ? false : true
    }
}
// MARK: - String Formator
extension Double {
    var shortStringRepresentation: String {
        if self == 0.0 { return "" }
        if self.isNaN { return "NaN" }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        let units = ["", "k", "M"]
        var interval = self
        var count = 0
        while count < units.count - 1 {
            if abs(interval) < 1000.0 { break }
            count += 1
            interval /= 1000.0
        }
        // + 2 to have one digit after the comma, + 1 to not have any.
        // Remove the * and the number of digits argument to display all the digits after the comma.
        return "\(String(format: "%0.*g", Int(log10(interval)) + 2, interval))\(units[count])"
    }
}
/// Refresh The Eniter View
extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        if self.isKind(of: HomePageViewController.self) {
            let home = (self as? HomePageViewController)!
            home.slideshow.gestureRecognizers?.forEach(home.slideshow.removeGestureRecognizer)
        } else if self.isKind(of: CSLiveViewController.self) {
            let live = (self as? CSLiveViewController)!
            live.slideshow.gestureRecognizers?.forEach(live.slideshow.removeGestureRecognizer)
        }
        view.removeFromSuperview(); view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}
/// Share Object Creation
class CSSharedObject {
    var videoId = String()
    var videoSlug = String()
    var thumbNailimage: URL!
    var videoTitle = String()
    var videoShortDescription = String()
    required init(videoId: String = String(), videoSlug: String, thumbNail: String,
                  videoTitle: String, videoDescription: String = String()) {
        self.videoId = String(videoId)
        self.videoSlug = videoSlug
        self.thumbNailimage = URL.init(string: thumbNail)
        self.videoTitle = videoTitle
        self.videoShortDescription = videoDescription
    }
}
extension UICollectionView {
    func startAnimating() {
        let view = UIView()
        view.frame = self.frame
        view.backgroundColor = .clear
        view.tag = 100001
        self.superview?.addSubview(view)
        let indicator = UIActivityIndicatorView()
        indicator.color = .convertHexStringToColor(THEMECOLOR)
        indicator.hidesWhenStopped = true
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        indicator.transform = transform
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    func stopAnimating() {
        if let indicator = self.superview?.viewWithTag(100001) {
            indicator.removeFromSuperview()
        }
    }
}
extension UIButton {
    func startAnimating() {
        let view = UIView()
        view.frame = self.frame
        view.backgroundColor = .clear
        view.tag = 100001
        self.superview?.addSubview(view)
        let indicator = UIActivityIndicatorView()
        indicator.color = .convertHexStringToColor(THEMECOLOR)
        indicator.hidesWhenStopped = true
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        indicator.transform = transform
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    func stopAnimating() {
        if let indicator = self.superview?.viewWithTag(100001) {
            indicator.removeFromSuperview()
        }
    }
}
// String Extension to Remove space and New Lines
extension String {
    var removingWhitespacesAndNewlines: String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: " ")
    }
}
