/*
 * CSProfileApiModel.swift
 * This controller is used to create api request
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
class CSProfileApiModel: NSObject {
    /// Get Profile Info
    class func showProfileInfo(parentView: AnyObject,
                               parameters: [String: String]?,
                               completionHandler: @escaping(_ response: CSProfileMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: PROFILEINFO, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSProfileMapper>().map(JSONString: content!)
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
    /// Update Profile Info
    class func updateProfileInfoData(parentView: AnyObject,
                                     parameters: [String: String]?,
                                     completionHandler: @escaping(_ response: CSLoginMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: UPDATEPROFILEINFO, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLoginMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    controller?.showSuccessToastMessage(message: responseData?.message)
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
    /// Update Profile Info
    class func updateImageProfileInfoData(parentView: AnyObject,
                                          profileImage: UIImage,
                                          parameters: [String: String]?,
                                          completionHandler: @escaping(_ response: CSLoginMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        /// Rechability
        if !Connectivity.isConnectedToInternet() {
            controller?.addChildView(identifier: noInternet, storyBoard: alertStoryBoard)
            return
        }
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.profileImageUpLoad(
            path: UPDATEPROFILEINFO, profileImage: profileImage, parameter: parameters,
            completion: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLoginMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    controller?.showSuccessToastMessage(message: responseData?.message)
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
