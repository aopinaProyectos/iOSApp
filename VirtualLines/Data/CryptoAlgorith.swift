//
//  CryptoManager.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import CryptoSwift

struct Crypto {
    
    func encrypt(value: String) -> String {
        let key = "FDJ#3$MFV92343M;"
        let iv = "gqLOHUioQ0QjhuvI"
        var result = ""
        do {
            let data = value.data(using: .utf8)!
            let aes = try! AES(key: key, iv: iv, padding: Padding.pkcs7)
            let encrypted = try aes.encrypt(data.bytes)
            let encryptedData = Data(encrypted)
            result = encryptedData.base64EncodedString()
        }catch {
            print("Failed")
            print(error)
            return ""
        }
        return result
    }
    
    func decrypt(value: String) -> String {
        let key = "FDJ#3$MFV92343M;"
        let iv = "gqLOHUioQ0QjhuvI"
        var result = ""
        let encryptedData = NSData(base64Encoded: value, options:[])!
        print("decodedData: \(encryptedData)")
        let count = encryptedData.length / MemoryLayout<UInt8>.size
        var encrypted = [UInt8](repeating: 0, count: count)
        encryptedData.getBytes(&encrypted, length:count * MemoryLayout<UInt8>.size)
        do {
            let decryptedData = try! AES(key: key, iv: iv, padding: Padding.pkcs7).decrypt(encrypted)
            let decryptedString = String(bytes: decryptedData, encoding: String.Encoding.utf8)!
            print("decryptedString: \(decryptedString)")
            result = decryptedString
        } catch {
            print("Failed")
            print(error)
            return ""
        }
        return result
    }
    
}
