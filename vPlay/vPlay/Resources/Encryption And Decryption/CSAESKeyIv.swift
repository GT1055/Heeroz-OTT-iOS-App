/*
 * CSAESKeyIv.swift
 * This class of extesion Sting where AES Encryption and Decription Part key and Iv is Set Here
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
// AES Key And IV Declartion Part
extension String {
    /// Key Value
    func keyValue() -> String {
        let keyData =  Data.init(hexString: AESKEYVALUE)
        return String(data: keyData!, encoding: .utf8)!
    }
    /// iv Value
    func ivValue() -> String {
        let ivData =  Data.init(hexString: AESIVVALUE)
        return String(data: ivData!, encoding: .utf8)!
    }
}
