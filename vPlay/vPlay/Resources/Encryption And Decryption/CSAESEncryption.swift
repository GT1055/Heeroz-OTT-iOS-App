/*
 * CSAESEncryption.swift
 * This class of extesion Sting where AES Encrypted is handled
 * @category   vPlay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */
import Foundation
import CryptoSwift
extension String {
    /// aes Encrypted Base
    func aesEncryptedBase64String() -> String {
        do {
            let newString = self
            // AES-256 Encryption is Done with using CBC
            // key Should of 32 Characters and iv Should of 16 Characters
            let aes = try AES(key: keyValue(), iv: ivValue())
            let ciphertext = try aes.encrypt(Array(newString.utf8))
            return ciphertext.toHexString()
        } catch {
            return String()
        }
    }
    /// Double Encrypted String
    func aesDoubleEncryptedString() -> String {
        do {
            /// String To Hexa
            let decryptedData = Data(self.utf8)
            let decryptedHexString = decryptedData.map {String(format: "%02x", $0)}.joined()
            // AES-256 Encryption is Done with using CBC
            // key Should of 32 Characters and iv Should of 16 Characters
            let aes = try AES(key: keyValue(), iv: ivValue())
            let encryptedBytes = try aes.encrypt(Array(decryptedHexString.utf8))
            let encryptBase64String = encryptedBytes.toBase64()
            /// Convert Base 64 To Hexa
            let encryptedData = Data(encryptBase64String!.utf8)
            let encryptedHexStringWithUnicode = encryptedData.map {String(format: "%02x", $0)}.joined()
            /// Remove Unicode from hexa String
            let encryptedHexString = encryptedHexStringWithUnicode.trimmingCharacters(in:
                CharacterSet.alphanumerics.inverted)
            return encryptedHexString
        } catch {
            return String()
        }
    }
}
