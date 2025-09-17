/*
 * CSHomeApiMapper
 * This Controller is used to map the response object into mapper
 * class which is used as model class for listing recent,trending
 * and playlist and also bannser image in home page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
// MARK: - Sub Mapper Class CommenResponceData for Class Response
class CommenResponceData: Mappable {
    var responseId = Int()
    var responseTitle = String()
    var responseSlug = String()
    var responseDescription = String()
    var responseShortDescription = String()
    var responceThumbnailImage = String()
    var responcePreviewImage = String()
    var responceCreatedAt = String()
    var responceThumbnailPath = String()
    var responceSubtitle = String()
    var responceSubtitlePath = String()
    var responceDisclaimer = String()
    var responceAge = String()
    var responceTrailer = String()
    var responceSubscription = String()
    var responceIsFavourite = Int()
    var responceTranscodedvideos = [TranscodeHome]()
    var responceCategories = [CategoriesHome]()
    var responceVideoDuration = String()
    var responceFavouriteThumbnailImage = String()
    var responceTrailerStatus = Int()
    var reponceDemoStatus = Int()
    var reponceVideoUrl = String()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        responseId <- map["id"]
        responseTitle <- map["title"]
        responseSlug <- map["slug"]
        responseDescription <- map["description"]
        responseShortDescription <- map["short_description"]
        responceThumbnailImage <- map["thumbnail_image"]
        responceFavouriteThumbnailImage <- map["thumbnail_image"]
        responcePreviewImage <- map["preview_image"]
        responceCreatedAt <- map["created_at"]
        responceThumbnailPath <- map["thumbnail_path"]
        responceSubtitle <- map["subtitle"]
        responceSubtitlePath <- map["subtitle_path"]
        responceDisclaimer <- map["disclaimer"]
        responceAge <- map["age"]
        responceTrailer <- map["trailer"]
        responceSubscription <- map["subscription"]
        responceIsFavourite <- map["is_favourite"]
        responceVideoDuration <- map["video_duration"]
        responceTrailerStatus <- map["trailer_status"]
        reponceDemoStatus <- map ["is_subscribed"]
        reponceVideoUrl <- map ["hls_playlist_url"]
    }
}
// MARK: - Sub Mapper Class PlaylistHome for Class CommenresponseData
class PlaylistHome: CommenResponceData {
    var playListId = Int()
    var playListName = String()
    var playListSlug = String()
    var playListCreatedAt = String()
    var playListImage = String()
    var playListTotalVideos = Int()
    var playListTotalFollowers = Int()
    var playListFollowers = Int()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        playListId <- map["id"]
        playListName <- map["name"]
        playListSlug <- map["slug"]
        playListCreatedAt <- map["created_at"]
        playListImage <- map["playlist_image"]
        playListTotalVideos <- map["videos"]
        playListTotalFollowers <- map["followers"]
        playListFollowers <- map["following"]
    }
}
// MARK: - Sub Mapper Class TranscodeHome for Class CommenresponseData
class TranscodeHome: CommenResponceData {
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
// MARK: - Sub Mapper Class CategoriesHome for Class CommenresponseData
class CategoriesHome: CommenResponceData {
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
class Subscided: Mappable {
    var subAmount = Int()
    var subDescribe = String()
    var subDuration = String()
    var subName = String()
    var categImage = String()
    var subPivot: Subpivot!
    var subType = String()
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        subAmount <- map["amount"]
        subDescribe <- map["description"]
        subDuration <- map["duration"]
        subPivot <- map["pivot"]
        subName <- map["name"]
        subType <- map["type"]
    }
}
class Subpivot: Subscided {
    var subPivotCustomerId = Int()
    var subPivotEndDate = String()
    var subPivotStartDate = String()
    var subPivotActive = String()
    var subPivotPlanId = Int()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        subPivotCustomerId <- map["customer_id"]
        subPivotEndDate <- map["end_date"]
        subPivotStartDate <- map["start_date"]
        subPivotActive <- map["is_active"]
        subPivotPlanId <- map["subscription_plan_id"]
    }
}
class BannarDetailData: Mappable {
    var name = String()
    var duration = String()
    var bannnerId = Int()
    var videoId = Int()
    var slug = String()
    var image = String()
    var description = String()
    var bannerVideoUrl = String()
    var isPremium = Int()
    var isLive = Int()
    // MARK: - Delegate Methods
    required convenience init?( map: Map) {
        self.init()
    }
    // MARK: - Delegate Methods
    func mapping(map: Map) {
        bannnerId <- map["banner"]
        videoId <- map["video_id"]
        slug <- map["slug"]
        duration <- map["duration"]
        name <- map["name"]
        image <- map["image"]
        description <- map["description"]
        isPremium <- map["is_Premium"]
        isLive <- map["is_Live"]
        bannerVideoUrl <- map["bannerVideoUrl"]
    }
}
