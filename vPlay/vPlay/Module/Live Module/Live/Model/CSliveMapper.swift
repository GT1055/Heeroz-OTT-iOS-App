/*
 *  CSliveMapper
 * This Controller is used to map the responce object into mapper class
 * which is used as model class for live stream of  video
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import Foundation
import ObjectMapper
// MARK: - live video detail Mapper Class CSliveMapper
class CSliveMapper: Mappable {
    // data type declearing
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var requriedResponce: LiveVideosArray!
    // MARK: - Delegated Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode   <- map["statusCode"]
        responseCode   <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        requriedResponce <- map["response"]
    }
}
// MARK: - sub UpcomingliveVideosArray class of Mapper Class CSliveMapper
class LiveVideosArray: Mappable {
    // data type declearing
    var serverTime = String()
    var currentLiveVideos = [UpcomingliveVideosList]()
    var todayLiveVideos = [UpcomingliveVideosList]()
    var upcomingvideo: CSUpcomingLiveData!
    var banner: CSUpcomingLiveData!
    // MARK: - Delegated Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        currentLiveVideos <- map["current_live_videos"]
        todayLiveVideos <- map["todal_live_videos"]
        upcomingvideo <- map["upcoming_live_videos"]
        banner <- map["banner"]
    }
}
class CSUpcomingLiveData: Mappable {
    var lastPage = Int()
    var currentPage = Int()
    var upComingData = [UpcomingliveVideosList]()
    required init?(map: Map) {
    }
    func mapping(map: Map) {
      lastPage <- map["last_page"]
      currentPage <- map["current_page"]
        upComingData <- map["data"]
    }
}
// MARK: - sub UpcomingliveVideosList class of Mapper Class CSliveMapper
class UpcomingliveVideosList: Mappable {
    // data type declearing
    var idData = Int()
    var isPremium = Int()
    var title = String()
    var description = String()
    var duration = String()
    var imageurl = String()
    var playlistURL = String()
    var posterImage = String()
    var datelabel = String()
    var starttime = String()
    // MARK: - Delegated Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        idData <- map["id"]
        title <- map["title"]
        playlistURL <- map["hls_playlist_url"]
        isPremium <- map["is_premium"]
        description <- map["description"]
        duration <- map["video_duration"]
        imageurl <- map["thumbnail_image"]
        posterImage <- map["poster_image"]
        datelabel <- map["created_at"]
        starttime <- map["scheduledStartTime"]
    }
}
class LiveVideoListArray: Mappable {
    var liveVideoTitle = String()
    var slug = String()
    var liveVideoArray = [UpcomingliveVideosList]()
    var currentPage = Int()
    var lastPage = Int()
    // MARK: - Delegated Methods
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        lastPage <- map["last_page"]
        currentPage <- map["current_page"]
        liveVideoArray <- map["data"]
        slug <- map["slug"]
        liveVideoTitle <- map["title"]
    }
}
