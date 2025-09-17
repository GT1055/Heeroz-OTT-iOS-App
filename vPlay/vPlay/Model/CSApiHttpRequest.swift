/*
 * CSApiHttpRequest
 * This class  is used to handle the api request
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import Foundation
import Alamofire
class CSApiHttpRequest: NSObject {
    // MARK: Shared Instance
    static let sharedInstance: CSApiHttpRequest = {
        let instance = CSApiHttpRequest()
        return instance
    }()
    /// Cache policy
    var urlCache: URLCache!
    /// Session Manager
    var manager: SessionManager!
    /// Cache is need or not as a bool variable
    var isCache: Bool!
    /// Time Out Request
    let requestTimeout: TimeInterval = 60
    /// Cache Control
    struct CacheControl {
        static let publicControl = "public"
        static let privateControl = "private"
        static let maxAgeNonExpired = "max-age=60"
        static let maxAgeExpired = "max-age=0"
        static let noCache = "no-cache"
        static let noStore = "no-store"
        static var allValues: [String] {
            return [
                CacheControl.publicControl,
                CacheControl.privateControl,
                CacheControl.maxAgeNonExpired,
                CacheControl.maxAgeExpired,
                CacheControl.noCache,
                CacheControl.noStore
            ]
        }
    }
    /// initalize the cache and Session Manager
    override init() {
        super.init()
        self.setUpCache()
        self.configureSessionManager()
    }
    // Remove Cache
    func removeCache() {
        urlCache?.removeAllCachedResponses()
    }
    //PRAGMA : - Private Methods
    // Setting Up Cache Property
    fileprivate func setUpCache() {
        urlCache = {
            let capacity = 5 * 1024 * 1024 // MBs capacity To 5MBS
            let urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
            return urlCache
        }()
    }
    // Setting up Session Manager
    fileprivate func configureSessionManager() {
        manager = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
                configuration.requestCachePolicy = .useProtocolCachePolicy
                configuration.urlCache = urlCache
                return configuration
            }()
            let manager = SessionManager(configuration: configuration)
            return manager
        }()
    }
    //This method is used to return the static http header
    func httpHeader(path: String) -> [String: String] {
        //Custom headers
        var header: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "X-LANGUAGE-CODE": (CSLanguage.currentAppleLanguage() == "pa-IN") ? "pa" : CSLanguage.currentAppleLanguage(),
            "X-REQUEST-TYPE": "mobile",
            "X-DEVICE-TYPE": "iOS",
            "Accept": "application/json",
            "Referer": REFERER
        ]
        if !LibraryAPI.sharedInstance.getAccessToken().isEmpty {
            header["X-USER-ID"] = LibraryAPI.sharedInstance.getUserId()
            header["Authorization"] = LibraryAPI.sharedInstance.getAccessToken()
        }
        return header
    }
    //Request Generator
    fileprivate func urlRequest(httpMethod: HTTPMethod,
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
        urlRequest.allHTTPHeaderFields = self.httpHeader(path: path)
        do {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        } catch {
            return urlRequest
        }
    }
    //Request Generator
       fileprivate func urlRequestWithoutHeaders(httpMethod: HTTPMethod,
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
           //urlRequest.allHTTPHeaderFields = self.httpHeader(path: path)
           do {
               return try URLEncoding.default.encode(urlRequest, with: parameters)
           } catch {
               return urlRequest
           }
       }
    //This method is used to execute the request and getting the response in completion block and error in error block
    fileprivate func executeRequestWithoutHeaders(_ httpMethod: HTTPMethod,
                                              path: String,
                                              parameters: [String: Any]!,
                                              completionHandler: @escaping (_ response: AnyObject) -> Void,
                                              errorOccured: @escaping (_ error: NSError?) -> Void) {
        /// Cache Request Formation
        let urlRequest: URLRequest = self.urlRequestWithoutHeaders(httpMethod: httpMethod,
                                                     path: path,
                                                     parameterSet: parameters,
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
    //This method is used to execute the request and getting the response in completion block and error in error block
    fileprivate func executeRequestWithMethod(_ httpMethod: HTTPMethod,
                                              path: String,
                                              parameters: [String: Any]!,
                                              completionHandler: @escaping (_ response: AnyObject) -> Void,
                                              errorOccured: @escaping (_ error: NSError?) -> Void) {
        /// Cache Request Formation
        let urlRequest: URLRequest = self.urlRequest(httpMethod: httpMethod,
                                                     path: path,
                                                     parameterSet: parameters,
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
    //PRAGMA :- Public Methods
    // Execute request with Cache Method
    func executeRequestWithCache(httpMethod: HTTPMethod,
                                 path: String,
                                 parameters: [String: Any]!,
                                 completionHandler: @escaping (_ response: AnyObject) -> Void,
                                 errorOccured: @escaping (_ error: NSError?) -> Void) {
        isCache = true
        self.executeRequestWithMethod(httpMethod,
                                      path: path, parameters: parameters,
                                      completionHandler: completionHandler,
                                      errorOccured: errorOccured)
    }
    // Execute Request with no cache
    func executeRequestWithMethod(httpMethod: HTTPMethod,
                                  path: String,
                                  parameters: [String: Any]!,
                                  completionHandler: @escaping (_ response: AnyObject) -> Void,
                                  errorOccured: @escaping (_ error: NSError?) -> Void) {
        isCache = false
        self.executeRequestWithMethod(httpMethod,
                                      path: path,
                                      parameters: parameters,
                                      completionHandler: completionHandler,
                                      errorOccured: errorOccured)
    }
    // Execute Request with no cache
    func executeRequestWithoutHeaders(httpMethod: HTTPMethod,
                                  path: String,
                                  parameters: [String: Any]!,
                                  completionHandler: @escaping (_ response: AnyObject) -> Void,
                                  errorOccured: @escaping (_ error: NSError?) -> Void) {
        isCache = false
        self.executeRequestWithoutHeaders(httpMethod,
                                      path: path,
                                      parameters: parameters,
                                      completionHandler: completionHandler,
                                      errorOccured: errorOccured)
    }
    func cancelRequest(_ path: String) {
        let baseUrl = BASEURL + path
        let url = URL(string: baseUrl)!
        manager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach {
                if $0.originalRequest?.url == url {
                    $0.cancel()
                }
            }
        }
    }
}
class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
