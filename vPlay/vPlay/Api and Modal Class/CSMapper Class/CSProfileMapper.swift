/*
 * CSProfileMapper
 * This class is used to map the response object into mapper class
 * which is used as model class for user profile
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
// MARK: - user Profile Mapper Class CSProfileMapper
class CSProfileMapper: Mappable {
    var errorStatus = String()
    var statusCode = Int()
    var responseCode = Int()
    var message = String()
    var status = String()
    var accessToken = String()
    var requriedResponce: ProfileResponse!
    // MARK: - Delegates Methods
    required init?(map: Map) {
    }
    func mapping( map: Map) {
        // direct conversion
        errorStatus <- map["error"]
        statusCode <- map["statusCode"]
        responseCode <- map["responseCode"]
        message <- map["message"]
        status <- map["status"]
        accessToken <- map["access_token"]
        requriedResponce <- map["response"]
    }
}
// MARK: - Sub class ProfileResponse for Class CSProfileMapper
class ProfileResponse: CSProfileMapper {
    var profileArray: Userprofile!
    var subscribeDuration = String()
    var userVideoCount = Int()
    var userPlaylistCount = Int()
    // MARK: - Delegates Methods
    override func mapping( map: Map) {
        profileArray <- map["profile"]
        userVideoCount <- map["videos_count"]
        userPlaylistCount <- map["playlist_count"]
        subscribeDuration <- map["plan_duration_left"]
    }
}
// MARK: - Sub class Userprofile for Class ProfileResponse
class Userprofile: ProfileResponse {
    var profiId = Int()
    var profiName = String()
    var profiEmail = String()
    var profiPhone = String()
    var profiImage = String()
    var profiDob = String()
    var countryCode = String()
    // MARK: - Delegates Methods
    override func mapping(map: Map) {
        profiId <- map["id"]
        profiName <- map["name"]
        profiEmail <- map["email"]
        profiPhone <- map["phone"]
        profiImage <- map["profile_picture"]
        profiDob <- map["dob"]
        countryCode <- map["country_code"]
    }
}
