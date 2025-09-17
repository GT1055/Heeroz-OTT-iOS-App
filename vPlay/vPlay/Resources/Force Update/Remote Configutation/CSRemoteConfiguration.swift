/*
 * CSRemoteConfiguration.swift
 * Remote Configuration File Set up
 * @category forceUpdate
 * @package  com.contus.forceUpdate
 * @version  1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */
import UIKit
import FirebaseRemoteConfig
class CSRemoteConfiguration: NSObject {
    //This method is used to update the remote config for force upate
    class func configureRemoteUpdate() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(fromPlist: "remoteList")
        remoteConfig.activateFetched()
        #if DEBUG
            let expirationDuration: TimeInterval = 0
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        #else
            let expirationDuration: TimeInterval = 3600
        #endif
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { status, _ in
            print("[Config] Fetch completed with status:", status, "(\(status.rawValue))")
        }
    }
    /// Check App Version
    class func appVersionCheck(_ viewController: AnyObject) {
        let parentController = viewController as? UIViewController
        let remoteConfig = RemoteConfig.remoteConfig()
        if !remoteConfig[self.fetchRemoteRequriedKey()].boolValue {
            return
        }
        if CSUtilites.getAppVersion() < remoteConfig[self.fetchRemoteVersionKey()].stringValue! {
            let alert = UIAlertController(title: remoteConfig[self.fetchRemoteTitleKey()].stringValue,
                                          message: remoteConfig[self.fetchRemoteMessageKey()].stringValue,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:
            NSLocalizedString("Update", comment: "Update"), style: .default) { _ in
                CSUtilites.openStore(updateUrl: remoteConfig[self.fetchRemoteUpadeUrlKey()].stringValue!)
            })
            parentController?.present(alert, animated: true) {
            }
        }
    }
    /// data From Remote Plist
    /// - Returns: NSDictionary
    class func dataFromRemotePlist() -> NSDictionary {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "remoteList", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
            return myDict!
        }
        return myDict!
    }
    /// Fetch Remote Update Url Key
    /// - Returns: Strings
    class func fetchRemoteUpadeUrlKey() -> String {
        if self.dataFromRemotePlist()["update_Url"] != nil {
            return (self.dataFromRemotePlist()["update_Url"] as? String)!
        }
        return ""
    }
    ///  Fetch remote Title Key
    /// - Returns: Strings
    class func fetchRemoteTitleKey() -> String {
        if self.dataFromRemotePlist()["update_Title"] != nil {
            return (self.dataFromRemotePlist()["update_Title"] as? String)!
        }
        return ""
    }
    ///  Fetch remote Message Key
    /// - Returns: Strings
    class func fetchRemoteMessageKey() -> String {
        if self.dataFromRemotePlist()["update_Message"] != nil {
            return (self.dataFromRemotePlist()["update_Message"] as? String)!
        }
        return ""
    }
    ///  Fetch remote isRequried Key
    /// - Returns: Strings
    class func fetchRemoteRequriedKey() -> String {
        if self.dataFromRemotePlist()["update_IsRequried"] != nil {
            return (self.dataFromRemotePlist()["update_IsRequried"] as? String)!
        }
        return ""
    }
    ///  Fetch remote Version Key
    /// - Returns: Strings
    class func fetchRemoteVersionKey() -> String {
        if self.dataFromRemotePlist()["update_Version"] != nil {
            return (self.dataFromRemotePlist()["update_Version"] as? String)!
        }
        return ""
    }
    ///  Fetch remote Version Key
    /// - Returns: Strings
    class func fetchRemoteAppStoreUrlKey() -> String {
        if self.dataFromRemotePlist()["update_Version"] != nil {
            return (self.dataFromRemotePlist()["update_Version"] as? String)!
        }
        return ""
    }
}
