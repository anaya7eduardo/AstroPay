//
//  Keychain.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation
import Security

public enum KeychainError: Error {
    case badData
    case badWrite
    case badUpdate
    case badAdd
    case badRead
    case badResultType
    case badResultData
    case badResultDataEncoding
}

public struct Keychain {
    public static func saveData(dataString: String, forAccount account: String) throws {
        guard let data = dataString.data(using: .utf8) else {
            throw KeychainError.badData
        }
        var query = [String: Any]()
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrAccount)] = account
        
        let accountStatus = SecItemCopyMatching(query as CFDictionary, nil)
        switch accountStatus {
        case errSecSuccess:
            var updateQuery = [String: Any]()
            updateQuery[String(kSecValueData)] = data
            let updateStatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
            if updateStatus != errSecSuccess {
                throw KeychainError.badUpdate
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = data
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            if addStatus != errSecSuccess {
                throw KeychainError.badAdd
            }
        default:
            throw KeychainError.badWrite
        }
    }
    
    public static func loadData(forAccount account: String) throws -> String? {
        var query = [String: Any]()
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = account
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            
            guard let responseDict = queryResult as? [String: Any] else {
                throw KeychainError.badResultType
            }
            guard let data = responseDict[String(kSecValueData)] as? Data else {
                throw KeychainError.badResultData
            }
            guard let result = String(data: data, encoding: .utf8) else {
                throw KeychainError.badResultDataEncoding
            }
            return result
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.badRead
        }
    }
    
}
