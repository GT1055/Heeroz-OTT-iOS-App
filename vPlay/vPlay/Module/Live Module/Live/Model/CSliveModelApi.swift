/*
 * CSliveModelApi.swift
 * This class is used a api request class for live view controller
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
class CSliveModelApi: NSObject {
    /// Fetch Live Video Api
    class func fetchLiveVideosRequest(parentView: AnyObject,
                                      parameters: [String: String]?,
                                      completionHandler: @escaping(_ response: CSliveMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        let controll = controller as? HomePageViewController
        controll?.startSkeletonLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: LIVEAPI, parameters: parameters,
            completionHandler: { response in
                controll?.stopSkeletonLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSliveMapper>().map(JSONString: content!)
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
            controll?.stopSkeletonLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    /// Fetch Live View More Video Api
    class func fetchMoreLiveVideosRequest(parentView: AnyObject,
                                          parameters: [String: String]?,
                                          isPageDisable: Bool!,
                                          completionHandler: @escaping(_ response: CSliveMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        if !isPageDisable {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: LIVEMOREAPI, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSliveMapper>().map(JSONString: content!)
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
    /// Fetch Live View More Video Api
    class func fetchLiveVideoDetailRequest(parentView: AnyObject,
                                           parameters: [String: String]?,
                                           categoryId: Int!,
                                           completionHandler: @escaping(_ response: CSLiveDetailsMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: VIDEODETAIL + String(categoryId) + "/0", parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSLiveDetailsMapper>().map(JSONString: content!)
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
