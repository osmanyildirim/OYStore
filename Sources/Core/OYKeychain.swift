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
    
    /// Save data with key
    /// - Parameters:
    ///   - data: data to save
    ///   - key: key of data to save
    /// - Throws: error if there were any issues to save data from Keychain by key
    func save<T>(_ data: T, key: String) throws {
        var valueData: Data?
        
        if let data = data as? Codable {
            valueData = data.data
        } else if let data = data as? Data {
            valueData = data
        }
        
        guard let valueData else {
            throw OYError.invalidDataToSave
        }
        
        let query = [kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                     kSecAttrService: serviceName,
                     kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: key,
                     kSecValueData: valueData] as CFDictionary

        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            let query = [kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                         kSecAttrService: serviceName,
                         kSecClass: kSecClassGenericPassword,
                         kSecAttrAccount: key] as CFDictionary

            let attributesToUpdate = [kSecValueData: valueData] as CFDictionary

            SecItemUpdate(query, attributesToUpdate)
        } else if status != errSecSuccess {
            throw OYError.custom(description: "Keychain failed for `\(key)` key.",
                                 reason: "Couldn't be accessed to Keychain.",
                                 suggestion: "Change `\(key)` key or access to Keychain.")
        }
    }
    
    /// Get data by key
    /// - Parameter key: key of stored data
    /// - Returns: decodable data
    /// - Throws: error if there were any issues to get data from Keychain by key
    func data<T: Decodable>(key: String) throws -> T? {
        let result = stored(of: key)

        if let data = result as? Data {
            return try data.decode()
        } else {
            return result as? T
        }
    }
    
    /// Remove data by keys from Keychain
    /// - Parameter keys: keys of data to remove
    func remove(key: String) {
        let query = [kSecAttrService: serviceName,
                     kSecAttrAccount: key,
                     kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(query)
    }
    
    /// Remove all data in Keychain
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
    
    /// Check if it is empty by with key
    /// - Parameter key: key of stored data
    /// - Returns: returns `true` if the data is stored at the location, otherwise returns `false`
    func isEmpty(key: String) -> Bool {
        stored(of: key) != nil
    }
}

private extension OYKeychain {
    /// Get stored data by key
    /// - Parameter key: key of stored data
    /// - Returns: stored data with type `Optional<CFTypeRef>`
    func stored(of key: String) -> CFTypeRef? {
        let query = [kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
                        kSecAttrService: serviceName,
                              kSecClass: kSecClassGenericPassword,
                        kSecAttrAccount: key,
                         kSecReturnData: true] as CFDictionary

        var result: CFTypeRef?
        SecItemCopyMatching(query as CFDictionary, &result)

        return result
    }
}
