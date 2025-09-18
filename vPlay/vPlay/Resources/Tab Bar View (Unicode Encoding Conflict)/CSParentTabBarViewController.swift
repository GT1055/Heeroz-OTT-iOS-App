/*
 * CSParentTabBarViewController.swift
 * This is used as a parent Class for Tab Bar Controller
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
class CSParentTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    // MARK: - UITabBarController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
             UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        } else {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        }
        setTabBarColor()
        self.delegate = self
    }
    /// Set Tab bar color
    func setTabBarColor() {
        tabBar.isTranslucent = false
        self.tabBar.barTintColor = .bottomBar
        tabBar.unselectedItemTintColor = .tabBarUnselect
    }
    /// Set Language
    func setTabBarItemLangauges() {
        let lang = ["Home", "Categories", "Live", "Menu"]
        for index in 0..<self.tabBar.items!.count {
            self.tabBar.items![index].title = NSLocalizedString(lang[index], comment: "Tabar Item")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
