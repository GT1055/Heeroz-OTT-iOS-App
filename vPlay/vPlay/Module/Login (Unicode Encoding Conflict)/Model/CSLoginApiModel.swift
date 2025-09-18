/*
 * CSLoginApiModel.swift
 * This class is used as To create a Api request
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
import Alamofire
class CSLoginApiModel: NSObject {
    class func loginRequest(parentView: AnyObject,
                            parameters: [String: String]?,
                            completionHandler: @escaping(_ response: CSLoginMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: LOGINAPI, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLoginMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    controller?.showToastMessageTop(message: responseData?.message)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        })
    }
    /// Register Api
    class func signUpRequest(parentView: AnyObject,
                             parameters: [String: String]?,
                             completionHandler: @escaping(_ response: CSLoginMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: REGISTERAPI, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLoginMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    controller?.showToastMessageTop(message: responseData?.message)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            
            controller?.stopLoading()
            controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
       })
    }
    /// Forgot Password Api
    class func forgotPasswordRequest(parentView: AnyObject,
                                     parameters: [String: String]?,
                                     completionHandler: @escaping(_ response: CSLoginMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: FORGOTPASSWORD, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLoginMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    var error = Int()
                    if responseData?.responseCode != 0 {
                        error = (responseData?.responseCode)!
                    } else if responseData?.statusCode != 0 {
                        error = (responseData?.statusCode)!
                    }
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle(error,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        })
    }
}
/// Api Called in menu
class CSMenuApiModel: NSObject {
    /// Logout The Current User
    class func logoutApi(parentView: AnyObject,
                         parameters: [String: String]?,
                         completionHandler: @escaping(_ response: CSLoginMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: LOGOUTAPI, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLoginMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    var error = Int()
                    if responseData?.responseCode != 0 {
                        error = (responseData?.responseCode)!
                    } else if responseData?.statusCode != 0 {
                        error = (responseData?.statusCode)!
                    }
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle(error,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        })
    }
}
