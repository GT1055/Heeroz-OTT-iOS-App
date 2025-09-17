/*
 * CSLoginMapper
 * This Controller is used to map the response object into mapper
 * class which is used as model class for login and registaion screen api
 * which includes facebook login googleplus login and sign up also
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
// MARK: - Mapper Class For Login
class CSLoginMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var responseRequired: ResponseData!
    // MARK: - Mapping Class Delgate Methods
    required init?( map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        responseRequired <- map["response"]
    }
}
// MARK: - Sub Mapper Class ResponseData For CSLoginMapper
class ResponseData: CSLoginMapper {
    var userId = Int()
    var userName = String()
    var userEmail = String()
    var userPhone = String()
    var accessToken = String()
    var profilePicture = String()
    var userAge = String()
    var userDob = String()
    var isUserSubscribed = Int()
    var subscription = PlanList()
    // MARK: - Mapping Class Delgate Methods
    override func mapping( map: Map) {
        // direct conversion
        userId <- map["id"]
        userName <- map["name"]
        userEmail <- map["email"]
        userPhone <- map["phone"]
        accessToken <- map["access_token"]
        profilePicture <- map["profile_picture"]
        userAge <- map["age"]
        userDob <- map["dob"]
        isUserSubscribed <- map["is_subscribed"]
        subscription <- map["subscribed_plan"]
    }
}
