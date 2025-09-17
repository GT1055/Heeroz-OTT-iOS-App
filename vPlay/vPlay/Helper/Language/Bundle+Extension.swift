//
//  Bundle+Extension.swift
//  vPlay
//
//  Created by user on 27/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
// MARK: - Bundle Extension
extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        var currentLanguage = CSLanguage.currentAppleLanguage()
        if currentLanguage.contains("en") {
            currentLanguage = "en"
        }
        var bundle = Bundle.main
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle.init(path: path)!
        } else {
            let basePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
            bundle = Bundle.init(path: basePath!)!
        }
        if let name = tableName, name == "CameraUI" {
            let values = NSLocalizedString(key, comment: name)
            return bundle.specialLocalizedStringForKey(key, value: values, table: tableName)
        }
        return bundle.specialLocalizedStringForKey(key, value: value, table: tableName)
    }
}
