//
//  CSWebseriesDataModel.swift
//  vPlay
//
//  Created by user on 11/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper
class CSSeriesMapper: Mappable {
    var error = Bool()
    var statusCode = Int()
    var status = String()
    var message = String()
    var response = CSSeriesResponse()
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        error <- map["error"]
        statusCode <- map["statusCode"]
        status <- map["status"]
        message <- map["message"]
        response <- map["response"]
    }
}
class CSSeriesResponse: Mappable {
    var mainSeries = [CSSeries]()
    var genreSeries = [CSGenre]()
    var moreSeries = CSGenre()
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        mainSeries <- map["main_webseries"]
        genreSeries <- map["genre_webseries"]
        moreSeries <- map["more_webseries"]
    }
}
class CSSeries: Mappable {
    var currentPage = Int()
    var lastPage = Int()
    var categoryName = String()
    var data = [CSSeriesData]()
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        categoryName <- map["category_name"]
        data <- map["data"]
    }
}
class CSSeriesData: Mappable {
    var id = Int()
    var title = String()
    var slug = String()
    var description = String()
    var posterImage = String()
    var thumbnailImage = String()
    var genreID = Int()
    var parentCategoryID = Int()
    var genre = CSGenre()
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        slug <- map["slug"]
        description <- map["description"]
        posterImage <- map["poster_image"]
        thumbnailImage <- map["thumbnail_image"]
        genreID <- map["genre_id"]
        parentCategoryID <- map["parent_category_id"]
    }
}
class CSGenre: Mappable {
    var id = Int()
    var name = String()
    var slug = String()
    var groupImage = String()
    var seriesData = CSSeries()
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        groupImage <- map["group_image"]
        seriesData <- map["series_list"]
    }
}
