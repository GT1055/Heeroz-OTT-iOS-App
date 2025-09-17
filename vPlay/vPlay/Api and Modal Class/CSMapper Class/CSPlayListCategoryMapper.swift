/*
 * CSPlayListCategoryMapper
 * This Controller is used to map the response object into mapper
 * class which is used as model class for and playlist video Detail in video detail page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
// MARK: - Mapper Class for CSPlayListCategoryMapper
class CSPlayListCategoryMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var categoryResponces: CategoryResp!
    // MARK: - Mapper Delegate
    required init? (map: Map) {
    }
    func mapping( map: Map) {
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        categoryResponces <- map["response"]
    }
}
// MARK: - Sub Mapper Class CategoryResp for CSPlayListCategoryMapper
class CategoryResp: CSPlayListCategoryMapper {
    var categoryRespId = Int()
    var categoryRespTitle = String()
    var categoryRespSlug = String()
    var categoryRespImage = String()
    var categoryArray: [CategoryArray]!
    var categoryPlayListDict: PlayListDic!
    // MARK: - Mapper Delegate
    override func mapping(map: Map) {
        categoryRespId <- map["id"]
        categoryRespTitle <- map["title"]
        categoryRespSlug <- map["slug"]
        categoryRespImage <- map["image_url"]
        categoryArray <- map["categories"]
        categoryPlayListDict <- map["playlist_details"]
    }
}
// MARK: - Sub Mapper Class PlayListDic for CategoryResp
class PlayListDic: Mappable {
    var playListDictTotal = Int()
    var playListDictPerPage = Int()
    var playListDictCurrentPage = Int()
    var playListDictLastPage = Int()
    var playListDictNextPageUrl = String()
    var playListDictPrevPageUrl = String()
    var playListDictFrom = Int()
    var playListDictTo = Int()
    var playListDictData = [PlayListArray]()
    // MARK: - Mapper Delegate
    required init?( map: Map) {
    }
    func mapping(map: Map) {
        playListDictTotal <- map["total"]
        playListDictPerPage <- map["per_page"]
        playListDictCurrentPage <- map["current_page"]
        playListDictLastPage <- map["last_page"]
        playListDictNextPageUrl <- map["next_page_url"]
        playListDictPrevPageUrl <- map["prev_page_url"]
        playListDictFrom <- map["from"]
        playListDictTo <- map["to"]
        playListDictData <- map["data"]
    }
}
// MARK: - Sub Mapper Class playListArray for PlayListDic
class PlayListArray: PlayListDic {
    var playListArrayId = Int()
    var playListArrayName = String()
    var playListArraySlug = String()
    var playListArrayCreatedTime = String()
    var playListArrayImage = String()
    var updatedLabel = String()
    var playListArrayVediouCount = Int()
    var playListArrayFollowers = Int()
    var playListArrayFollowing = Int()
    var playListVideoInfo: CSPlaylistVideoInfo?
    // MARK: - Mapper Delegate
    override func mapping(map: Map) {
        playListArrayId <- map["id"]
        playListArrayName <- map["name"]
        playListArraySlug <- map["slug"]
        updatedLabel <- map["updated_at"]
        playListArrayCreatedTime <- map["created_at"]
        playListArrayImage <- map["playlist_image"]
        playListArrayVediouCount <- map["video_count"]
        playListArrayFollowers <- map["followers_count"]
        playListArrayFollowing <- map["following"]
        playListVideoInfo <- map["video_info"]
    }
}
class CSPlaylistVideoInfo: Mappable {
    var videoId = Int()
    // MARK: - Mapper Delegate
    required init? (map: Map) {
    }
    func mapping( map: Map) {
         videoId <- map["id"]
    }
}
// MARK: - Sub Mapper Class categoryArray for CategoryResp
class CategoryArray: CategoryResp {
    var categoryId = Int()
    var categoryTitle = String()
    var categorySlug = String()
    var categoryImage = String()
    // MARK: - Mapper Delegate
    override func mapping(map: Map) {
        categoryId <- map["id"]
        categoryTitle <- map["title"]
        categorySlug <- map["slug"]
        categoryImage <- map["image_url"]
    }
}
class CSPlayListsMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var categoryResponces: PlayListDic!
    // MARK: - Mapper Delegate
    required init?(map: Map) {
    }
    func mapping( map: Map) {
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        categoryResponces <- map["response"]
    }
}
