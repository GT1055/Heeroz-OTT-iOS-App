/*
 * CSErrorHandleBlock
 * This class is used to handle Both Api request error And Responce Error
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSErrorHandleBlock: NSObject {
    /// Responce Error Handle Block if responce status is not equal to 200 then all error is lead to this block
    class func responceErrorHandle(_ statusCode: Int, description: String, parentView: AnyObject) {
        let controller = parentView as? CSParentViewController
        controller?.stopLoading()
        /// Logout Error
        if statusCode == 403 || statusCode == 401 || statusCode == 400 {
            controller?.showToastMessageTop(message: description)
            LibraryAPI.sharedInstance.setUserDefaults(key: "Name", value: "")
            LibraryAPI.sharedInstance.setUserDefaults(key: "imageUrl", value: "")
            LibraryAPI.sharedInstance.setUserDefaults(key: "Token", value: "")
            LibraryAPI.sharedInstance.setUserDefaults(key: "UserID", value: "")
            LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: "0")
            // CSDownloadManager.shared.clearAllDownload()
            if controller is CSFavoutritesViewController || controller is CSHistoryViewController ||
                controller is CSSavedPlaylistViewController || controller is CSTransactionListViewController ||
                controller is CSCardListViewController || controller is CSEditProfileViewController ||
                controller is CSNotificationViewController {
                controller?.navigationController?.popViewController(animated: false)
                return
            }
            controller?.callApi()
        } else if statusCode == 404 {
            controller?.addChildView(identifier: noVideoExist, storyBoard: alertStoryBoard)
        } else {
            controller?.showToastMessageTop(message: description)
        }
    }
    class func changeThemeOnLogin(_ parentView: AnyObject) {
        let controller = parentView as? CSParentViewController
        if let statusBar = UIApplication.shared.statusBarUIView {
            statusBar.backgroundColor = UIColor.navigationBarColor
        }
        controller?.setNeedsStatusBarAppearanceUpdate()
        if controller?.tabBarController is CSParentTabBarViewController {
            let tabcontroller = controller?.tabBarController as? CSParentTabBarViewController
            tabcontroller?.setTabBarColor()
        }
        controller?.reloadViewFromNib()
    }
    /// Request Error Handle Block if responce status is not equal to 200 then all error is lead to this block
    class func requestErrorHandle(_ statusCode: Int, description: String, parentView: AnyObject) {
        let controller = parentView as? CSParentViewController
        controller?.stopLoading()
        if controller! is HomePageViewController && LibraryAPI.sharedInstance.isUserSubscibed() {
            controller?.showToastMessageTop(message: description)
            controller!.offlineVideoController(controller!)
        }
        if statusCode == -1009 {
            controller?.showToastMessageTop(message: description)
            controller?.addChildView(identifier: noInternet,
                                     storyBoard: alertStoryBoard)
        } else if statusCode == 4 {
            
        } else {
            controller?.showToastMessageTop(message: description)
            controller?.addChildView(identifier: whoopsView,
                                     storyBoard: alertStoryBoard)
        }
    }
}
