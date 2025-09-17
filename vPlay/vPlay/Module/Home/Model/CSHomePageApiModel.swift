/*
 * CSHomePageDataModel.swift
 * This class is used as Api Request Class
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
class CSHomeApiModel: NSObject {
    class func SlugVideoId(parentView: AnyObject,
                              parameters: [String: String]?,
                              slugid: String,
                              completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        print("SLUG ID VALUE")
        let slugArray = slugid.components(separatedBy: "/")
        let slugName = slugArray.last
        print(slugName)
         let controller = parentView as? CSParentViewController
        let controll = controller as? HomePageViewController
        controll?.startSkeletonLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: SLUGVIDEOID+(slugName ?? ""), parameters: parameters,
            completionHandler: { response in
                 controll?.stopSkeletonLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
               // print("Response :\(content as! String)")
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
            controll?.stopSkeletonLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    class func homeApiRequest(parentView: AnyObject,
                              parameters: [String: String]?,
                              completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
         let controller = parentView as? CSParentViewController
        let controll = controller as? HomePageViewController
        controll?.startSkeletonLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: HOMEAPI, parameters: parameters,
            completionHandler: { response in
                 controll?.stopSkeletonLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                print("Response :\(content as! String)")
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
            controll?.stopSkeletonLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    class func homePageMoreApiRequest(parentView: AnyObject,
                              parameters: [String: String]?,
                              buttonObject: Int,
                              completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
         let controller = parentView as? CSParentViewController
        let controll = controller as? HomePageViewController
        controll?.startSkeletonLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: HOMEPAGEMORE+"?category=\(buttonObject)", parameters: parameters,
            completionHandler: { response in
                 controll?.stopSkeletonLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                print("HOMEPAGEMOREResponse :\(content as! String)")
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
            controll?.stopSkeletonLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Home Page Bannar Api
    class func homeBannarApiRequest(parentView: AnyObject,
                                    parameters: [String: String]?,
                                    completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: BANNARHOMEPAGE, parameters: parameters,
            completionHandler: { response in
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
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Add Favourite Video
    class func addFavouriteRequest(parentView: AnyObject,
                                   parameters: [String: String]?,
                                   buttonObject: AnyObject,
                                   completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let button = buttonObject as? UIButton
        button?.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: FAVOURITEAPI, parameters: parameters,
            completionHandler: { response in
                button?.isUserInteractionEnabled = true
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
            button?.isUserInteractionEnabled = true
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Remove Favourite
    class func removeFavouriteRequest(parentView: AnyObject,
                                      parameters: [String: String]?,
                                      buttonObject: AnyObject,
                                      completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let button = buttonObject as? UIButton
        button?.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .put, path: FAVOURITEAPI, parameters: parameters,
            completionHandler: { response in
                button?.isUserInteractionEnabled = true
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
            button?.isUserInteractionEnabled = true
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// follow Play List Request
    class func followPlayListRequest(parentView: AnyObject,
                                     parameters: [String: String]?,
                                     completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: PLAYLISTAPI, parameters: parameters,
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
    /// Remove Play List Request
    class func unfollowPlayListRequest(parentView: AnyObject,
                                       parameters: [String: String]?,
                                       completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .put, path: PLAYLISTAPI, parameters: parameters,
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
extension CSHomeApiModel {
    /// remove Video From history
    class func removeVideoFromHistory(parentView: AnyObject,
                                      parameters: [String: String]?,
                                      completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: REMOVEVIDEOFROMHISTSTORY, parameters: parameters,
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
    /// Like a Video
    class func likeAVideo(parentView: AnyObject,
                          parameters: [String: String]?,
                          buttonObject: AnyObject,
                          completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let button = buttonObject as? UIButton
        button?.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: LIKEAPI, parameters: parameters,
            completionHandler: { response in
                button?.isUserInteractionEnabled = true
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
            button?.isUserInteractionEnabled = true
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Dislike a Video
    class func disLikeAVideo(parentView: AnyObject,
                             parameters: [String: String]?,
                             buttonObject: AnyObject,
                             completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let button = buttonObject as? UIButton
        button?.isUserInteractionEnabled = false
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: DISLIKEAPI, parameters: parameters,
            completionHandler: { response in
                button?.isUserInteractionEnabled = true
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
            button?.isUserInteractionEnabled = true
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
