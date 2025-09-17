/*
 * CSTimeAgoSinceDate
 * This class  is used to display time
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import Foundation
extension String {
    /// Time Ago extension
    func timeAgoSinceDate(numericDates: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: self) else { return ""}
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else {
            return checkTimeSecond(components, numericDates: numericDates)
        }
    }
    func checkTimeSecond(_ components: DateComponents, numericDates: Bool = false) -> String {
        if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}
class CSTimeAgoSinceDate: NSObject {
    /// date convertor
    /// - Parameter date: date in string "yyyy-MM-dd HH:mm:ss"
    /// - Returns: "dd MMM"
    class func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let currentdate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM"///this is you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: currentdate!)
        return timeStamp
    }
    /// month date year format
    class func convertMonthDateYearFormate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        //        dateFormatter.calendar = Calendar(identifier: .iso8601)
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateFromString = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMM dd YYYY, h:mm a"
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: dateFromString)  // 19-08-2015 06:00 AM -0300"
        } else { return "" }
    }
    ///  notification time convertor
    /// - Parameter date: date string "yyyy-MM-dd HH:mm:ss"
    /// - Returns: "dd MMM YYYY, HH:MM a" string
    class func convertDateNotificationFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let currentdate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM YYYY, h:mm a"///this is you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: currentdate!)
        return timeStamp
    }
    /// Date Formator date as Input in String Show in Date month and Year
    class func setDateAsDDMMMYYYY(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateFromString = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: dateFromString)  // 19-08-2015 06:00 AM -0300"
        } else { return "" }
    }
    /// Date Formator date as Input in String Show in Date month and Year
    class func setVideoDateAsMMMDDYYYY(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateFromString = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: dateFromString)  // 19-08-2015 06:00 AM -0300"
        } else { return "" }
    }
    /// Date Formator date as Input in String Mont date and year with am and Pm
    class func setDateAsMMMDDYYYY(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
        //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateFromString = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: dateFromString)  // 19-08-2015 06:00 AM -0300"
        } else { return "" }
    }
}
/// MARK: - Date Extension
extension Date {
    /// Get current Month
    func getMonthName() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        return Int(strMonth)!
    }
    // Get current Year
    func getYearName() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY"
        let strMonth = dateFormatter.string(from: self)
        return Int(strMonth)!
    }
}
