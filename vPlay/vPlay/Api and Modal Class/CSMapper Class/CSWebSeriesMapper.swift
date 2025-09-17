/*
 * CSWebSeriesMapper
 * This class contains all the mapper model which is needed for the webseries
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2019 Contus. All rights reserved.
 */

import Foundation
import ObjectMapper

class CSWebSeries: Mappable {
    var error = Bool()
    var statusCode = Int()
    var status = String()
    var message = String()
    var response: WebSeriesResponse!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        statusCode <- map["statusCode"]
        status <- map["status"]
        message <- map["message"]
        response <- map["response"]
    }
}

class WebSeriesResponse: CSWebSeries {
    var info: WebSeriesInfo!
    var related: WebSeriesRelated!
    var seasons = [CSSeason]()
    var seasonsList: WebSeriesRelated!
    
    override func mapping(map: Map) {
        info <- map["webseries_info"]
        related <- map["related"]
        seasons <- map["seasons"]
        seasonsList <- map["season_list"]
    }
}

class WebSeriesInfo: WebSeriesResponse {
    var id = Int()
    var title = String()
    var slug = String()
    var isWebSeries = Int()
    var seriesDetailID = Int()
    var seriesDetails: WebSeriesDetails!
    
    override func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        slug <- map["slug"]
        isWebSeries <- map["is_web_series"]
        seriesDetailID <- map["video_webseries_detail_id"]
        seriesDetails <- map["webseries_detail"]
    }
}

class WebSeriesDetails: WebSeriesInfo {
    var seriesID = Int()
    var seriesTitle = String()
    var seriesSlug = String()
    var description = String()
    var thumbnail = String()
    var poster = String()
    var starring = String()
    var genreID = Int()
    var parentCategoryID = Int()
    var createdDate = String()
    var genereContent: genereContent?
    
    override func mapping(map: Map) {
        seriesID <- map["id"]
        seriesTitle <- map["title"]
        seriesSlug <- map["slug"]
        description <- map["description"]
        thumbnail <- map["thumbnail_image"]
        poster <- map["poster_image"]
        starring <- map["starring"]
        genreID <- map["genre_id"]
        parentCategoryID <- map["parent_category_id"]
        createdDate <- map["created_at"]
        genereContent <- map["genre"]
    }
}

class WebSeriesRelated: WebSeriesResponse {
    var currentPage = Int()
    var lastPage = Int()
    var data = [WebSeriesData]()
    
    override func mapping(map: Map) {
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        data <- map["data"]
    }
}

class genereContent: WebSeriesDetails {
    var genereID = Int()
    var genereName = String()
    var genereSlug = String()
    var generethumbnail = String()
    override func mapping(map: Map) {
        genereID <- map["id"]
        genereName <- map["name"]
        genereSlug <- map["slug"]
        generethumbnail <- map["group_image"]
    }
}

class WebSeriesData: Mappable {
    var id = Int()
    var title = String()
    var description = String()
    var slug = String()
    var thumbnail = String()
    var isFavourite = Int()
    var categoryName = String()
    var isLike = Int()
    var isDislike = Int()
    var likeCount = Int()
    var dislikeCount = Int()
    var isAutoPlay = Int()
    var seasonID = Int()
    var seasonName = String()
    var price = Int()
    var genreName = String()
    var isSubscribed = Int()
    var posterImage = String()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        slug <- map["slug"]
        thumbnail <- map["thumbnail_image"]
        posterImage <- map["poster_image"]
        isFavourite <- map["is_favourite"]
        categoryName <- map["video_category_name"]
        isLike <- map["is_like"]
        isDislike <- map["is_dislike"]
        likeCount <- map["like_count"]
        dislikeCount <- map["dislike_count"]
        isAutoPlay <- map["auto_play"]
        seasonID <- map["season_id"]
        seasonName <- map["season_name"]
        price <- map["price"]
        genreName <- map["genre_name"]
        isSubscribed <- map["is_subscribed"]
    }
}
