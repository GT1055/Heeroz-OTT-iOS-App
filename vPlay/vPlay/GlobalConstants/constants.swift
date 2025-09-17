/*
 * Global Constants
 * This Controller is used to declare all Constant Varibales and
 * data which are constant And run time constant also add
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import UIKit

#if DEBUG
func println(object: Any) {}
func print(object: Any) {}
#endif

let SUCCESSCODE = 200
var NEXTLIVETIME = ""

// Blank Image & Poster
let BLANKIMAGEURL = "https://d2rq7c4c4iu0a6.cloudfront.net/common/vod-placeholder.png"
let BLANKPSTERIMAGEURL = "https://d2rq7c4c4iu0a6.cloudfront.net/common/ios-vod-placeholder.png"

// add a contants which can be user
struct Constants {
    static let gradientColorBlue = "4b70ad"
    static let gradientColorBrown = "e39775"
    static let economyContentCell = "economycontent"
    static let homePageViewcontroller = "HomePageViewController"
    static let liveViewcontroller = "CSLiveViewController"
    static let browseViewcontroller = "CSBrowseVideoDetail"
    static let economyCustomCell = "EconomyCell"
    static let liveCellView = "Sections"
    static let videoDetailViewcontroller = "CSVideoDetailsViewController"
    static let preferenceStoryboard = UIStoryboard(name: "PreferenceStoryboard", bundle: nil)
}

// HOME
let homeStoryBoard = UIStoryboard.init(name: "Home", bundle: nil)
// HOME
let subscriptionStoryBoard = UIStoryboard.init(name: "Subscription", bundle: nil)
// PURCHASE
let purchaselistStoryBoard = UIStoryboard.init(name: "PurchaseList", bundle: nil)
// NEW HOME
let tabStoryBoard = UIStoryboard.init(name: "NewHome", bundle: nil)
// Alert
let alertStoryBoard = UIStoryboard.init(name: "Alert", bundle: nil)
// Main
let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
// Menu
let menuStoryBoard = UIStoryboard.init(name: "Menu", bundle: nil)
// Live
let liveStoryBoard = UIStoryboard.init(name: "live", bundle: nil)
// Video Detail
let videoDetailStoryBoard = UIStoryboard.init(name: "VideoDetail", bundle: nil)
// Side
let sideMenuStoryBoard = UIStoryboard.init(name: "SideMenuStoryBoard", bundle: nil)
// Browse And Exam
let browsAndExamStoryBoard = UIStoryboard.init(name: "BrowseAndExamsVideos", bundle: nil)
// Notification
let notificationStoryBoard = UIStoryboard.init(name: "Notification", bundle: nil)
// Preferncece
let preferenceStoryBoard = UIStoryboard.init(name: "PreferenceStoryboard", bundle: nil)
// Latest and Play list
let playListAndLatestStoryBoard = UIStoryboard.init(name: "PlayListandLatest", bundle: nil)
// Download
let downloadStoryBoard = UIStoryboard.init(name: "Download", bundle: nil)
// Profile
let profileStoryBoard = UIStoryboard.init(name: "Profile", bundle: nil)
// Card List Story Board
let cardStoryBoard = UIStoryboard.init(name: "CardPage", bundle: nil)
// Cast
let castStoryBoard = UIStoryboard.init(name: "Alert", bundle: nil)
// Stroy board Identifiers
let noDataIdentifier = "CSNoDataView"

let noInternet = "CSNoInternet"

let noVideoExist = "CSVideoNotAvailable"

let whoopsView = "CSWhoopsView"

// Side Menu Constant Array
let MENUDATA = [
    ["title": "Sign In", //0
        "storyBoard": mainStoryBoard,
        "identifier": "CSLoginViewController",
        "image": "sign-in"],
    ["title": "Sign Up", //1
        "storyBoard": mainStoryBoard,
        "identifier": "CSSignupViewController",
        "image": "sign-in"],
    ["title": "My Favourites", //2
        "storyBoard": menuStoryBoard,
        "identifier": "CSFavoutritesViewController",
        "image": "Favourite-Videos"],
    ["title": "My Playlist", //3
        "storyBoard": playListAndLatestStoryBoard,
        "identifier": "CSSavedPlaylistViewController",
        "image": "Saved-Playlist"],
    ["title": "Offline Videos", //4
        "storyBoard": downloadStoryBoard,
        "identifier": "CSOfflineViewController",
        "image": "Offline-Videos"],
    ["title": "Watch History", //5
        "storyBoard": videoDetailStoryBoard,
        "identifier": "CSHistoryViewController",
        "image": "History"],
    ["title": "Pricing", //6
        "storyBoard": subscriptionStoryBoard,
        "identifier": "CSSubscriptionViewController",
        "image": "pricing"],
    ["title": "My Transactions", //7
        "storyBoard": menuStoryBoard,
        "identifier": "CSTransactionListViewController",
        "image": "transaction"],
    ["title": "My Purchased Videos", //8
        "storyBoard": purchaselistStoryBoard,
        "identifier": "CSPurchaselistViewcontroller",
        "image": "purchased-videos"],
    ["title": "Saved Cards", //9
        "storyBoard": cardStoryBoard,
        "identifier": "CSCardListViewController",
        "image": "saved-card"],
    ["title": "Settings", //10
        "storyBoard": notificationStoryBoard,
        "identifier": "CSSettingsViewcontroller",
        "image": "Settings"],
    ["title": "Language", //11
        "storyBoard": notificationStoryBoard,
        "identifier": "CSSettingsViewcontroller",
        "image": "Language"],
    ["title": "Contact Us", //12
        "storyBoard": notificationStoryBoard,
        "identifier": "CSContactViewController",
        "image": "Contacts"],
    ["title": "Rate us on the App Store", //13
        "storyBoard": "",
        "identifier": "",
        "image": "rate-us"],
    ["title": "FAQ", //14
        "storyBoard": "",
        "identifier": "",
        "image": "FAQ"],
    ["title": "Sign out", //14
        "storyBoard": "",
        "identifier": "",
        "image": "Sign-Out"]
]
