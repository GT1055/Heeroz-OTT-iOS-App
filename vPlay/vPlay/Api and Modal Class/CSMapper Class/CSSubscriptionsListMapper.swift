/*
 * CSSubscriptionsListMapper
 * This Controller is used to map the responce object into mapper
 * class which is used as model class for SubscriptionsList list
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
// MARK: - Subscription plan list Mapper for Class CSSubscriptionsListMapper
class CSSubscriptionsListMapper: Mappable {
    // Data Declaring
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var requriedResponce: ALLSubscription!
    // MARK: - Delegates Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        requriedResponce <- map["response"]
    }
}
// MARK: - listing all Plan CSSubscription List Detail
class ALLSubscription: Mappable {
    var allsubscribeList: SuscribeData!
    var subscidedPlan = PlanList()
    var planListArray = [PlanList]()
    // MARK: - Delegates Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        allsubscribeList <- map["allSubscriptions"]
        planListArray <- map["subscription"]
        subscidedPlan <- map["subscribed_plan"]
    }
}
// MARK: - sub class Page map data for SuscribeData
class SuscribeData: Mappable {
    // Data Declaring
    var totalPlan = Int()
    var perPage = Int()
    var currentPage = Int()
    var lastPage = Int()
    var nextPageURL = String()
    var prevPageURL = String()
    var fromPage = Int()
    var toPage = Int()
    var planListArray = [PlanList]()
    var planDaysLeft = String()
    // MARK: - Delegates Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        totalPlan <- map["total"]
        perPage <- map["per_page"]
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        nextPageURL <- map["next_page_url"]
        prevPageURL <- map["prev_page_url"]
        fromPage <- map["from"]
        toPage <- map["to"]
        planListArray <- map["subscribed_plan"]
        planDaysLeft  <- map["plan_duration_left"]
    }
}
// MARK: - planlist data for PlanList
class PlanList: Mappable {
    // Data Declaring
    var planId = Int()
    var planName = String()
    var planType = String()
    var planSlug = String()
    var planDescription = String()
    var planAmount = Int()
    var planDuration = String()
    var inAppID = String()
    var geoprice: GeoPrice!
    // MARK: - Delegates Methods
    required convenience init?( map: Map) {
        self.init()
    }
    func mapping( map: Map) {
        // direct conversion
        planId <- map["id"]
        planName <- map["name"]
        planType <- map["type"]
        planSlug <- map["slug"]
        planAmount <- map["amount"]
        planDescription <- map["description"]
        planDuration <- map["duration"]
        inAppID <- map["in_app_id"]
        geoprice <- map["geo_price"]
    }
}

class GeoPrice: Mappable {
    var currency = String()
    var amout = Double()
    // MARK: - Delegates Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        currency <- map["currency"]
        amout <- map["amout"]
    }
}
