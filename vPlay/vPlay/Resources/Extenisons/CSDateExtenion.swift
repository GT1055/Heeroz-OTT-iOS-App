//
//  CSDateExtenion.swift
//  vPlay
//  This class is for Tap Date Extension
//  Created by user on 10/04/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension Date {
    /// Returns a date of ten years back from now
    static func tenYearsBackFromNow() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -10
        if let maxDate = calendar.date(byAdding: components, to: currentDate) {
            return maxDate
        } else {
            return Date()
        }
    }
}
