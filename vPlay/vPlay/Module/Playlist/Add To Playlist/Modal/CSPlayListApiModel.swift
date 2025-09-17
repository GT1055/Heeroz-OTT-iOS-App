/*
 * CSPlayListApiModel.swift
 * This cell is used create A Api request
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
class CSPlayListApiModel: NSObject {
    /// Play list Video
    class func fetchPlayListVideo(parentView: AnyObject,
                                  parameters: [String: String]?,
                                  isPageDisable: Bool,
                                  completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageDisable {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: PLAYLISTVIDEO, parameters: parameters,
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
    /// Play list Video Delete
    class func deletePlayListVideo(parentView: AnyObject,
                                   parameters: [String: String]?,
                                   completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .delete, path: PLAYLISTVIDEO, parameters: parameters,
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
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Create a playlist Edit a playlist and add A Song to Playlist
    class func createEditAndAddPlayListVideo(parentView: AnyObject,
                                             parameters: [String: String]?,
                                             completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: CREATEADDANDEDIT, parameters: parameters,
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
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Delete a playlist
    class func deletePlayList(parentView: AnyObject,
                              parameters: [String: String]?,
                              completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .delete, path: CREATEADDANDEDIT, parameters: parameters,
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
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// PlayList Api
    class func playListingApi(parentView: AnyObject,
                              isPageDisable: Bool,
                              parameters: [String: String]?,
                              completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageDisable {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: CREATEADDANDEDIT, parameters: parameters,
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
}
