/*
 * CSApiHttpRequest
 * This class  is used to handle the api request
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import Alamofire
extension CSApiHttpRequest {
    //This method is used to return the static http header
    fileprivate func httpHeaderJson(path: String) -> [String: String] {
        //Custom headers
        var header: [String: String] = [
            "Content-Type": "application/json",
            "X-LANGUAGE-CODE": CSLanguage.currentAppleLanguage(),
            "X-REQUEST-TYPE": "mobile",
            "X-DEVICE-TYPE": "iOS",
            "Referer": REFERER
        ]
        if !LibraryAPI.sharedInstance.getAccessToken().isEmpty {
            header["X-USER-ID"] = LibraryAPI.sharedInstance.getUserId()
            header["Authorization"] = LibraryAPI.sharedInstance.getAccessToken()
        }
        return header
    }
    //Request Generator
    fileprivate func urlJsonRequest(httpMethod: HTTPMethod,
                                    path: String,
                                    parameterSet: [String: Any]!,
                                    cache: Bool) -> URLRequest {
        var parameters = [String: Any]()
        if parameterSet != nil {
            parameters = parameterSet
        }
        let baseUrl = BASEURL + path
        let url = URL(string: baseUrl)!
        var urlRequest: URLRequest!
        if cache {
            urlRequest = URLRequest(url: url,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: requestTimeout)
        } else {
            urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalCacheData,
                                    timeoutInterval: requestTimeout)
        }
        ///cache contol parameters
        parameters["Cache-Control"] = CacheControl.publicControl
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = self.httpHeaderJson(path: path)
        do {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        } catch {
            return urlRequest
        }
    }
    // Put method For prefrenc order an delete call api
    func executeJsonRequestWithMethod(httpMethod: HTTPMethod,
                                      path: String,
                                      parameter: [String: String]!,
                                      completionHandler: @escaping (_ response: AnyObject) -> Void,
                                      errorOccured: @escaping (_ error: NSError?) -> Void) {
        /// Cache Request Formation
        let urlRequest: URLRequest = self.urlJsonRequest(httpMethod: httpMethod,
                                                         path: path,
                                                         parameterSet: parameter,
                                                         cache: isCache)
        let request = manager.request(urlRequest)
        request.validate(statusCode: 200..<500)
        request.responseJSON { response in
            // Setting network activity Indicator to hide
            #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            #endif
            switch response.result {
            case .success :
                if response.result.value != nil {
                    // send to completion block
                    completionHandler(response.data as AnyObject? ?? NSData())
                }
            case .failure(let error):
                // sending to failure block
                errorOccured(error as NSError?)
            }
        }
    }
    /// Profile Image Upload
    func profileImageUpLoad(path: String,
                            profileImage: UIImage?,
                            parameter: [String: Any]!,
                            completion: @escaping (_ response: AnyObject) -> Void,
                            errorOccured: @escaping (_ error: NSError?) -> Void) {
        // setting network activity Indicator to visible
        #if os(iOS)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        #endif
        // call Api bu alamofire library Base URL is default Url and append Url is the method or action used in api call
        let alamofireSession = Alamofire.SessionManager.default
        alamofireSession.session.configuration.timeoutIntervalForRequest = requestTimeout
        alamofireSession.upload( multipartFormData: { multipartFormData in
            for (key, value) in parameter {
                multipartFormData.append((value as AnyObject).data(using:
                    String.Encoding.utf8.rawValue)!, withName: key)
            }
            multipartFormData.append(profileImage?.jpegData(compressionQuality: 0.5) ?? Data(),
                                     withName: "profile_picture",
                                     fileName: "image.jpeg",
                                     mimeType: "image/jpeg")
        }, to: BASEURL + path, method: .post, headers: self.httpHeader(path: path),
           encodingCompletion: { (result) in
            // setting network activity Indicator to hide
            #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            #endif
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    // send to completion block
                    completion(response.data as AnyObject? ?? NSData())
                }
            case .failure(let encodingError):
                // sending to failure block
                errorOccured(encodingError as NSError?)
            }
        })
    }
    /// Profile Image Upload
    func getDataFromM3U8(path: String,
                         completion: @escaping (_ response: AnyObject) -> Void,
                         errorOccured: @escaping (_ error: NSError?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let alamofireSession = Alamofire.SessionManager.default
        alamofireSession.session.configuration.timeoutIntervalForRequest = requestTimeout
        alamofireSession.request(path).response { response in // method defaults to `.get`
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if response.error == nil {
                // send to completion block
                completion(response.data as AnyObject? ?? NSData())
            } else {
                // sending to failure block
                errorOccured(response.error as NSError?)
            }
        }
    }
}
