/*
 * CSVideoDetailApiModel+Extension.swift
 * This class is used to create a Api request for video detail page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
class CSVideoDetailApiModel: NSObject {
    /// Fetch Video Detail
    class func fetchVideoDetailRequest(parentView: AnyObject,
                                       parameters: [String: String]?,
                                       videoId: Int!,
                                       categoryId: String!,
                                       completionHandler: @escaping(_ response: CSVideoDetailMapper) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: VIDEODETAIL + String(videoId) + "/" + categoryId,
            parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSVideoDetailMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
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
            // controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    // Add A Comment to Video
    class func addCommentToVideo(parentView: AnyObject, button: UIButton,
                                 parameters: [String: String]?,
                                 completionHandler: @escaping(_ response: CSCommentMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        button.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: ADDCOMMENT,
            parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                button.isUserInteractionEnabled = true
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCommentMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
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
            button.isUserInteractionEnabled = true
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Add A Reply Comment
    class func addedReplyComment(parentView: AnyObject,
                                 parameters: [String: String]?,
                                 commentId: String,
                                 isPageDisable: Bool!,
                                 completionHandler: @escaping(_ response: CSCommentMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageDisable {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: ADDREPLYCOMMENT + commentId,
            parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCommentMapper>().map(JSONString: content!)
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
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
extension CSVideoDetailApiModel {
    // Add View All Comment
    class func viewAllCommentToVideo(parentView: AnyObject,
                                     parameters: [String: String]?,
                                     isPageDisable: Bool!,
                                     button: AnyObject,
                                     completionHandler: @escaping(_ response: CSCommentMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageDisable {
            controller?.startLoading()
        }
        let buttonView = button as? UIButton
        buttonView?.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: COMMENTLISTING,
            parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                buttonView?.isUserInteractionEnabled = true
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCommentMapper>().map(JSONString: content!)
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
            buttonView?.isUserInteractionEnabled = true
            /// Stop Animating
            controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Get Download URl from Back end
    class func getDownloadURL(
        parentView: AnyObject,
        videoId: String,
        completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        let path = DOWNLOADAPI + videoId
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: path, parameters: nil,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!,
                                     encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                  controller?.showToastMessageTop(message: responseData?.message)
                }
        }, errorOccured: { (errorOccurred) in
            controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        })
    }
    /// Get Download URl from Back end
    class func deleteCommentAction(
        parentView: AnyObject,
        commentId: String,
        completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        let path = ADDCOMMENT + "/" + commentId
        let button = parentView as? UIButton
        button?.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .delete, path: path, parameters: nil,
            completionHandler: { response in
                button?.isUserInteractionEnabled = true
                //Convert my response data to string
                let content = String(data: (response as? Data)!,
                                     encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    controller?.showToastMessageTop(message: responseData?.message)
                }
        }, errorOccured: { _ in
            button?.isUserInteractionEnabled = true
            // controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        })
    }
    
    /// Fetch Xray
    class func fetchXray(parentView: AnyObject,
                            parameters: [String: String]?,
                            videoId: Int,
                            completionHandler: @escaping (_ response: XrayBase) -> Void) {
        /// Start Loader
        _ = parentView as? CSParentViewController
        let path = XRAYAPI + "\(videoId)"
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: path,
            parameters: parameters,
            completionHandler: {(response) in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<XrayBase>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    //Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            //Failure Message
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
