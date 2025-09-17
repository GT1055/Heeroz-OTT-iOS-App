/*
 * CSAESDecryption.swift
 * This class of extesion Sting where AES Decription is handled
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import CryptoSwift
extension String {
    /// aes Decrypt Base
    func aesDecryptBase64String() -> String {
        do {
            // AES-256 Encryption is Done with using CBC
            // key Should of 32 Characters and iv Should of 16 Characters
            let hexaData = Data.init(hexString: self)
            let aes = try AES(key: keyValue(), iv: ivValue(), padding: .zeroPadding)
            let ciphertext = try aes.decrypt(hexaData!.bytes)
            let ciperData = Data(bytes: ciphertext, count: ciphertext.count)
            let cipherString = String(data: ciperData, encoding: .utf8)
            return cipherString!
        } catch {
            return String()
        }
    }
    /// Double Aes Decrpyt String
    func aesDoubleDecrypString() -> String {
        do {
            // Hexa To String Convertion
            let encryptedData = Data.init(hexString: self)
            let encryptHexaString = String(data: encryptedData!, encoding: .utf8)
            /// Hexa String to Bytes
            let encryptHexaData = Data(base64Encoded: encryptHexaString!)!
            // AES-256 Decryption is Done with using CBC
            // key Should of 32 Characters and iv Should of 16 Characters
            let aes = try AES(key: keyValue(), iv: ivValue(), padding: .zeroPadding)
            let decryptedBytes = try aes.decrypt(encryptHexaData.bytes)
            /// Convert cipher Bytes to Data and Convert To normal String without any base64 convertion
            /// which gives hexa decimal string with some Unicode
            let decryptedData = Data(bytes: decryptedBytes, count: decryptedBytes.count)
            let decryptedHexaStringWithUnicode = String(data: decryptedData, encoding: .utf8)!
            /// Remove Unicode From Hexa String in swift
            let decryptedHexaString = decryptedHexaStringWithUnicode.trimmingCharacters(in:
                CharacterSet.alphanumerics.inverted)
            /// Hexa Data to Required decrypted String
            let decryptedHexaData = Data.init(hexString: decryptedHexaString)
            let decryptedString = String(data: decryptedHexaData!, encoding: .utf8)
            return decryptedString!
        } catch {
            return String()
        }
    }
}
