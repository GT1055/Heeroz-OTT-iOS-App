/*
 * CSLiveDetailsMapper
 * This Controller is used to map the responce object into mapper
 * class which is used as model class for and video Detail and list relate videos in video detail page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import Foundation
import UIKit
import ObjectMapper
// MARK: - live page  Mapper Class CSLiveDetailsMapper
class CSLiveDetailsMapper: Mappable {
    // Declare data
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var responseRequired: LiveResponse!
    // MARK: - Delegate Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode   <- map["statusCode"]
        responseCode   <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        responseRequired <- map["response"]
    }
}
// MARK: - Sub Mapper Class LiveResponse for Class CSLiveDetailsMapper
class LiveResponse: CSLiveDetailsMapper {
    // Declare data
    var videoDict: VideoDictionary!
    var relatedPlaylist = [VideoRelatedPlaylist]()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        videoDict <- map["video"]
        relatedPlaylist <- map["live_related_videos"]
    }
}
// MARK: - Sub Mapper Class LiveResponse for Class VideoDictionary
class VideoDictionary: LiveResponse {
    // Declare data
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
    var responceCommentCount = Int()
    var responceIsFavorite = Int()
    var responceSelectedThumbnailImage = String()
    var responceHLSPlaylistUrl = String()
    var responceTranscodedvideos = [Transcode]()
    var responceCategories = [Categories]()
    var responceIsFollowing = Int()
    // MARK: - Delegate Methods
    override func mapping( map: Map) {
        // direct conversion
        responseId <- map["id"]
        responseTitle <- map["title"]
        responseSlug <- map["slug"]
        responseDescription <- map["description"]
        responseShortDescription <- map["description"]
        responceThumbnailImage <- map["thumbnail_image"]
        responcePreviewImage <- map["preview_image"]
        responceCreatedAt <- map["created_at"]
        responceThumbnailPath <- map["thumbnail_path"]
        responceSubtitle <- map["subtitle"]
        responceSubtitlePath <- map["subtitle_path"]
        responceDisclaimer <- map["disclaimer"]
        responceAge <- map["age"]
        responceTrailer <- map["trailer"]
        responceSubscription <- map["subscription"]
        responceCommentCount <- map["comments_count"]
        responceTranscodedvideos <- map["transcodedvideos"]
        responceCategories <- map["categories"]
        responceIsFavorite <- map["favourites"]
        responceIsFollowing <- map["follow"]
        responceSelectedThumbnailImage <- map["thumbnail_image"]
        responceHLSPlaylistUrl <- map["youtube_id"]
    }
}
// MARK: - Sub Mapper Class Video_realted_playlist for Class CSLiveDetailsMapper
class VideoRelatedPlaylist: CSLiveDetailsMapper {
    // Declare data
    var responseId = Int()
    var responseTitle = String()
    var responseSlug = String()
    var responceThumbnailImage = String()
    var responceCreatedAt = String()
    var description = String()
    // MARK: - Delegate Methods
    override func mapping( map: Map) {
        // direct conversion
        responseId <- map["id"]
        responseTitle <- map["title"]
        description <- map["description"]
        responseSlug <- map["slug"]
        responceThumbnailImage <- map["thumbnail_image"]
        responceCreatedAt <- map["created_at"]
    }
}
// MARK: - Sub Mapper Class Category for Class CSLiveDetailsMapper
class Category: CSLiveDetailsMapper {
    // Declare data
    var responseId = Int()
    var responseTitle = String()
    var responseSlug = String()
    var responceThumbnailImage = String()
    var description = String()
    // MARK: - Delegate Methods
    override func mapping( map: Map) {
        // direct conversion
        responseId <- map["id"]
        responseTitle <- map["title"]
        description <- map["description"]
        responseSlug <- map["slug"]
        responceThumbnailImage <- map["image_url"]
    }
}
