/*
 * CSTransactionMapper
 * This Controller is used to map the response object into mapper class
 * which is used as model class  listing all Transaction
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
// MARK: - notification Mapper Class CSTransactionMapper
class CSTransactionMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var message = String()
    var status = String()
    var requriedResponce: WholeArray!
    // MARK: - Delegates methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        message <- map["message"]
        status <- map["status"]
        requriedResponce <- map["data"]
    }
}
// MARK: - Sub class Totalarray for Class CSTransactionMapper
class WholeArray: Mappable {
    var currentpage = Int()
    var lastpage = Int()
    var nxtURL = String()
    var prevURL = String()
    var from = Int()
    var toPage = Int()
    var dataListArray = [TransactionDataArray]()
    // MARK: - Delegates Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        currentpage <- map["current_page"]
        lastpage <- map["last_page"]
        nxtURL <- map["next_page_url"]
        prevURL <- map["prev_page_url"]
        from <- map["from"]
        toPage <- map["to"]
        dataListArray <- map["data"]
    }
}
// MARK: - Sub class Totalarray for Class CSTransactionMapper
class TransactionDataArray: Mappable {
    var transactionId = String()
    var razorTransactionID = String()
    var transactionMessage = String()
    var planName = String()
    var transactionStatus = String()
    var subscriptionPlanId = Int()
    var amount = Double()
    var transactionTime = String()
    var currencytype = String()
    var subscription: PlanList!
    var videotransactionList: TransactionListArray!
    // MARK: - Delegates Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        transactionId <- map["transaction_id"]
        transactionMessage <- map["transaction_message"]
        planName <- map["plan_name"]
        subscriptionPlanId <- map["subscription_plan_id"]
        transactionTime <- map["created_at"]
        transactionStatus <- map["status"]
        subscription <- map["get_subscription_plan"]
        videotransactionList <- map["video"]
        amount <- map["amount"]
        currencytype <- map["currency_type"]
        razorTransactionID <- map["razorpay_payment_id"]
    }
}
class CSCountryList: Mappable {
    var countryCode = String()
    var countryName = String()
    var countryDialCode = String()
    // MARK: - Delegates Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        countryCode <- map["code"]
        countryName <- map["name"]
        countryDialCode <- map["dial_code"]
    }
}
class TransactionListArray: Mappable {
    var videoId = String()
    var videoTitle = String()
    var videoSlug = String()
    var videoImage = String()
    var VideoCount = Int()
    var getVideocount = Int()
    var genereName = String()
    var videoCategory = String()
    var issubscribed = Int()
    var geoprice: GeoPrice!
    // MARK: - Delegates Methods
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        videoId <- map["id"]
        videoTitle <- map["title"]
        videoSlug <- map["slug"]
        videoImage <- map["thumbnail_image"]
        VideoCount <- map["global_video_view_count"]
        getVideocount <- map["customer_video_view_count"]
        genereName <- map["genre_name"]
        videoCategory <- map["video_category_name"]
        issubscribed <- map["is_subscribed"]
        geoprice <- map["geo_price"]
    }
}

