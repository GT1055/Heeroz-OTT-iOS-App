/*
 * CSEndPointConstant.swift
 * This class all the endpoint of url and has the base url of application
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.2
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */ 
import UIKit
// Target End Points
#if Dev
let BASEURL = "https://dev70.contus.us:8443/products/P101_Contus_Vplay_Api/public/"
let SHAREURL = BASEURL
let REFERER = "https://dev70.contus.us:8443"
#elseif Qa
let BASEURL = "https://api.vplayed.qa.contus.us/"
let SHAREURL = "https://vplayed.qa.contus.us/"
let REFERER = "https://vplayed.qa.contus.us"
#elseif Rel
let BASEURL =  "https://demo.vplayed.com/"
let SHAREURL = BASEURL
let REFERER = "https://demo.vplayed.com"
#elseif Uat
let BASEURL =  "https://vplayed.uat.contus.us/"
let SHAREURL = BASEURL
let REFERER = "https://vplayed.uat.contus.us"
#elseif Local
//let BASEURL =  "https://vplayed-catrack-uat.contus.us/"
//let SHAREURL = BASEURL
//let REFERER = "https://vplayed-catrack-uat.contus.us/"

let BASEURL = "https://api.heeroz.tv/" // "http://eks.vplayed.com/" // https://demo.vplayed.com/
let SHAREURL = "https://heeroz.tv/"
let REFERER = "https://staging.heeroz.tv/"
#endif

// API Paths based on kubernetes split

// Users
// APIs which comes under users are
// Login, Registrations, Forgot/Change Password, Profile
let LOGINAPI = "users/api/v2/auth/login"
let LOGOUTAPI = "users/api/v2/auth/logout" // Need to Confirm
let REGISTERAPI = "users/api/v2/auth/register"
let CHANGEPASSWORD = "users/api/v2/auth/change"
let FORGOTPASSWORD = "users/api/v2/auth/forgotpassword"
let PROFILEINFO = "users/api/v2/profile"
let UPDATEPROFILEINFO = "users/api/v2/customerProfile"

// User actions
// APIs which comes under useractions are
// Favourite, Playlist, Comments, Reply, Like/Dislike
let FAVOURITEAPI = "useractions/api/v2/favourite"
let ADDCOMMENT = "useractions/api/v2/videoComments"
let COMMENTLISTING = "useractions/api/v2/getvideoComments"
let ADDREPLYCOMMENT = "useractions/api/v2/replyComments/"
let CREATEADDANDEDIT = "useractions/api/v2/create_playlist"
let PLAYLISTAPI = "useractions/api/v2/playlists"
let PLAYLISTVIDEO = "useractions/api/v2/create_playlist_videos"
let LIKEAPI = "useractions/api/v2/like"
let DISLIKEAPI = "useractions/api/v2/dislike"

// Search
// APIs which comes under search are
// Search
//let ELASTICSEARCH = "search/api/v2/search/videos"
let ELASTICSEARCH = "search/elastic/search"


// Payment
// APIs which comes under payment are
// Payment, Cards, Subscription, Transactions
let PURCHASELIST = "payments/api/v2/purchase_videos/records"
let MAKEPAYMENT = "payments/api/v2/subscription/add"
let CARDCREATED = "payments/api/v2/cards"
let SUBSCRIPTIONSLISTING = "payments/api/v2/subscriptions"
let REMOVESUBSCRIPTION = "payments/api/v2/unsubscription"
let TRANSACTIONLIST = "payments/api/v2/transactions/records"
let TRANSACTIONPAYMENT = "payments/api/v2/purchase_video/payment"

// Notification
// APIs which comes under notifications are
// Notifications along with its settings
let NOTIFICATION = "notifications/api/v2/notifications"
let NOTIFICAIONSINGLECLEAR = "notifications/api/v2/notification/remove/"
let NOTIFICAIONCLEARALL = "notifications/api/v2/notification/remove_all"
let NOTIFICATIONSINGLEREAD = "notifications/api/v2/notification/read/"
let NOTIFICATIONREADALL = "notifications/api/v2/notification/read_all"
let NOTIFICATIONSTATUS = "notifications/api/v2/notification/settings"

// Common
// APIs which comes under common are
// contact us
let SUBMITQUERIES = "common/api/v2/staticContent/contactus"

// Analytics
// APIs which comes under analytics are
// watch history
let WATCHHISTORY = "analytics/v2/watchvideo/"
let NEWWATCHHISTORY = "analytics/api/v2/videoanalytics"
let WATCHTIME = "analytics/api/v2/video_view_count"

// Media
// APIs which comes under medias are
// Home Page, Category, VideoDetail, Web Series/Seasons
let BANNARHOMEPAGE = "medias/api/v2/home_page_banner"
let HOMEAPI = "medias/api/v2/home_page"
let HOMEPAGEMORE = "medias/api/v2/home_page_more"
let HOMEPAGEMOREAPI = "medias/api/v2/home_more"
let RECENTANDTRENDINGVIDEO = "medias/api/v2/videosRelatedTrending"
let LIVEAPI = "medias/api/v2/livevideos"
let LIVEMOREAPI = "medias/api/v2/live_more_videos"
let VIDEODETAIL = "medias/api/v2/videos/"
let RELATEDVIDEODETAIL = "medias/api/v2/videos"
let RELEVANTVIDEOS = "medias/api/v2/relavant"
let CATEGORYLISTAPI = "medias/api/v2/category_list"
let CATEGORYBASEDVIDEOAPI = "medias/api/v2/home_category_videos"
let CATEGORYMOREVIDEOAPI = "medias/api/v2/more_category_videos"
let SEASONLIST = "medias/api/v2/season_videos/"
let REMOVEVIDEOFROMHISTSTORY = "medias/api/v2/clear_recent_view"
let VIEWCOUNT = "medias/api/v2/tvod_view_count"
let XRAYAPI = "medias/api/v2/video/cast/"
let DOWNLOADAPI = "medias/api/v2/open/"
let SLUGVIDEOID = "medias/api/v2/getVideoId/"

// Socket URL
let SOCKETURL = "wss://admin.vplayed.uat.contus.us/ws/"

// Deep Link Domain
let DEEPLINKDOMAIN = "heerozios.page.link"
let ANDROIDAPPBUNDLE = "com.heeroz"

// AES Key & Value
var AESKEYVALUE = "636f6d2e636f6e7475732e76706c61794f66666c696e65446f776e6c6f616473"
var AESIVVALUE = "636f6d2e636f6e7475732e76706c6179"

// Social Login Schemes
let GOOGLESCHEME = "com.googleusercontent.apps.357575316641-mor6thd7df6llcc3edk6n62u9qs0rjjh"
let FACEBOOKSCHEME = "fb418293639062071"
