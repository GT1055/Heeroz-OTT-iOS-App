/*
 * CSCardModel.swift
 * This class  is used as (object mapper for card api)
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
class CSCardModel: Mappable {
    var error: Bool?
    var statusCode = Int()
    var message = String()
    var responce: CSCardResponce!
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        error <- map["error"]
        statusCode <- map["statusCode"]
        message <- map["message"]
        responce <- map["response"]
    }
}
class CSCardResponce: Mappable {
    var cardListArray = [CSCardList]()
    var transaction: CSTransaction!
    var transactionId : String!
    var rasorTransactionID: String!
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        cardListArray <- map["cards"]
        transaction <- map["transaction"]
        transactionId <- map["transaction_id"]
        rasorTransactionID <- map["razorpay_payment_id"]
    }
}
class CSCardList: Mappable {
    var cardId = Int()
    var cardHolderName = String()
    var cardNumber = String()
    var cardMonth = String()
    var cardYear = Int()
    var cardCvv = String()
    var isSelected = Int()
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        cardId <- map["id"]
        cardHolderName <- map["name"]
        cardNumber <- map["card_number"]
        cardMonth <- map["month"]
        cardYear <- map["year"]
        cardCvv <- map["cvvv"]
        isSelected <- map["is_Selected"]
    }
}
class CSTransaction: Mappable {
    var transactionId = String()
    var transactionStatus = String()
    var planName = String()
    var transactionTime = String()
    var razorTransactionID = String()
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        transactionId <- map["transaction_id"]
        transactionStatus <- map["status"]
        planName <- map["plan_name"]
        transactionTime <- map["created_at"]
        razorTransactionID <- map["razorpay_payment_id"]
    }
}
