//
//  Crypt.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation
import CommonCrypto

public struct Crypt {
    
    public static func encrypt(string: String) -> String {
        if let data = string.data(using: .utf8), let keyData = "QWERC16017BQ6556JGL2A#SHC!QABUZZ".data(using: .utf8) {
            let paddingSize = kCCBlockSizeAES128 - (data.count % kCCBlockSizeAES128)
            let dataLength = data.count + paddingSize
            var bytes = [UInt8](data)
            for _ in 0..<paddingSize {
                bytes.append(0)
            }
            let cryptData = NSMutableData(length: dataLength)!
            let keyLength: Int = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions = UInt32(0)
            let iv = "513276HH19BEFDAQ"
            var numBytesEncrypted :size_t = 0
            let cryptStatus = CCCrypt(operation, algoritm, options,
                                      [UInt8](keyData), keyLength,
                                      iv, bytes, bytes.count,
                                      cryptData.mutableBytes, cryptData.length, &numBytesEncrypted)
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                let base64cryptString = cryptData.base64EncodedData(options: Data.Base64EncodingOptions(rawValue: 0))
                if let result = String(data: base64cryptString, encoding: .utf8) {
                    return result
                }
            }
        }
        return string
    }
    
    public static func decrypt(string: String) -> String {
        if let data = Data(base64Encoded: string, options: Data.Base64DecodingOptions(rawValue: 0)), let keyData = "QWERC16017BQ6556JGL2A#SHC!QABUZZ".data(using: .utf8) {
            let cryptData = NSMutableData(length: Int(data.count) + kCCBlockSizeAES128)!
            let keyLength: Int = size_t(kCCKeySizeAES256)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options: CCOptions = UInt32(0)
            let iv = "513276HH19BEFDAQ"
            var numBytesEncrypted :size_t = 0
            let cryptStatus = CCCrypt(operation, algoritm, options,
                                      [UInt8](keyData), keyLength,
                                      iv, [UInt8](data), data.count,
                                      cryptData.mutableBytes, cryptData.length, &numBytesEncrypted)
            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                cryptData.length = Int(numBytesEncrypted)
                if let resultPadded = String(data: cryptData as Data, encoding: .utf8) {
                    let result = resultPadded.trimmingCharacters(in: ["\0"])
                    return result
                }
            }
        }
        return string
    }
    
}
