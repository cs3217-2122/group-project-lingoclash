//
//  KeychainManager.swift
//  LingoClash
//
//  Created by Kyle キラ on 21/3/22.
//

import Foundation

class KeychainManager {
    enum KeychainError: Error {
        case duplicateEntry
        case noValueFound
        case unknown(OSStatus)
    }
    
    static func save(service:String, account: String, value: Data, shouldOverwrite: Bool = true) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: value as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            guard !shouldOverwrite else {
                try KeychainManager.update(service: service, account: account, newValue: value)
                
                return
            }
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func update(service:String, account: String, newValue: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject
        ]
        
        let newAttributes: [String: AnyObject] = [
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: newValue as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, newAttributes as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noValueFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        return result as? Data
    }
    
    static func delete(service: String, account: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
        
    }
}






