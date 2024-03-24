//
//  OYUserDefaults.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

final class OYUserDefaults {
    /// Private UserDefaults instance with suiteName
    private lazy var userDefaults = UserDefaults(suiteName: "OYStore_UserDefaults")
    
    /// Save value with key
    /// - Parameters:
    ///   - value: value to save
    ///   - key: key of value to save
    func save<T>(_ value: T, key: String) {
        switch value {
        case is Int, is Float, is Double, is Bool, is URL, is URL?:
            userDefaults?.set(value, forKey: key)
        default:
            if let value = value as? Codable {
                userDefaults?.set(value.data, forKey: key)
            }
        }
    }
    
    /// Get Decodable value by key
    /// - Parameters:
    ///   - key: key of saved value
    /// - Returns: Decodable value
    /// - Throws: error if there were any issues to get value from UserDefaults by key
    func value<T: Decodable>(key: String) throws -> T? {
        let value = userDefaults?.value(forKey: key)

        if let data = value as? Data {
            return try data.decode()
        } else {
            return value as? T
        }
    }

    /// Remove value by keys from UserDefaults
    /// - Parameter keys: keys of values to remove
    func remove(keys: String...) {
        keys.forEach({ userDefaults?.removeObject(forKey: $0) })
    }

    /// Remove all value in UserDefaults
    func removeAll() {
        UserDefaults.standard.removePersistentDomain(forName: "OYStore_UserDefaults")
    }
}
