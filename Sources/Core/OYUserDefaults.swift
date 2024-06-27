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
    
    /// Save data with key
    /// - Parameters:
    ///   - data: data to save
    ///   - key: key of data to save
    func save<T>(_ data: T, key: String) {
        switch data {
        case is Int, is Float, is Double, is Bool, is URL, is URL?:
            userDefaults?.set(data, forKey: key)
        default:
            if let data = data as? Codable {
                userDefaults?.set(data.data, forKey: key)
            }
        }
    }
    
    /// Get Decodable data by key
    /// - Parameters:
    ///   - key: key of stored data
    /// - Returns: Decodable data
    /// - Throws: error if there were any issues to get data from UserDefaults by key
    func data<T: Decodable>(key: String) throws -> T? {
        let data = userDefaults?.value(forKey: key)

        if let data = data as? Data {
            return try data.decode()
        } else {
            return data as? T
        }
    }

    /// Remove data by keys from UserDefaults
    /// - Parameter keys: keys of datas to remove
    func remove(keys: String...) {
        keys.forEach({ userDefaults?.removeObject(forKey: $0) })
    }

    /// Remove all data in UserDefaults
    func removeAll() {
        UserDefaults.standard.removePersistentDomain(forName: "OYStore_UserDefaults")
    }
    
    /// Check if it is empty by with key
    /// - Parameter key: key of stored data
    /// - Returns: returns `true` if the data is stored at the location, otherwise returns `false`
    func isEmpty(key: String) -> Bool {
        userDefaults?.value(forKey: key) != nil
    }
}
