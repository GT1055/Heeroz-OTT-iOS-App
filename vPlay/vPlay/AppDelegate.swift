/*
 * AppDelegate
 * @category   vplayed
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Vplayed Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Vplayed. All rights reserved.
 */
import UIKit
import CoreData
import FBSDKCoreKit
import ObjectMapper
import UserNotifications
import Firebase
import GoogleSignIn
import Fabric
import FirebaseMessaging
import GoogleCast
import IQKeyboardManagerSwift
import GoogleMobileAds

// Cast Parameters
let kPrefPreloadTime = "preload_time_sec"
let kPrefEnableAnalyticsLogging = "enable_analytics_logging"
let kPrefEnableSDKLogging = "enable_sdk_logging"
let kPrefAppVersion = "app_version"
let kPrefSDKVersion = "sdk_version"
let kPrefReceiverAppID = "receiver_app_id"
let kPrefCustomReceiverSelectedValue = "use_custom_receiver_app_id"
let kPrefCustomReceiverAppID = "custom_receiver_app_id"
let kPrefEnableMediaNotifications = "enable_media_notifications"
// Cast receiverID
let kApplicationID: String? = "6E8EA02E"
let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    //Declarations
    // An outlet for creating a window
    var window: UIWindow?
    // An outlet to handle the background session
    var backgroundSessionCompletionHandler: (() -> Void)?
    //Set Bool value for CastParameter
     var enableSDKLogging = true
     var mediaNotificationsEnabled = false
     var firstUserDefaultsSync = false
     var useCastContainerViewController = false
    // Minimediacontroller enabled and disabled actions
    var isCastControlBarsEnabled: Bool {
        get {
            if useCastContainerViewController {
                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                return castContainerVC!.miniMediaControlsItemEnabled
            } else {
                return true
            }
        }
        set(notificationsEnabled) {
            if useCastContainerViewController {
                var castContainerVC: GCKUICastContainerViewController?
                castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = notificationsEnabled
            }
        }
    }
    /// LIFE CYCLE OF Application
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        populateRegistrationDomain()
//        IQKeyboardManager.shared.enable = true
        // Don't try to go on without a valid application ID - SDK will fail an
        // assert and app will crash.
        guard let applicationID = applicationIDFromUserDefaults(), applicationID != "" else {
            return true
        }
        // We are forcing a custom container view controller, but the Cast Container
        // is also available
        useCastContainerViewController = false
        let options = GCKCastOptions(receiverApplicationID: applicationID)
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        window?.clipsToBounds = true
        setupCastLogging()
        CSLocalizer.doTheSwizzling()
        CSDownloadManager.shared.downloadTasks()
        /// Set Audio Session
        application.setAudioSession()
        // Fire Base
        configureFirebase()
        // Set badge number
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Register for Notifications
        self.registerfroNotifications(application: application)
        /// Set Social Login
        self.setUpSocialLogin(application, launchOptions: launchOptions)
        /// Call the function to Skip the Backup of icloud Which is saved  in Documents Directory
        application.skipBackupiniCloud()
        /// Status Bar Color Configuration
        application.statusBarColor()
        //Check Launch
        checkLaunchOptions(launchOptions, application: application)
        // if Minimediacontroller is enabled
        if useCastContainerViewController {
            let appStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationController = appStoryboard.instantiateViewController(withIdentifier: "MainNavigation")
                as? UINavigationController else { return false }
            let castContainerVC = GCKCastContext.sharedInstance().createCastContainerController(for: navigationController)
                as GCKUICastContainerViewController
            castContainerVC.miniMediaControlsItemEnabled = true
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = castContainerVC
            window?.makeKeyAndVisible()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(syncWithUserDefaults),
                                               name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentExpandedMediaControls),
                                               name: NSNotification.Name.gckExpandedMediaControlsTriggered, object: nil)
        firstUserDefaultsSync = true
        syncWithUserDefaults()
        UIApplication.shared.statusBarStyle = .lightContent
        GCKCastContext.sharedInstance().sessionManager.add(self)
        GCKCastContext.sharedInstance().imagePicker = self
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    /// Set up Social Login
    func setUpSocialLogin(_ application: UIApplication,
                          launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        /// Facebook login
        ApplicationDelegate.shared.application(
            application, didFinishLaunchingWithOptions: launchOptions)
        /// Google Login
        GIDSignIn.sharedInstance().delegate = self
    }
    /// Fire Base Configuration
    public func configureFirebase() {
        /// For Develope Use Below Code
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = CUSTOMURLSCHEME
        FirebaseApp.configure()
    }
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if LibraryAPI.sharedInstance.currentController is CSVideoDetailViewController ||
            LibraryAPI.sharedInstance.currentController is CSReplyCommentViewController ||
            LibraryAPI.sharedInstance.currentController is CSLiveViewController {
            if LibraryAPI.sharedInstance.currentController is CSVideoDetailViewController {
                let controller = LibraryAPI.sharedInstance.currentController as? CSVideoDetailViewController
                if controller?.playerView.isPlaying ?? false && !UIDevice.current.orientation.isPortrait {
                    return .all
                } else if !(controller?.adsViews.isHidden ?? false) && !UIDevice.current.orientation.isPortrait {
                    return .all
                } else {
                    return .all
                }
            }
            if LibraryAPI.sharedInstance.currentController is CSLiveViewController {
                let controller = LibraryAPI.sharedInstance.currentController as? CSLiveViewController
                if controller?.playerView.isPlaying ?? false &&
                    !UIDevice.current.orientation.isPortrait {
                    let bar = controller?.tabBarController?.tabBar
                    bar?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                    return .all
                } else {
                    let bar = controller?.tabBarController?.tabBar
                    bar?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    return .all
                }
            }
            return .portrait
        } else if LibraryAPI.sharedInstance.currentController is CSOfflineVideoViewController {
            let controller = LibraryAPI.sharedInstance.currentController as? CSOfflineVideoViewController
            if controller?.playerView.isPlaying ?? false {
                return .all
            } else {
                return .portrait
            }
        } else {
            return .portrait
        }
    }
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme! == GOOGLESCHEME {
            let result = GIDSignIn.sharedInstance()
                .handle(url)
            return result
        }
        if url.scheme! == FACEBOOKSCHEME {
            let result = ApplicationDelegate.shared
                .application(app,
                             open: url,
                             sourceApplication: (options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String),
                             annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            return result
        }
        return false
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
}
// MARK: - Google Sign In Delegate
extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if GIDSignIn.sharedInstance().presentingViewController is CSLoginViewController {
            guard let controller = GIDSignIn.sharedInstance().presentingViewController as? CSLoginViewController else { return }
            if error != nil {
                return
            }
            controller.googleLogin(user)
        } else {
            guard let controller = GIDSignIn.sharedInstance().presentingViewController as? CSSignupViewController else { return }
            if error != nil {
                return
            }
            controller.googleLogin(user)
        }
    }
}
// MARK: - Background Session
extension AppDelegate {
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
}
// MARK: - DeepLinking
extension AppDelegate {
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // In this sample, we just open an alert.
            handleDynamicLink(dynamicLink)
            return true
        }
        // [START_EXCLUDE silent]
        // Show the deep link that the app was called with.
        showDeepLinkAlertView(withMessage: "openURL:\n\(url)")
        // [END_EXCLUDE]
        let checkFB = ApplicationDelegate.shared.application(
            application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let checkGoogle = GIDSignIn.sharedInstance().handle(url)
        return checkGoogle || checkFB
    }
    // [END openurl]
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let handleLink = DynamicLinks.dynamicLinks().handleUniversalLink(
                incomingURL,
                completion: { (dynamicLink, error) in
                    if let dynamicLink = dynamicLink, dynamicLink.url != nil, error == nil {
                        let lastPath = dynamicLink.url?.query
                        let videoId = lastPath?.replacingOccurrences(of: "videoId=", with: "")
                        UIApplication.moveToVideoDetailPage(Int(videoId!)!)
                    } else {
                        // Check for errors
                    }
            })
            return handleLink
        }
        return false
    }
    // [END continueuseractivity]
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        let matchConfidence: String
        if dynamicLink.matchType == .weak {
            matchConfidence = "Weak"
        } else {
            matchConfidence = "Strong"
        }
        let message = "App URL: \(dynamicLink.url?.absoluteString ?? "")\n" +
        "Match Confidence: \(matchConfidence)\nMinimum App Version: \(dynamicLink.minimumAppVersion ?? "")"
        showDeepLinkAlertView(withMessage: message)
    }
    func showDeepLinkAlertView(withMessage message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Deep-link Data", message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
// MARK: - FCM intergration
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token :\(fcmToken)")
        if LibraryAPI.sharedInstance.getDeviceToken().isEmpty {
            let token = Messaging.messaging().fcmToken
            LibraryAPI.sharedInstance.setUserDefaults(key: "DeviceToken", value: "\(token ?? "")")
        }
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if LibraryAPI.sharedInstance.getDeviceToken().isEmpty {
            Messaging.messaging().apnsToken = deviceToken
            InstanceID.instanceID().instanceID {result, _ in
                if let result = result {
                    LibraryAPI.sharedInstance.setUserDefaults(key: "DeviceToken", value: "\(result.token)")
                }
            }
        }
    }
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    /// A method to enable notifications
    func registerfroNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.badge, .alert, .sound]) {( _, error) in
            if error == nil {
                Messaging.messaging().delegate = self
                UNUserNotificationCenter.current().delegate = self
                application.registerForRemoteNotifications()
            }
        }
    }
    //  check launch option and process Notification elements
    func checkLaunchOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?, application: UIApplication) {
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            let payLoad = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIApplication.setNavigationBasedOnNotification(payLoad!)
            }
        }
    }
}
extension AppDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        UIApplication.toIncrementNotificationCount()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.setNavigationBasedOnNotification(response.notification.request.content.userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
}
