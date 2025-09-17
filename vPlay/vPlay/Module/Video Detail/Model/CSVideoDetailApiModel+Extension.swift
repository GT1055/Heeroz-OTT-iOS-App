/*
 * CSVideoDetailApiModel+Extension.swift
 * This class is used to create a Api request for video detail page
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import ObjectMapper

extension CSVideoDetailApiModel {
    // fetch Recent and Trending
    class func fetchRecentAndTrending(parentView: AnyObject,
                                      parameters: [String: String]?,
                                      isPageDisable: Bool!,
                                      completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageDisable {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: HOMEPAGEMOREAPI,
            parameters: parameters,
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
    // fetch related Videos
    class func fetchRelatedVideo(parentView: AnyObject,
                                 parameters: [String: String]?,
                                 isPageDisable: Bool!,
                                 completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? CSParentViewController
        if isPageDisable {
            controller?.startLoading()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: RECENTANDTRENDINGVIDEO,
            parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
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
    // Track Video
    class func trackVideo(parentView: AnyObject,
                          parameters: [String: String]?,
                          videoId: String,
                          completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: WATCHHISTORY + videoId,
            parameters: parameters,
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
        }, errorOccured: { _ in })
    }
    class func newTrackVideo(_ parentView: AnyObject,
                             parameters: [String: String]?,
                             completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: NEWWATCHHISTORY,
            parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { _ in })
    }
    class func watchTimeAPI(_ parentView: AnyObject,
                             parameters: [String: Any]?,
                             completionHandler: @escaping(_ response: CSHomePageDataModel) -> Void) {
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: WATCHTIME,
            parameters: parameters,
            completionHandler: { response in
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { _ in })
    }

    // setPlayerUrl
    /// - Parameters:
    ///   - parentView: Any object
    ///   - parameters: parameters that are passed for function
    ///   - completionHandler: calling API while complted function
    class func setPlayerUrlResolution(parentView: AnyObject,
                                      url: String,
                                      completionHandler: @escaping (_ response: [Any]) -> Void) {
        /// Start Loader
        let parentViewController = parentView as? CSParentViewController
        /// Rechability
        if !Connectivity.isConnectedToInternet() {
            parentViewController?.addChildView(identifier: "CSNoInternet", storyBoard: alertStoryBoard)
            return
        }
        /// If URl is not valade
        if !url.validateNotEmpty() {
            parentViewController?.addChildView(identifier: "CSVideoNotAvailable",
                                               storyBoard: alertStoryBoard)
            return
        }
        //Get Response
        CSApiHttpRequest.sharedInstance.getDataFromM3U8(
            path: url, completion: { responce in
                //Convert my response data to string
                let content = String(data: (responce as? Data)!, encoding: String.Encoding.utf8)
                completionHandler(CSVideoDetailApiModel.setPlayerUrlFromation(content!,
                                                                              videoUrl: url))
                
        }, errorOccured: {(errorOccurred) in
            parentViewController?.showToastMessageTop(message: errorOccurred?.localizedDescription)
        })
    }
    /// Seperation Of Video URL Formates
    /// - Parameter responseString: responce as String
    /// - Returns: Returns Responce Dictinoary
    class func setPlayerUrlFromation(_ responseString: String, videoUrl: String) -> [Any] {
        var fullArray = [Dictionary<String, Any>]()
        var val = (responseString.components(separatedBy: "RESOLUTION="))
        val.removeFirst()
        var datalist = [Any]()
        let urlString: String = (URL(string: videoUrl)?.deletingLastPathComponent().absoluteString)!
        for index in 0..<val.count {
            let resolutionVariable = val[index].components(separatedBy: "X-STREAM-INF:")
            //Split based on Resolution
            let splitValue = resolutionVariable[0]
            let splitValues = splitValue.components(separatedBy: ",")
            ///Split Based on Url
            let resolutionval = splitValues.last?.components(separatedBy: "\n")
            let resolutionvals = resolutionval?[1].components(separatedBy: ",")
            //Split Based on "X"
            let resolution = splitValues[0]
            let resolutions = resolution.components(separatedBy: "x")
            if (Int("\(resolutions[1])") ?? 0) < 2000 {
                var fullDictionary = [String: Any]()
                fullDictionary["quality"] = "\(resolutions[1])p"
                let selectedURL = (resolutionvals?.first)!
                let formedURL = "\(urlString)" + "\(selectedURL)"
                fullDictionary["url"] = formedURL
                fullDictionary["type"] = Int("\(resolutions[1])")
                fullArray.append(fullDictionary)
            }
        }
        var sortedArray = (fullArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "type", ascending: false)]) as! [[String: Any]]
        var firstDict = [String: Any]()
        firstDict["quality"] = "Auto"
        firstDict["url"] = videoUrl
        firstDict["type"] = 0
        sortedArray.insert(firstDict, at: 0)
        for index in 0..<sortedArray.count {
            let selectedDict = sortedArray[index]
            let quality = selectedDict["quality"] as! String
            let url = selectedDict["url"] as! String
            let data = CSVideoUrlResponse.init(quality: quality,
                                               resulotionUrl: url)
            datalist.append(data)
        }
        return datalist
    }
    /// Web series Season Related
    class func webseriesSeasonBasedRelated(parentView: AnyObject,
                                           path: String,
                                           isPageDisable: Bool!,
                                           parameters: [String: String],
                                           completionHandler: @escaping (_ response: CSHomePageDataModel) -> Void) {
        let controller = parentView as? UICollectionView
        if isPageDisable {
            controller?.startAnimating()
        }
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get, path: SEASONLIST + path,
            parameters: parameters,
            completionHandler: { response in
                controller?.stopAnimating()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSHomePageDataModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    controller?.stopAnimating()
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { _ in
            controller?.stopAnimating()
        })
    }
    /// VIEWCOUNT
    class func viewCountApi(parentView: AnyObject,
                                           parameters: [String: Any],
                                           completionHandler: @escaping (_ response: CSVideoCountlMapper) -> Void) {
        let controller = parentView as? CSParentViewController
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post, path: VIEWCOUNT,
            parameters: parameters,
            completionHandler: { response in
                controller?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSVideoCountlMapper>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    controller?.stopLoading()
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccured) in
            let videoDetail = controller as? CSVideoDetailViewController
            videoDetail?.playerView.pause()
            videoDetail?.callApi()
            videoDetail?.expiryAlert()
            controller?.stopLoading()
        })
    }
}
