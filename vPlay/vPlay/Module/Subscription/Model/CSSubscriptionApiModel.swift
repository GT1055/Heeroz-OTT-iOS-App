/*
 * CSSubscriptionApiModel.swift
 * This class is used make request fro the subscription Plan
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper

class CSSubscriptionApiModel: NSObject {
    /// Get Profile Info
    class func showSubscriptionList(parentView: AnyObject,
                                    parameters: [String: String]?,
                                    completionHandler: @escaping(_ response: CSSubscriptionsListMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: SUBSCRIPTIONSLISTING, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSSubscriptionsListMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    var error = Int()
                    if responseData?.responseCode != 0 {
                        error = (responseData?.responseCode)!
                    } else if responseData?.statusCode != 0 {
                        error = (responseData?.statusCode)!
                    }
                    CSErrorHandleBlock.responceErrorHandle(error,
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
}
