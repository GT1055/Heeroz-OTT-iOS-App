/*
 * CSHomePageDataModel.swift
 * This class is used as Model For Home Page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
class CSHomePageDataModel: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var message = String()
    var status = String()
    /// Download Responce
    var downloadResponc: CSDownloadResponce!
    /// Home Page Responce
    var responseRequired: CSHomeResponce!
    /// Home page Movie More Responce
    var homePageMovieMore: CSMoviePagenation!
    /// Favourite Movie
    var favouritePage: CSMoviePagenation!
    /// Notification Listing
    var notificationPage: CSMoviePagenation!
    /// Search Page Api Listing
    var searchPage: CSMoviePagenation!
    /// video Authenticate
    var videoKeyResponce: CSVideoKey!
    /// slug Video Id
    var slugVideoResponce: CSSlugVideoKey!
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        message <- map["message"]
        status <- map["status"]
        responseRequired <- map["response"]
        homePageMovieMore <- map["response"]
        favouritePage <- map["response"]
        searchPage <- map["response"]
        notificationPage <- map["response"]
        downloadResponc <- map["response"]
        videoKeyResponce <- map["response"]
        slugVideoResponce <- map["response"]
    }
}
class CSSlugVideoKey: Mappable {
    var id = Int()
    var slug = String()
    var title = String()
    var genre_name = String()
    var video_category_name = String()
    var is_subscribed = String()
    var parent_category_name = String()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        id <- map["id"]
        slug <- map["slug"]
        title <- map["title"]
        genre_name <- map["genre_name"]
        video_category_name <- map["video_category_name"]
        is_subscribed <- map["is_subscribed"]
        parent_category_name <- map["parent_category_name"]
    }
}
class CSVideoKey: Mappable {
    var key = String()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        key <- map["title"]
    }
}
class CSStatistics: Mappable {
    var favouritesCount = Int()
    var subscribedPlan = PlanList()
    var planDurationLeft = String()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        favouritesCount <- map["favourites_count"]
        subscribedPlan <- map["subscribed_plan"]
        planDurationLeft <- map["plan_duration_left"]
    }
}
/// Notification Settings
class NotificationSetting: Mappable {
    var newVideo = Int()
    var replyComment = Int()
    var autoPlay = Int()
    var isSubscribed = Int()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        newVideo <- map["new_video"]
        replyComment <- map["reply_comment"]
        autoPlay <- map["auto_play"]
        isSubscribed <- map["is_subscribed"]
    }
}
// -------------------------- Home Page Data Responce ------------------------------- //
class CSHomeResponce: Mappable {
    var statistics: CSStatistics!
    var notificationSetting: NotificationSetting!
    var notitificationCount = Int()
    //-----------------------Search Video---------------------------//
    var searchVideo: CSMoviePagenation!
    //----------------------Categroy List---------------------------//
    var categoryData: CSCategoryData!
    //----------------------Categroy Video--------------------------//
    var categoryVideo: CSMoviePagenation!
    //----------------------Category List---------------------------//
    var category: CSCategoryList!
    //----------------------Gener List------------------------------//
    var genre = [CSGenreList]()
    // ---------------------Play List-------------------------------//
    var playlist: CSMoviePagenation!
    // ------------------- Playlist Video --------------------------//
    var playlistVideo: CSMoviePagenation!
    // --------------- Category Main Video List ---------//
    var mainVideoList = [CSCategoryVideoList]()
    // --------------- Category Video List ---------//
    var categoryVideoList = [CSCategoryVideoList]()
    // -------------- Genre List -----------------//
    var generVideoList = [CSCategoryVideoList]()
    // --------------- More Category Video List ------- //
    var moreCategoryVideoList: CSCategoryVideoList!
    // -------------- Home Page Move List -----------------//
    var homePage = [CSMoviePagenation]()
    // -------------- Season Page listing ---------------- //
    var seasonVideo: CSMoviePagenation!
    // ---------------------Bannar Video List-------------------------------//
    var bannar: CSMoviePagenation!
    // ------------------- New Video --------------------------//
    var newVideos: CSMoviePagenation!
    /// Web series Or not
    var isWebSeries = Int()
    var totalmaincategory = Int()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        homePage <- map["home_content"]
        notificationSetting <- map["notification_setting"]
        notitificationCount <- map["notification_count"]
        searchVideo <- map["search_videos"]
        categoryData <- map["category_list"]
        categoryVideo <- map["videos"]
        category <- map["categories"]
        isWebSeries <- map["web_series"]
        genre <- map["genres"]
        playlist <- map["my_playlist"]
        playlistVideo <- map["playlist_videos"]
        mainVideoList <- map["main"]
        categoryVideoList <- map["category_videos"]
        generVideoList <- map["genre_videos"]
        moreCategoryVideoList <- map["more_category_videos"]
        seasonVideo <- map["season_list"]
        statistics <- map["statistics"]
        totalmaincategory <- map["total_main_category"]
        bannar <- map["banner"]
        newVideos <- map["new"]
    }
}
/// Category Video List
class CSCategoryVideoList: Mappable {
    var title = String()
    var name = String()
    var categroyId = Int()
    var slug = String()
    var videoList: CSMoviePagenation!
    var categoryBanner = [CSBannerData]()
    var childcategorybanner = [CSBannerData]()
    var categorypageactive = Int()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        categroyId <- map["id"]
        title <- map["title"]
        name <- map["name"]
        slug <- map["type"]
        categorypageactive <- map["category_page_active"]
        videoList <- map["video_list"]
        categoryBanner <- map["banner_category"]
        childcategorybanner <- map["child_category_banner"]
    }
}
// Category Data
class CSCategoryData: Mappable {
    var currentPage = Int()
    var lastPage = Int()
    var categoryList = [CSCategoryList]()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        categoryList <- map["data"]
    }
}
//----------------------Category List---------------------//
class CSCategoryList: Mappable {
    var categoryTitle = String()
    var categoryOrder = Int()
    var categoryImage = String()
    var categoryId = Int()
    var categorySelected = Int()
    var isWebSeries = Int()
    //----------------- Child Category------------------------------//
    var childCategory = [CSCategoryList]()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        categoryTitle <- map["title"]
        categoryOrder <- map["category_order"]
        categoryImage <- map["image_url"]
        categoryId <- map["id"]
        categorySelected <- map["is_Selected"]
        childCategory <- map["child_category"]
        isWebSeries <- map["is_web_series"]
    }
}
//----------------------Gener List---------------------//
class CSGenreList: Mappable {
    var genreTitle = String()
    var genreImage = String()
    var genreId = Int()
    var genreSelected = Int()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        genreTitle <- map["name"]
        genreImage <- map["group_image"]
        genreId <- map["id"]
        genreSelected <- map["is_Selected"]
    }
}
// -------------------------------------- Pagenation --------------------------------------------------//
/// Movie Pagenation
class CSMoviePagenation: Mappable {
    var currentPage = Int()
    var lastPage = Int()
    var categoryName = String()
    var categorySlug = String()
    var categoryBanner = [CSBannerData]()
    var homepageactive = Int()
    var categorypageactive = Int()
    var childcategoryvideo:CSChildCategoryVideo!
    var type = String()
    var slug = String()
    // --------- key valueData are created by user ----------//
    var title = String()
    var categoryId = Int()
    /// --------------------------------- Movie Listing ---------------------------------------//
    var movieList = [CSMovieData]()
    /// --------------------------------- Notification Listing ---------------------------------------//
    var notificationList = [CSNotificationList]()
    /// --------------------------------- Play List ---------------------------------------//
    var playList = [CSPlayList]()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        categoryName <- map["category_name"]
        categorySlug <- map["category_slug"]
        categoryBanner <- map["category_banner"]
        homepageactive <- map["home_page_active"]
        categorypageactive <- map["category_page_active"]
        childcategoryvideo <- map["child_category_video"]
        type <- map["type"]
        slug <- map["slug"]
        title <- map["title"]
        categoryId <- map["title"]
        movieList <- map["data"]
        notificationList <- map["data"]
        playList <- map["data"]
    }
}
class CSChildCategoryVideo: Mappable {
    var categoryvideos = [CSChildCategoryVideos]()
    var genrevideos = [String]()
    var webseries = Int()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        categoryvideos <- map["category_videos"]
        genrevideos <- map["genre_videos"]
        webseries <- map["web_series"]
    }
}
class CSChildCategoryVideos: Mappable {
    var Id = String()
    var title = String()
    var slug = Int()
    var category_order = Int()
    var image_url = String()
    var is_web_series = String()
    var category_page_active = String()
    var home_child_category = String()
    var home_page_active = Int()
    var video_webseries_detail_id = Int()
    var child_category_order = Int()
    var videolist:CSMoviePagenation!
    var cat_list = String()
    var child_category_banner = [CSBannerData]()
    // MARK: - Delegate Methods
    required convenience init?(map: Map) {
        self.init()
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        Id <- map["id"]
        title <- map["title"]
        slug <- map["slug"]
        category_order <- map["category_order"]
        image_url <- map["image_url"]
        is_web_series <- map["is_web_series"]
        category_page_active <- map["category_page_active"]
        home_child_category <- map["home_child_category"]
        home_page_active <- map["home_page_active"]
        video_webseries_detail_id <- map["video_webseries_detail_id"]
        child_category_order <- map["child_category_order"]
        videolist <- map["video_list"]
        cat_list <- map["cat_list"]
        child_category_banner <- map["child_category_banner"]
    }
}

// ------------------ CSChildCategoryVideosList Data ----------------------- //
class CSChildCategoryVideosList: Mappable {
    var currentpage = String()
    var data = [CSChildCategoryVideosListData]()
    var firstpageurl = String()
    var from = String()
    var lastpage = String()
    var lastpageurl = String()
    var nextpageurl = String()
    var path = String()
    var perpage = String()
    var prevpageurl = String()
    var to = String()
    var total = String()
    // MARK: - Delegate Methods
    required convenience init?(map: Map) {
        self.init()
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        currentpage <- map["current_page"]
        data <- map["data"]
        firstpageurl <- map["first_page_url"]
        from <- map["from"]
        lastpage <- map["last_page"]
        lastpageurl <- map["last_page_url"]
        nextpageurl <- map["next_page_url"]
        path <- map["path"]
        perpage <- map["per_page"]
        prevpageurl <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }
}

class CSChildCategoryVideosListData: Mappable {
    var id = String()
    var title = [String]()
    var poster_image = String()
    var slug = String()
    var thumbnail_image = String()
    var is_favourite = String()
    var is_live = String()
    var view_count = String()
    var is_premium = String()
    var price = String()
    var trailer_hls_url = String()
    var genre_name = String()
    var video_category_name = String()
    var is_subscribed = String()
    var parent_category_name = String()
    // MARK: - Delegate Methods
    required convenience init?(map: Map) {
        self.init()
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        poster_image <- map["poster_image"]
        slug <- map["slug"]
        thumbnail_image <- map["thumbnail_image"]
        is_favourite <- map["is_favourite"]
        is_live <- map["is_live"]
        view_count <- map["view_count"]
        is_premium <- map["is_premium"]
        price <- map["price"]
        trailer_hls_url <- map["trailer_hls_url"]
        genre_name <- map["genre_name"]
        video_category_name <- map["video_category_name"]
        is_subscribed <- map["is_subscribed"]
        parent_category_name <- map["parent_category_name"]
    }
}
class CSHomeCategoryList: Mappable {
    var isLive = Int()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
    }
}
// --------------------------------------Movie Data--------------------------------------------//
/// Movie Data
class CSMovieData: Mappable {
    var movieId = Int()
    var isPremium = Int()
    var isDemo = Int()
    var isFavourite = Int()
    var slug = String()
    var title = String()
    var description = String()
    var thumbNailImage = String()
    var videoUrl = String()
    var posterImage = String()
    var bannerImage = String()
    var categories = [CSVideoCategory]()
    var videoType: CSVideoTypeCollection!
    var scheduleTime = String()
    var categoryName = String()
    var isLive = Int()
    var videoId = Int()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        movieId <- map["id"]
        isPremium <- map["is_premium"]
        isDemo <- map["is_subscribed"]
        isFavourite <- map["is_favourite"]
        slug <- map["slug"]
        title <- map["title"]
        categoryName <- map["video_category_name"]
        description <- map["description"]
        thumbNailImage <- map["thumbnail_image"]
        posterImage <- map["poster_image"]
        bannerImage <- map["banner_url"]
        videoId <- map["video_id"]
        videoUrl <- map["hls_playlist_url"]
        videoType <- map["collection"]
        categories <- map["categories"]
        scheduleTime <- map["scheduledStartTime"]
        isLive <- map["is_live"]
    }
}
//------------- Notification Mapper ----------------------//
class CSNotificationList: Mappable {
    var dataId = String()
    var content = String()
    var datacreated = String()
    var videoDataId = Int()
    var notificationType = String()
    var isRead = String()
    var video: CSMovieData!
    var customer: ResponseData!
    var videoNotificationDetail = [CSMovieData]()
    required init?(map: Map) {
    }
    // MARK: - Delegates Methods
    func mapping(map: Map) {
        dataId <- map["_id"]
        content <- map["content"]
        isRead <- map["read_at"]
        datacreated <- map["date"]
        video <- map["video"]
        notificationType <- map["type"]
        customer <- map["customer"]
        videoNotificationDetail <- map["video_notification"]
    }
}
//------------- Predefined data Model For Notification Fileter ----------------------//
class NotificationFilter: Mappable {
    var title = String()
    var slug = String()
    var isSelection = Int()
    // MARK: - Delegate Methods
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        // direct conversion
        title <- map["count"]
        slug <- map["is_subscribed"]
        isSelection <- map["count"]
    }
}
// ------------------ CSPlaylist Data ----------------------- //
class CSPlayList: Mappable {
    var playListId = String()
    var playListName = String()
    var playlistImage = String()
    var playlistVideos: CSMovieData!
    var isExist = Int()
    var videoCount = Int()
    // MARK: - Delegate Methods
    required convenience init?(map: Map) {
        self.init()
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        playListId <- map["_id"]
        playListName <- map["name"]
        playlistImage <- map["poster_image"]
        isExist <- map["is_added"]
        playlistVideos <- map["video"]
        videoCount <- map["video_count"]
    }
}
// ------------------ CSBanner Data ----------------------- //
class CSBannerData: Mappable {
    var bannerId = Int()
    var bannerImage = String()
    var bannerCategoryId = Int()
    var bannerCategoryTitle = String()
    var bannerVideoUrl = String()
    var bannerUrl = String()
    var bannerPosterImage = String()
    // MARK: - Delegate Methods
    required convenience init?(map: Map) {
        self.init()
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        bannerId <- map["id"]
        bannerImage <- map["banner_image"]
        bannerCategoryId <- map["category_id"]
        bannerCategoryTitle <- map["category_title"]
        bannerVideoUrl <- map["video_url"]
        bannerUrl <- map["banner_url"]
        bannerPosterImage <- map["poster_image"]
    }
}
