/*
 * CSParentNavigationControllerViewController.swift
 * This class as parent class for Navigation Controller
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit

class CSParentNavigationController: UINavigationController,
UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    // MARK: - UINavigationController Life Cycle
    override func viewDidLoad() {
        self.delegate = self
    }
    /// navigation controller delegate
    ///
    /// - Parameters:
    ///   - navigationController: navigation controller object
    ///   - viewController: viewcontroller object
    ///   - animated: animate bool
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController is HomePageViewController ||
            viewController is CSLiveViewController ||
            viewController is CSSlideMenuViewController ||
            viewController is CSCateoryViewController ||
            viewController is CSElasticSearchViewController ||
            viewController is CSVideoDetailViewController ||
            viewController is CSCateoryViewController ||
            viewController is CSAlertViewController ||
            viewController is CSHistoryViewController ||
            viewController is CSParentTabBarViewController ||
            viewController is CSNotificationViewController ||
            viewController is CSOfflineVideoViewController ||
            viewController is ViewController {
            viewController.navigationController?.isNavigationBarHidden = true
        } else {
            viewController.navigationController?.isNavigationBarHidden = false
            viewController.navigationController?.navigationBar.backgroundColor = UIColor.navigationBarColor
        }
    }
    /// To refersh navigation header color
    func refreshNavigationColor() {
        self.navigationBar.backgroundColor = UIColor.navigationBarColor
    }
}
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if LibraryAPI.sharedInstance.isDarkMode() {
            return topViewController?.preferredStatusBarStyle ?? .lightContent
        } else {
            return topViewController?.preferredStatusBarStyle ?? .default
        }
    }
    open override var prefersStatusBarHidden: Bool {
        if UIDevice.current.orientation.isLandscape {
            return true
        } else {
            return false
        }
    }
}
