//
//  CSCategoryApiModel.swift
//  vPlay
//
//  Created by user on 31/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import ObjectMapper
class CSCategoryApiModel: NSObject {
    class func getCategoryList(parentView: AnyObject,
                               parameters: [String: String]?,
                               completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: CATEGORYLISTAPI, parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle(responseData?.statusCode ?? 0,
                                                           description: responseData?.message ?? "",
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    class func getCategoryVideoList(parentView: AnyObject,
                                    parameters: [String: String]?,
                                    isPaging: Bool,
                                    completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: CATEGORYBASEDVIDEOAPI, parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle(responseData?.statusCode ?? 0,
                                                           description: responseData?.message ?? "",
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    class func getCategoryMoreVideoList(parentView: AnyObject,
                                        parameters: [String: String]?,
                                        isPaging: Bool,
                                        completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: CATEGORYMOREVIDEOAPI, parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle(responseData?.statusCode ?? 0,
                                                           description: responseData?.message ?? "",
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
