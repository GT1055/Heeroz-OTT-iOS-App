/*
 * CSElasticSearchApiModel.swift
 * This class is used to create api request for search page Api
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
class CSElasticSearchApiModel: NSObject {
    /// Get Search Elastic Search Data
    class func getElasticSearchData(parentView: AnyObject,
                                    parameters: [String: String]?,
                                    completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        let searchController = controller as? CSElasticSearchViewController
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: ELASTICSEARCH, parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    if (searchController?.searchBar.text!.trim().count ?? 0) < 1 {
                        searchController?.noResultView.isHidden = true
                        searchController?.searchTable.isHidden = true
                        return
                    }
                    if responseData!.searchPage.currentPage == 1,
                        responseData!.searchPage.movieList.count < 1,
                        (searchController?.searchBar.text!.trim().count ?? 0) > 1 {
                        searchController?.noResultView.isHidden = false
                        searchController?.searchTable.isHidden = true
                    } else {
                        searchController?.noResultView.isHidden = true
                        searchController?.searchTable.isHidden = false
                        completionHandler(responseData!)
                    }
                } else {
                    if responseData?.statusCode == 422 {
                        searchController?.searchTable.isHidden = true
                        searchController?.noResultView.isHidden = true
                    }
                }
        }, errorOccured: { (errorOccurred) in
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
