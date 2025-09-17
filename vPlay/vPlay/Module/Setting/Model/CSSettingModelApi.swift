/*
 * CSSettingModelApi.swift
 * This class is used to create api request for setting Page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
class CSSettingModelApi: NSObject {
    /// Fetch Live Video Api
    class func changePasswordRequest(parentView: AnyObject,
                                     parameters: [String: String]?,
                                     completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .put, path: CHANGEPASSWORD, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Fetch Live Video Api
    class func notificationStatusUpdate(parentView: AnyObject,
                                        parameters: [String: String]?,
                                        completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: NOTIFICATIONSTATUS, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Cancel Subscription API
    class func cancelSubscription(parentView: AnyObject,
                                  completionHandler: @escaping(_ response: CSHomePageDataModel) ->
        Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .delete, path: REMOVESUBSCRIPTION, parameters: nil,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    controller?.showToastMessageTop(message: responseData?.message)
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { error in
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((error?.code)!, description: (error?.localizedDescription)!, parentView: parentView)
        })
    }
}
