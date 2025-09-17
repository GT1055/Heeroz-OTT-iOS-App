/*
 * CSCardApiModel.swift
 * This class  is used create Api request
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import UIKit
import ObjectMapper
class CSCardApiModel: NSObject {
    //     fetch user data
    //    - Parameters:
    //    - parentView: self
    //    - parameters: parameters give as dictionary
    //    - completionHandler: response
    class func addCardApi(parentView: AnyObject,
                          parameters: [String: String]?,
                          completionHandler: @escaping (_ response: CSCardModel) -> Void) {
        /// Start Loader
        let parentViewController = parentView as? CSParentViewController
        parentViewController?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post,
            path: CARDCREATED,
            parameters: parameters,
            completionHandler: {(response) in
                parentViewController?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCardModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    parentViewController?.showSuccessToastMessage(message: (responseData?.message)!)
                    completionHandler(responseData!)
                } else {
                    /// stop loader
                    parentViewController?.stopLoading()
                    //Failure Message
                    // Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            //Failure Message
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    //     fetch user data
    //    - Parameters:
    //    - parentView: self
    //    - parameters: parameters give as dictionary
    //    - completionHandler: response
    class func fetchCardApi(parentView: AnyObject,
                            parameters: [String: String]?,
                            completionHandler: @escaping (_ response: CSCardModel) -> Void) {
        /// Start Loader
        let parentViewController = parentView as? CSParentViewController
        parentViewController?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .get,
            path: CARDCREATED,
            parameters: parameters,
            completionHandler: {(response) in
                parentViewController?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCardModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    /// stop loader
                    parentViewController?.stopLoading()
                    //Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            //Failure Message
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    //     fetch user data
    //    - Parameters:
    //    - parentView: self
    //    - parameters: parameters give as dictionary
    //    - completionHandler: response
    class func deletCardApi(parentView: AnyObject,
                            parameters: [String: String]?,
                            completionHandler: @escaping (_ response: CSCardModel) -> Void) {
        /// Start Loader
        let parentViewController = parentView as? CSParentViewController
        parentViewController?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .delete,
            path: CARDCREATED,
            parameters: parameters,
            completionHandler: {(response) in
                parentViewController?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCardModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    /// stop loader
                    parentViewController?.stopLoading()
                    //Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            //Failure Message
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    //     fetch user data
    //    - Parameters:
    //    - parentView: self
    //    - parameters: parameters give as dictionary
    //    - completionHandler: response
    class func makePaymentApi(parentView: AnyObject,
                              parameters: [String: String]?,
                              completionHandler: @escaping (_ response: CSCardModel) -> Void) {
        /// Start Loader
        let parentViewController = parentView as? CSParentViewController
        parentViewController?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post,
            path: MAKEPAYMENT,
            parameters: parameters,
            completionHandler: {(response) in
                parentViewController?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCardModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    /// stop loader
                    parentViewController?.stopLoading()
                    //Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            //Failure Message
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
    //     fetch user data
    //    - Parameters:
    //    - parentView: self
    //    - parameters: parameters give as dictionary
    //    - completionHandler: response
    class func transPaymentApi(parentView: AnyObject,
                              parameters: [String: String]?,
                              completionHandler: @escaping (_ response: CSCardModel) -> Void) {
        /// Start Loader
        let parentViewController = parentView as? CSParentViewController
        parentViewController?.startLoading()
        CSApiHttpRequest.sharedInstance.executeRequestWithMethod(
            httpMethod: .post,
            path: TRANSACTIONPAYMENT,
            parameters: parameters,
            completionHandler: {(response) in
                parentViewController?.stopLoading()
                //Convert my response data to string
                let content = String(data: (response as? Data)!, encoding: String.Encoding.utf8)
                //call the the object mapper
                let responseData = Mapper<CSCardModel>().map(JSONString: content!)
                if responseData?.statusCode == SUCCESSCODE {
                    completionHandler(responseData!)
                } else {
                    /// stop loader
                    parentViewController?.stopLoading()
                    //Failure Message
                    CSErrorHandleBlock.responceErrorHandle((responseData?.statusCode)!,
                                                           description: (responseData?.message)!,
                                                           parentView: parentView)
                }
        }, errorOccured: { (errorOccurred) in
            //Failure Message
            CSErrorHandleBlock.requestErrorHandle((errorOccurred?.code)!,
                                                  description: (errorOccurred?.localizedDescription)!,
                                                  parentView: parentView)
        })
    }
}
