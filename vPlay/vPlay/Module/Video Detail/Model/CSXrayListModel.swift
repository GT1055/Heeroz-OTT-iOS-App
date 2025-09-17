//
//  CSXrayListModel.swift
//  vPlay
//
//  Created by user on 26/06/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper

struct XrayDetail : Codable {
    let artistName : String?
    let artistImage : String?
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case artistImage = "artist_image"
        case description = "description"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
        artistImage = try values.decodeIfPresent(String.self, forKey: .artistImage)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
    
}
struct XRayListBaseModel : Codable {
    let status : String?
    let error : String?
    let xrayList : [XrayDetail]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case error = "error"
        case xrayList = "xray_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        xrayList = try values.decodeIfPresent([XrayDetail].self, forKey: .xrayList)
    }
    
}



struct XrayBase : Mappable {
    var statusCode = Int()
    var status = String()
    var message = String()
    var response : XrayResponse!
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        statusCode <- map["statusCode"]
        status <- map["status"]
        message <- map["message"]
        response <- map["response"]
    }
}
struct XrayResponse : Mappable {
    var id = Int()
    var genreName = String()
    var videoCategory_name = String()
    var isSubscribed = Int()
    var castInfo = [CastInfo]()
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        genreName <- map["genre_name"]
        videoCategory_name <- map["video_category_name"]
        isSubscribed <- map["is_subscribed"]
        castInfo <- map["cast_info"]
    }
}
struct CastInfo : Mappable {
    var id = Int()
    var name = String()
    var description = String()
    var bannerImage = String()
    var externalUrl = String()
    var isActive = Int()
    var creatorId = Int()
    var updatorId = Int()
    var createdAt = String()
    var updatedAt = String()
    var pivot : Pivot!
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        bannerImage <- map["banner_image"]
        externalUrl <- map["external_url"]
        isActive <- map["is_active"]
        creatorId <- map["creator_id"]
        updatorId <- map["updator_id"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        pivot <- map["pivot"]
    }
    
}
struct Pivot : Mappable {
    var videoId = Int()
    var xRayCastId = Int()
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        videoId <- map["video_id"]
        xRayCastId <- map["x_ray_cast_id"]
    }
    
}
