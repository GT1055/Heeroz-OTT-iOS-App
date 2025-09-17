/*
 * CSElasticSearchMapper
 * A Mapper class for Elastic search api integration
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import ObjectMapper
// MARK: - search data for Class CSElasticSearchMapper
class CSElasticSearchMapper: Mappable {
    // Data Declaring
    var errorStatus = String()
    var statusCode = Int()
    var message = String()
    var status = String()
    var requiredResults: SearchResults!
    // MARK: - Deleage methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        message <- map["message"]
        status <- map["status"]
        requiredResults <- map["response"]
    }
}
// MARK: - sub class SearchResults for Class CSElasticSearchMapper
class SearchResults: CSElasticSearchMapper {
    // Data declaring
    var videoDetailsArray = [VideoDetailsArray]()
    // MARK: - Delegate methods
    override func mapping(map: Map) {
        videoDetailsArray <- map["search_result"]
    }
}
// MARK: - sub class VideoDetailsArray for Class SearchResults
class VideoDetailsArray: SearchResults {
    // Data declaring
    var idData = Int()
    var index = String()
    var score = Int()
    var type = String()
    var videoDetail: VideoDetail!
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        idData <- map["_id"]
        index <- map["_index"]
        score <- map["_score"]
        type <- map["_type"]
        videoDetail <- map["_source"]
    }
}
// MARK: - sub class VideoDetail for Class VideoDetailsArray
class VideoDetail: VideoDetailsArray {
    var videoId = Int()
    var title = String()
    var category = String()
    var duration = String()
    var thumbImage = String()
    var tags = String()
    // MARK: - Delegate methods
    override func mapping(map: Map) {
        videoId <- map["id"]
        title <- map["title"]
        tags <- map["tags"]
        category <- map["parent_category_name"]
        duration <- map["duration"]
        thumbImage <- map["thumb_image"]
    }
}
