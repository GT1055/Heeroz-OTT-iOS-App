//
//  CSWebseriesPageApiModel.swift
//  vPlay
//
//  Created by user on 09/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import ObjectMapper
class CSWebseriesDetailApiModel: NSObject {
    /// Webseries Detail
    class func fetchWebseriesDetailRequest(parentView: AnyObject,
                                       parameters: [String: String]?,
                                       videoId: Int,
                                       completionHandler: @escaping(_ response: CSWebSeries) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: WEBSERIES + String(videoId),
            parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSWebSeries>().map(JSONString: content!)
                // unwrapping response
                if let response = responseData {
                    if response.statusCode == STATUSCODE {
                        completionHandler(response)
                    } else {
                        CSErrorHandleBlock.responceErrorHandle(response.statusCode,
                                                               description: response.message,
                                                               parentView: parentView)
                    }
                }
        }, errorOccured: { (errorOccurred) in
            /// Stop Animating
            // controller?.stopLoading()
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
