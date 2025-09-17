/*
 * LibraryAPI
 * This class is used to as Shared instance class for hold all the data in loacl memory
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import SystemConfiguration
import Speech
import CoreData

class LibraryAPI: NSObject, UIAlertViewDelegate, UIApplicationDelegate {
    /// Current Shown Controller
    var currentController = CSParentViewController()
    /// Current Plan Name
    var currentPlanName = String()
    /// A variable to store the videoDetailcategoryid id
    var videoDetailcategoryid = String()
    //Userdefault to skip the LoginPage
    var userDefault = UserDefaults.standard
    /// viewControllerReference
    var isNotificationViewController = Bool()
    // Device Token
    var deviceToken: String! = ""
    /// Tutorial Screen
    var tutorialScene = UserDefaults.standard
    /// count of notification
    var count = 0
    /// state capture
    var isBackGround = Bool()
    /// side Notification
    var isSideNotification = Bool()
    // Notifcation sound enable
    var notificationSound: Bool = true
    // is offline Data
    var isOfflineVideo = Int()
    /// create a shared Instance
    class var sharedInstance: LibraryAPI {
        struct Singleton {
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }
    /// intial all view and arrays
    override init() {
        super.init()
    }
    /// This method is used to store the default value
    /// - Parameters: CSSharedData.SharedInstance
    ///   - key: key for user default
    ///   - value: value to store in user defaults
    func setUserDefaults(key: String, value: String) {
        userDefault.setValue(value, forKey: key)
        userDefault.synchronize()
    }
    /// This method is used to store the default value
    /// - Parameters: CSSharedData.SharedInstance
    ///   - key: key for user default
    ///   - value: value to store in user defaults
    func setUserBoolDefaults(key: String, value: Bool) {
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    /// is Social Login
    func isSocialLogin() -> Bool {
        return userDefault.bool(forKey: "SocialLogin")
    }
    /// Get Plan Name 
    func getPlanName() -> String {
        if let token = userDefault.value(forKey: "planName") as? String, !token.isEmpty {
            return token
        }
        return ""
    }
    func getBalanceDays() -> String {
        if let startDate = userDefault.value(forKey: "planStartDate") as? String, !startDate.isEmpty {
            if let planDuration = userDefault.value(forKey: "planDuration") as? String, !planDuration.isEmpty {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.locale = Locale(identifier: CSLanguage.currentAppleLanguage())
                guard let startingDate = dateFormatter.date(from: startDate) else { return "" }

                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: startingDate)
                guard let finalDate = calendar.date(from:components) else { return "" }
                
                guard let modifiedDate = Calendar.current.date(byAdding: .day, value: 365, to: finalDate) else { return "" }
                                
                let currentDate = Date()
                let diffInDays = Calendar.current.dateComponents([.day], from: currentDate, to: modifiedDate).day
                let myString = "\(diffInDays!)"
                let balanceDays = "\(myString) day's left"
                return balanceDays
            }
            return ""
        }
        return ""
    }
    /// Notification Status
    func isEnableNotification() -> Bool {
        return userDefault.bool(forKey: "Notificationstatus")
    }
    /// Get Notification Count
    func getNotificationCount() -> Int {
        if let count = userDefault.value(forKey: "notificationCount") as? String, !count.isEmpty {
            return Int(count)!
        }
        return 0
    }
    /// set Device Token
    func getDeviceToken() -> String {
        if let token = userDefault.value(forKey: "DeviceToken") as? String, !token.isEmpty {
            return token
        }
        return ""
    }
    /// is User Subscribed
    func isUserSubscibed() -> Bool {
        if let token = userDefault.value(forKey: "isSubscribed") as? String, !token.isEmpty, token == "1" {
            return true
        }
        return false
    }
    /// is Dark mode enabled
    func isDarkMode() -> Bool {
        return !userDefault.bool(forKey: "DarkMode")
    }
    /// Fetch Google client Id
    /// - Returns: Strings
    func googleClientId() -> String {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
            if myDict!["GoogleClientId"] != nil {
                return (myDict!["GoogleClientId"] as? String)!
            }
        }
        return ""
    }
    /// Get Apple Id
    func getAppleID() -> String {
        if let appleEmaiId = userDefault.value(forKey: "appleID") as? String, !appleEmaiId.isEmpty {
            return appleEmaiId
        }
        return ""
    }
    /// Get User Id
    func getUserId() -> String {
        if let userID = userDefault.value(forKey: "UserID") as? String, !userID.isEmpty {
            return userID
        }
        return ""
    }
    /// Get Access Token
    func getAccessToken() -> String {
        if let userToken = userDefault.value(forKey: "Token") as? String, !userToken.isEmpty {
            return "Bearer " + userToken
        }
        return ""
    }
    /// Get Image URL
    func getUserImageUrl() -> String {
        if let userImage = userDefault.value(forKey: "imageUrl") as? String, !userImage.isEmpty {
            return userImage
        }
        return ""
    }
    /// Get User Date of birth
    func getUserDob() -> String {
        if let userDob = userDefault.value(forKey: "dateOfBirth") as? String, !userDob.isEmpty {
            return userDob
        }
        return ""
    }
    /// Get Email Id
    func getUserEmailId() -> String {
        if let userEmail = userDefault.value(forKey: "EmailID") as? String, !userEmail.isEmpty {
            return userEmail
        }
        return ""
    }
    /// Get Phone Number
    func getPhoneNumber() -> String {
        if let phoneNumber = userDefault.value(forKey: "PhoneNumber") as? String, !phoneNumber.isEmpty {
            return phoneNumber
        }
        return ""
    }
    /// Get Name User
    func getUserName() -> String {
        if let userName = userDefault.value(forKey: "Name") as? String, !userName.isEmpty {
            return userName
        }
        return ""
    }
    /// Get Auto Play Status
    func getAutoPlayStatus() -> Bool {
        return userDefault.bool(forKey: "AutoPlayStatus")
    }
    /// Last Play Item
    func storeLastPlayItem(_ videoId: String, currentVideoDuration: String) {
        setUserDefaults(key: "videoId", value: videoId)
        setUserDefaults(key: "videoDuration", value: currentVideoDuration)
    }
    /// Video Id
    func getVideoId() -> Int {
        if let videoId = userDefault.value(forKey: "videoId") as? String, !videoId.isEmpty {
            return Int(videoId)!
        }
        return 0
    }
    /// Video Duration
    func getVideoDuration() -> Double {
        if let videoDuration = userDefault.value(forKey: "videoDuration") as? String, !videoDuration.isEmpty {
            return Double(videoDuration)!
        }
        return 0
    }
    /// Set Notification Count
    func setNotificationCount() {
           userDefault.setValue(Int(self.getNotificationCount() + 1), forKey: "notificationCount")
    }
    /// Media Info
    func getMedia(_ thumbnailImage: String, _ image: String, title: String, url: String) {
        image == "" ? setUserDefaults(key: "Image", value: BLANKIMAGEURL) : setUserDefaults(key: "Image", value: image)
        thumbnailImage == "" ? setUserDefaults(key: "Thumbnail", value: BLANKPSTERIMAGEURL) : setUserDefaults(key: "Thumbnail", value: thumbnailImage)
        setUserDefaults(key: "Title", value: title)
        setUserDefaults(key: "Url", value: url)
    }
}
