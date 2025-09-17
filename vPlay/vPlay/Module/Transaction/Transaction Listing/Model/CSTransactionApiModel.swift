//
//  CSTransactionApiModel.swift
//  These class is a API model for Transaction history
//  vPlay
//
//  Created by user on 29/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import ObjectMapper
class CSTransactionApiModel: NSObject {
    /// Fetch All Notificaiton
    class func listAllTransaction(parentView: AnyObject,
                                  isPageing: Bool,
                                  parameter: [String: String],
                                  completionHandler: @escaping(_ responce: CSTransactionMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageing {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post,
            path: TRANSACTIONLIST,
            parameters: parameter,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSTransactionMapper>().map(JSONString: content!)
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
            CSErrorHandleBlock.requestErrorHandle((error?.code)!,
                                                  description: (error?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
