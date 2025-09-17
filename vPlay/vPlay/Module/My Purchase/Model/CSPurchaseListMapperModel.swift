//
//  CSPurchaseListMapper.swift
//  vPlay
//
//  Created by user on 12/07/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper

struct PurchaseListMapper : Mappable {
    var statusCode = Int()
    var status = String()
    var message = String()
    var responseRequired : PurchaseResponse!
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        statusCode <- map["statusCode"]
        status <- map["status"]
        message <- map["message"]
        responseRequired <- map["data"]
    }
}
struct PurchaseResponse : Mappable {
    var currentPage = Int()
    var purchaseDetail = [PurchaseDetail]()
    var firstPageUrl = String()
    var from = Int()
    var lastPage = Int()
    var lastPageUrl = String()
    var nextPageUrl = String()
    var path = String()
    var perPage = Int()
    var prevPageUrl = String()
    var to = Int()
    var total = Int()
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        currentPage <- map["current_page"]
        purchaseDetail <- map["data"]
        firstPageUrl <- map["first_page_url"]
        from <- map["from"]
        lastPage <- map["last_page"]
        lastPageUrl <- map["last_page_url"]
        nextPageUrl <- map["next_page_url"]
        path <- map["path"]
        perPage <- map["per_page"]
        prevPageUrl <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }
}

struct PurchaseDetail: Mappable {
    var id = Int()
    var globalVideoViewCount = Int()
    var customerVideoViewCount = Int()
    var name = String()
    var email = String()
    var phone = String()
    var paymentMethodId = Int()
    var customerId = Int()
    var status = String()
    var transactionMessage = String()
    var transactionId = String()
    var subscriptionPlanId = Int()
    var subscriberId = Int()
    var planName = String()
    var cardId = Int()
    var videoId = Int()
    var createdAt = String()
    var updatedAt = String()
    var amount = Int()
    var video : PurchasedVideo!
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        globalVideoViewCount <- map["global_view_count"]
        customerVideoViewCount <- map["view_count"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        paymentMethodId <- map["payment_method_id"]
        customerId <- map["customer_id"]
        status <- map["status"]
        transactionMessage <- map["transaction_message"]
        transactionId <- map["transaction_id"]
        subscriptionPlanId <- map["subscription_plan_id"]
        subscriberId <- map["subscriber_id"]
        planName <- map["plan_name"]
        cardId <- map["card_id"]
        videoId <- map["video_id"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        amount <- map["amount"]
        video <- map["video"]
    }
}

struct PurchasedVideo : Mappable {
    var id = Int()
    var title = String()
    var slug = String()
    var thumbnailImage = String()
    var genreName = String()
    var videoCategoryName = String()
    var isSubscribed = Int()
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        slug <- map["slug"]
        thumbnailImage <- map["thumbnail_image"]
        genreName <- map["genre_name"]
        videoCategoryName <- map["video_category_name"]
        isSubscribed <- map["is_subscribed"]
    }
}
