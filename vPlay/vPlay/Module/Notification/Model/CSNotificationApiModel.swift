/*
 * CSNotificationApiModel.swift
 * These class is a API request class for notification Module
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
class CSNotificationApiModel: NSObject {
    /// Set notification to Read Status
    class func markAsRead(parentView: AnyObject, notificationId: String, parameter: [String: Any]?,
                          completionHandler: @escaping(_ responce: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: NOTIFICATIONSINGLEREAD + notificationId,
            parameters: parameter,
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
        }, errorOccured: { error in
            controller?.stopLoading()
            controller?.showToastMessageTop(message: error?.localizedDescription)
        })
    }
    /// Set notification to Read Status
    class func markAllAsRead(parentView: AnyObject, parameter: [String: Any]?,
                             completionHandler: @escaping(_ responce: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: NOTIFICATIONREADALL,
            parameters: parameter,
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
        }, errorOccured: { error in
            controller?.stopLoading()
            controller?.showToastMessageTop(message: error?.localizedDescription)
        })
    }
    /// delete Notification
    class func deleteSingleNotification(parentView: AnyObject,
                                        notificationId: String,
                                        parameter: [String: Any]?,
                                        completionHandler: @escaping(_ responce: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: NOTIFICAIONSINGLECLEAR + notificationId,
            parameters: parameter,
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
        }, errorOccured: { error in
            controller?.stopLoading()
            controller?.showToastMessageTop(message: error?.localizedDescription)
        })
    }
    /// delete Notification
    class func clearAllNotification(parentView: AnyObject,
                                    parameter: [String: Any]?,
                                    completionHandler: @escaping(_ responce: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: NOTIFICAIONCLEARALL,
            parameters: parameter,
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
        }, errorOccured: { error in
            controller?.stopLoading()
            controller?.showToastMessageTop(message: error?.localizedDescription)
        })
    }
    /// Fetch All Notificaiton
    class func listAllNotification(parentView: AnyObject,
                                   isPageing: Bool, parameter: [String: String]?,
                                   completionHandler: @escaping(_ responce: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageing {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: NOTIFICATION,
            parameters: parameter,
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
        }, errorOccured: { error in
            controller?.stopLoading()
            controller?.showToastMessageTop(message: error?.localizedDescription)
        })
    }
}
