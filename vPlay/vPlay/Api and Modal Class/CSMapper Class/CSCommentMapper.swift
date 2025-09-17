/*
 * CSCommentMapper
 * This Controller is used to map the response object into mapper class which is used as model class for comment list
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
// MARK: - Comments Mapper Class CSCommentMapper
class CSCommentMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var replyResponse: CSReplieResponce!
    var responseRequired: CommentResponces!
    // MARK: - Delegates Methods
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
        replyResponse <- map["response"]
    }
}
/// Reply responce handler
class CSReplieResponce: Mappable {
    var replyList: CSReplieComment!
    required init?(map: Map) {
    }
    func mapping(map: Map) {
       replyList <- map["reply_list"]
    }
}
/// Reply comment Responce Handler
class CSReplieComment: Mappable {
    var replyId = String()
    var createDate = String()
    var replyPage: CommentResponces!
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        replyId <- map["created__idat"]
        createDate <- map["created_at"]
        replyPage <- map["reply_comment"]
    }
}
// MARK: - Sub class Commentresponses for Class CSCommentMapper
class CommentResponces: CSCommentMapper {
    var commentTotal = Int()
    var commentPerPage = Int()
    var commentCurrentPage = Int()
    var commentLastPage = Int()
    var commentFromPage = Int()
    var commentToPage = Int()
    var commentNextPageUrl = String()
    var commentPrevPageUrl = String()
    var commentDetailArray = [CommentsList]()
    // MARK: - Delegates Methods
    override func mapping(map: Map) {
        // direct conversion
        commentTotal <- map["total"]
        commentPerPage <- map["per_page"]
        commentCurrentPage <- map["current_page"]
        commentLastPage <- map["last_page"]
        commentFromPage <- map["from"]
        commentToPage <- map["to"]
        commentNextPageUrl <- map["next_page_url"]
        commentPrevPageUrl <- map["prev_page_url"]
        commentDetailArray <- map["data"]
    }
}
class CSQACommentMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var responseRequired: CommentQAResponces!
    // MARK: - Delegates Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        responseRequired <- map["response"]
    }
}
// MARK: - Sub class Commentresponses for Class CSCommentMapper
class CommentQAResponces: CSQACommentMapper {
    var commentTotal = Int()
    var commentPerPage = Int()
    var commentCurrentPage = Int()
    var commentLastPage = Int()
    var commentFromPage = Int()
    var commentToPage = Int()
    var commentNextPageUrl = String()
    var commentPrevPageUrl = String()
    var commentDetailArray = [QAList]()
    // MARK: - Delegates Methods
    override func mapping( map: Map) {
        // direct conversion
        commentTotal <- map["total"]
        commentPerPage   <- map["per_page"]
        commentCurrentPage <- map["current_page"]
        commentLastPage <- map["last_page"]
        commentFromPage <- map["from"]
        commentToPage   <- map["to"]
        commentNextPageUrl <- map["next_page_url"]
        commentPrevPageUrl <- map["prev_page_url"]
        commentDetailArray <- map["data"]
    }
}
// MARK: - Sub Mapper Class ParentSubCategory For  Class ParentCategory
class ParentSubCategory: ParentCategory {
    var parSubCategId = Int()
    var parSubCategTitle = String()
    var parSubCategSlug = String()
    var parSubCategImage = String()
    // MARK: - Delegate Methods
    override func mapping(map: Map) {
        parSubCategId <- map["id"]
        parSubCategTitle <- map["title"]
        parSubCategSlug <- map["slug"]
        parSubCategImage <- map["image_url"]
    }
}
/// Responces
class CSVideoUrlResponse {
    var quality: String
    var resulotionUrl: URL
    required init(quality: String, resulotionUrl: String) {
        self.quality = quality
        self.resulotionUrl = URL.init(string: resulotionUrl)!
    }
}
class CSVideoData {
    var video = [CSVideoUrlResponse]()
    required init(videos: CSVideoUrlResponse) {
        video.append(videos)
    }
}
