/*
 * CSUtilites.swift
 * Used to Take Application detials
 * @category forceUpdate
 * @package  com.contus.forceUpdate
 * @version  1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */
import UIKit
import Foundation
public class CSUtilites {
    public static func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    public static func openStore(updateUrl: String) {
        let url = URL(string: updateUrl)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
}
