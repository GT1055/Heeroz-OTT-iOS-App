/*
 * EPGApiModel.swift
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

class EPGApiModel: NSObject {
    class func loadJson(filename fileName: String) -> CSVideoDetailMapper? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let content = String(data: (data), encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSVideoDetailMapper>().map(JSONString: content!)
                return responseData!

            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    class func getprogrameList(parentView: AnyObject,
                            parameters: [String: String]?,
                            completionHandler: @escaping(_ response: CSVideoDetailMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        controller?.startLoading()
//        let data = EPGApiModel.loadJson(filename: "StaticEPGJson")
//        completionHandler(data!)
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: EPGGUIDE, parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSVideoDetailMapper>().map(JSONString: content!)
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
    
    class func getCatogoryList(parentView: AnyObject,
                                parameters: [String: String]?,
                                completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
            let controller = parentView as? CSParentViewController
            controller?.startLoading()
    
            CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
                httpMethod: .get, path: EPGCATEGORY, parameters: parameters,
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
                        controller?.showToastMessageTop(message: responseData?.message)
                    }
            }, errorOccured: { (errorOccurred) in
                /// Stop Animating
                controller?.stopLoading()
                controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
            })
        }
    
    class func getFilteredEPGList(parentView: AnyObject,
                                parameters: [String: String]?,
                                completionHandler: @escaping(_ response: CSVideoDetailMapper) -> Void) {
            let controller = parentView as? CSParentViewController
            controller?.startLoading()
    
            CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
                httpMethod: .post, path: EPGFILTER, parameters: parameters,
                completionHandler: { response in
                    controller?.stopLoading()
                    //Convert my response data to string
                    let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                    //call the the object mapper
                    let responseData = Mapper<CSVideoDetailMapper>().map(JSONString: content!)
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
    
    
}
