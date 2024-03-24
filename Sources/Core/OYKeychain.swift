//
//  OYKeychain.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

final class OYKeychain {
    /// Service name for Keychain
    private let serviceName = "OYStore_Keychain"
    
    /// Save value with key
    /// - Parameters:
    ///   - value: value to save
    ///   - key: key of value to save
    /// - Throws: error if there were any issues to save value from Keychain by key
    func save<T>(_ value: T, key: String) throws {
        var data: Data?
        
        if let value = value as? Codable {
            data = value.data
        } else if let value = value as? Data {
            data = value
        }
        
        guard let data else {
            throw OYError.invalidDataToSave
        }
        
        let query = [kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                     kSecAttrService: serviceName,
                     kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key,
                     kSecValueData: data] as CFDictionary

        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            let query = [kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                         kSecAttrService: serviceName,
                         kSecClass: kSecClassGenericPassword,
                         kSecAttrAccount: key] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            SecItemUpdate(query, attributesToUpdate)
        } else if status != errSecSuccess {
            throw OYError.custom(description: "Keychain failed for `\(key)` key.",
                                 reason: "Couldn't be accessed to Keychain.",
                                 suggestion: "Change `\(key)` key or access to Keychain.")
        }
    }
    
    /// Get value by key
    /// - Parameter key: key of saved value
    /// - Returns: decodable value
    /// - Throws: error if there were any issues to get value from Keychain by key
    func value<T: Decodable>(key: String) throws -> T? {
        let query = [kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                     kSecAttrService: serviceName,
                     kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key,
                     kSecReturnData: true] as CFDictionary

        var result: CFTypeRef?
        SecItemCopyMatching(query as CFDictionary, &result)

        if let result = result as? Data {
            return try result.decode()
        } else {
            return result as? T
        }
    }
    
    /// Remove value by keys from Keychain
    /// - Parameter keys: keys of value to remove
    func remove(key: String) {
        let query = [kSecAttrService: serviceName,
                     kSecAttrAccount: key,
                     kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(query)
    }
    
    /// Remove all value in Keychain
    func removeAll() {
        let secItemClasses = [kSecClassGenericPassword,
                              kSecClassInternetPassword,
                              kSecClassCertificate,
                              kSecClassKey,
                              kSecClassIdentity]
        
        secItemClasses.forEach { item in
            let query: NSDictionary = [kSecClass as String: item,
                                       kSecAttrSynchronizable as String: kSecAttrSynchronizableAny]
            SecItemDelete(query)
        }
    }
}
