//
//  CSPurchaseListApiModel.swift
//  vPlay
//
//  Created by user on 12/07/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class CSPurchaseListApiModel: NSObject {
    class func fetchPurchasedVideos(parentView: AnyObject,
                                    isPageing: Bool,
                                    parameters: [String: String]?,
                                    completionHandler: @escaping(_ response: PurchaseListMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageing {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(httpMethod: .post, path: PURCHASELIST, parameters: parameters, completionHandler: { (response) in
            controller?.stopLoading()
            let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
            let responseData = Mapper<PurchaseListMapper>().map(JSONString: content!)
            if responseData?.statusCode == SUCCESSCODE {
                completionHandler(responseData!)
            } else {
                controller?.showToastMessageTop(message: responseData?.message)
            }
        }) { (errorOccurred) in
            controller?.stopLoading()
            controller?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        }
        
    }
    
}
