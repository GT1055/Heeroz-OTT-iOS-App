/*
 * CSVideoDetailMapper
 * This Controller is used to map the responce object into mapper
 * class which is used as model class for and video Detail
 * and list relate videos in video detail page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper

// MARK: - VideoDetail Mapper Class CSVideoDetailMapper
class CSVideoDetailMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var responseRequired: VideoResponse!
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        message <- map["messages"]
        status <- map["status"]
        responseRequired <- map["response"]
    }
}
// MARK: - Sub Mapper Class VideoResponse for Class CSVideoDetailMapper
class VideoResponse: CSVideoDetailMapper {
    var videoDict: VedioDetail!
    var relatedVedioArray: VedioDetailPage!
    var liveRelatedVedioArray: VedioDetailPage!
    var relevantVideoArray: VedioDetailPage!
    var commentPageData: CommentResponces!
    var commentListArray = [CommentsList]()
    var questionAndAnswer = [QAList]()
    var playListVideoRelatedDetail: VideoRelatedDetail!
    var season = [CSSeason]()
    var paymentInformation : PaymentInfo?
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        videoDict <- map["video_info"]
        relatedVedioArray <- map["related"]
        relevantVideoArray <- map["relavant"]
        commentListArray <- map["comments"]
        commentPageData <- map["comments"]
        season <- map["seasons"]
        questionAndAnswer <- map["questions"]
        playListVideoRelatedDetail <- map["video_playlist_details"]
        liveRelatedVedioArray <- map["live_related_videos"]
        paymentInformation <- map["payment_info"]
    }
}
class VedioDetailPage: Mappable {
    var currentPage = Int()
    var lastPage = Int()
    var total = Int()
    var data = [CSMovieData]()
    required init?(map: Map) {
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        total <- map["total"]
        data <- map["data"]
    }
}
class VideoRelatedDetail: Mappable {
    var vrdID = Int()
    var vrdName = String()
    var vrdDate = String()
    var vrdImage = String()
    var vrdFollowers = Int()
    var vrdIsFollowing = Int()
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        vrdID <- map["id"]
        vrdName <- map["name"]
        vrdDate <- map["created_at"]
        vrdImage <- map["playlist_image"]
        vrdFollowers <- map["followers"]
        vrdIsFollowing <- map["following"]
    }
}
// MARK: - Sub Mapper Class VedioDetail for Class VideoResponse
class VedioDetail: VideoResponse {
    var responseId = Int()
    var responseTitle = String()
    var responseSlug = String()
    var responseDescription = String()
    var responceThumbnailImage = String()
    var responceCreatedAt = String()
    var responceThumbnailPath = String()
    var responceTrailer = String()
    var responceSubscription = String()
    var responceCommentCount = Int()
    var responceIsFavorite = Int()
    var responceHLSPlaylistUrl = String()
    var responceTranscodedvideos = [Transcode]()
    var responceCategories = [Categories]()
    var responceVideoDuration = String()
    var responcePosterImage = String()
    var reponceDemoStatus = Int()
    var responceLikeCount = Int()
    var responceDislikeCount = Int()
    var responceIsDislike = Int()
    var responceIsLike = Int()
    var responcePublished = String()
    var videoType: CSVideoTypeCollection!
    var categories = [CSVideoCategory]()
    var responceViewsCount = Int()
    var responceAutoPlay = Int()
    var isPremium = Int()
    var isRestricted = Int()
    var starring = String()
    var startTimer = String()
    var selectedSeasonName = String()
    var categoryName = String()
    var generName = String()
    var selectedSeasonId = Int()
    var videoKey = String()
    var isLive = Int()
    var adsUrl = String()
    var price = Double()
    var subtitle: CSSubTitle!
    var globalViewCount = Int()
    var spriteImage = String()
    var ageRestriction = String()
    var newCategoryList = [String]()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        responseId <- map["id"]
        startTimer <- map["scheduledStartTime"]
        responseTitle <- map["title"]
        responseSlug <- map["slug"]
        responceIsDislike <- map["is_dislike"]
        responceLikeCount <- map["like_count"]
        responceDislikeCount <- map["dislike_count"]
        responceIsLike <- map["is_like"]
        responceAutoPlay <- map["auto_play"]
        adsUrl <- map["ads_url"]
        responseDescription <- map["description"]
        responceThumbnailImage <- map["thumbnail_image"]
        responcePosterImage <- map["poster_image"]
        responceCreatedAt   <- map["created_at"]
        responceThumbnailPath <- map["thumbnail_path"]
        responceSubscription <- map["subscription"]
        responceCommentCount <- map["comments_count"]
        responceTranscodedvideos <- map["transcodedvideos"]
        responceCategories <- map["categories"]
        responceIsFavorite <- map["is_favourite"]
        responceHLSPlaylistUrl <- map["hls_playlist_url"]
        responceVideoDuration <- map["video_duration"]
        responcePublished <- map["published_on"]
        reponceDemoStatus <- map["is_subscribed"]
        price <- map["price"]
        videoType <- map["collection"]
        categories <- map["categories"]
        responceViewsCount <- map["view_count"]
        isPremium <- map["is_premium"]
        starring <- map["presenter"]
        isLive <- map["is_live"]
        selectedSeasonName <- map["season_name"]
        categoryName <- map["video_category_name"]
        generName <- map["genre_name"]
        selectedSeasonId <- map["season_id"]
        videoKey <- map["passphrase"]
        subtitle <- map["subtitle"]
        globalViewCount <- map["global_video_view_count"]
        isRestricted <- map["is_restricted"]
        spriteImage <- map["sprite_image"]
        ageRestriction <- map["age_restriction"]
        newCategoryList <- map["mobile_category_list"]
    }
}
class CSSeason: Mappable {
    var seasonTitle = String()
    var seasonId = Int()
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        seasonId <- map["id"]
        seasonTitle <- map["title"]
    }
}
class CSSubTitle: Mappable {
    var baseURL = String()
    var subList = [CSSubList]()
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        baseURL <- map["base_url"]
        subList <- map["subtitle_list"]
    }
}
class CSSubList: Mappable {
    var language = String()
    var listURL = String()
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        language <- map["language"]
        listURL <- map["url"]
    }
}
class CSVideoCategory: Mappable {
    var videoTypeSlug = String()
    var videoTypeTitle = String()
    var videoTypeId = Int()
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        videoTypeId <- map["id"]
        videoTypeTitle <- map["title"]
        videoTypeSlug <- map["slug"]
    }
}
class CSVideoTypeCollection: Mappable {
    var videoTypeSlug = String()
    var videoTypeTitle = String()
    var videoTypeId = Int()
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
       videoTypeId <- map["id"]
       videoTypeTitle <- map["name"]
       videoTypeSlug <- map["slug"]
    }
}
// MARK: - Sub Mapper Class Transcode for Class VedioDetail
class Transcode: VedioDetail {
    var transcodeId = Int()
    var transcodeVideo = String()
    var transcodeThubNail = String()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        transcodeId <- map["id"]
        transcodeVideo <- map["video_url"]
        transcodeThubNail <- map["thumb_url"]
    }
}
// MARK: - Class QuestionAndAnswer
class QuestionAndAnswer: Mappable {
    var qaId = Int()
    var qaQuestionID = Int()
    var qaAnswer = String()
    var qaUserType = String()
    var qaCreatedAt = String()
    var qaAdmin: CustomerDetails!
    var qaCustomer: CustomerDetails!
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        qaId <- map["id"]
        qaUserType <- map["user_type"]
        qaCreatedAt <- map["created_at"]
        qaAnswer <- map["answers"]
        qaAdmin <- map["admin"]
        qaCustomer <- map["customer"]
    }
}
// MARK: - Class CommentsList
class CommentsList: Mappable {
    var commentId = String()
    var commentUserType = String()
    var commentCreatedAt = String()
    var commentComments = String()
    var commentReplyComment: CommentResponces! // = [CommentsList]()
    var commentAdmin: CustomerDetails!
    var commentCustomer: CustomerDetails!
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        commentId <- map["_id"]
        commentUserType <- map["user_type"]
        commentCreatedAt <- map["created_at"]
        commentComments <- map["comment"]
        commentReplyComment <- map["reply_comment"]
        commentAdmin <- map["admin"]
        commentCustomer <- map["customer"]
    }
}
// MARK: - Class Payment_info
class PaymentInfo: Mappable {
    var isBought = Int()
    var transactionId = String()
    var userViewCount = Int()
    var globalViewCount = Int()
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        isBought <- map["is_bought"]
        transactionId <- map["transaction_id"]
        userViewCount <- map["user_view_count"]
        globalViewCount <- map["global_view_count"]
    }
}
// MARK: - Class QuestionAndAnswer
class ReplyComments: Mappable {
    var idData = Int()
    var commentID = Int()
    var userType = String()
    var comment = String()
    var createdAt = String()
    var admin: CustomerDetails!
    var customer: CustomerDetails!
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        idData <- map["id"]
        commentID <- map["comment_id"]
        userType <- map["user_type"]
        comment <- map["comment"]
        createdAt <- map["created_at"]
        admin <- map["admin"]
        customer <- map["customer"]
    }
}
// MARK: - Class Q&AList
class QAList: Mappable {
    var commentId = Int()
    var commentUserType = String()
    var commentCreatedAt = String()
    var commentComments = String()
    var qaAnswer = String()
    var commentReplyComment = [QAList]()
    var commentAdmin: CustomerDetails!
    var commentCustomer: CustomerDetails!
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        commentId <- map["id"]
        commentUserType <- map["user_type"]
        commentCreatedAt <- map["created_at"]
        commentComments <- map["questions"]
        commentReplyComment <- map["reply_answer"]
        qaAnswer <- map["answers"]
        commentAdmin <- map["admin"]
        commentCustomer <- map["customer"]
    }
}
// MARK: - Sub Mapper Class CustomerDetails For  Class CommentsList
class CustomerDetails: CommentsList {
    var customerId = Int()
    var customerName = String()
    var customerEmail = String()
    var customerPhone = String()
    var customerProfilePicture = String()
    var customerDeviceType = String()
    var customerDeviceToken = String()
    var customerForgotPassword = String()
    // MARK: - Delegate Methods
    override func mapping( map: Map) {
        customerId <- map["id"]
        customerName <- map["name"]
        customerEmail <- map["email"]
        customerProfilePicture <- map["profile_picture"]
    }
}
// MARK: - Sub Mapper Class Categories For  Class VedioDetail
class Categories: VedioDetail {
    var categId = Int()
    var categTitle = String()
    var categSlug = String()
    var categImage = String()
    var categPivot: Pviot!
    var categParentCateg: ParentCategory!
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        categId <- map["id"]
        categTitle <- map["title"]
        categSlug <- map["slug"]
        categImage <- map["image_url"]
        categPivot <- map["pivot"]
        categParentCateg <- map["parent_category"]
    }
}
// MARK: - Sub Mapper Class Pviot For  Class Categories
class Pviot: Categories {
    var pviotCategoryId = Int()
    var pviotVideoId = Int()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        pviotCategoryId <- map["category_id"]
        pviotVideoId <- map["video_id"]
    }
}
// MARK: - Sub Mapper Class ParentCategory For  Class Categories
class ParentCategory: Categories {
    var parCategId = Int()
    var parCategTitle = String()
    var parCategSlug = String()
    var parCategImage = String()
    var parCategSubParent: ParentSubCategory!
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        parCategId <- map["id"]
        parCategTitle <- map["title"]
        parCategSlug <- map["slug"]
        parCategImage <- map["image_url"]
        parCategSubParent <- map["parent_category"]
    }
}
class CSVideoCountlMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var message = String()
    var status = String()
    var responseRequired: CountResponse!
    // MARK: - Delegate Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        message <- map["message"]
        status <- map["status"]
        responseRequired <- map["response"]
    }
    class CountResponse: CSVideoCountlMapper {
        var videoId = Int()
        var statusMessage = String()
        var viewCount = Int()
        var globalViewCount = Int()
        // MARK: - Delegate Methods
        override func mapping(map: Map) {
            videoId <- map["video_id"]
            statusMessage <- map["status"]
            viewCount <- map["view_count"]
            globalViewCount <- map["global_view_count"]
        }
    }
}
