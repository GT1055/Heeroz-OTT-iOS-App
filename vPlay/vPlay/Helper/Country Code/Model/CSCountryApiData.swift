/*
 * CSCountryApiData.swift
 * @category
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
class CSCountryApiData: NSObject {
    class func fetchCountryData(parentView: AnyObject,
                                completionHandler: @escaping(_ responce: [CSCountryList]) -> Void) {
        let controller = parentView as? CSParentViewController
        guard let path =  Bundle.main.path(forResource: "countries", ofType: "json") else { return }
        let filePath = URL.init(fileURLWithPath: path)
        controller?.startLoading()
        let data = try? Data(contentsOf: filePath)
        do {
            let parsedObject = try JSONSerialization.jsonObject(
                with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let countryList = Mapper<CSCountryList>().mapArray(JSONObject: parsedObject)
            controller?.stopLoading()
            completionHandler(countryList!)
        } catch {
            controller?.stopLoading()
        }
    }
}
