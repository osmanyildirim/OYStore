//
//  OYStore.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

public final class OYStore {
    /// Save Codable value to location
    /// - Parameters:
    ///   - to: location to save the Codable value in
    ///   - value: value to save
    /// - Throws: error if there were any issues encoding or saving it to location
    public static func save<T: Codable>(to: Location, value: T) throws {
        switch to {
        case .userDefaults(let key):
            OYUserDefaults().save(value, key: key)

        case .keychain(let key):
            try OYKeychain().save(value, key: key)

        case .memoryCache(let key):
            OYMemoryCache().save(value, key: key)

        default:
            try OYFileManager().save(to: to, value: value)
        }
    }
    
    /// Get Codable value from location
    /// - Parameter of: location to get Codable value
    /// - Returns: Codable value
    /// - Throws: error if there were any issues to get value from location
    public static func value<T: Codable>(of: Location) throws -> T {
        switch of {
        case .userDefaults(let key):
            guard let data: T = try OYUserDefaults().value(key: key) else {
                throw OYError.valueCouldNotRetrieve
            }
            return data

        case .keychain(let key):
            guard let data: T = try OYKeychain().value(key: key) else {
                throw OYError.valueCouldNotRetrieve
            }
            return data

        case .memoryCache(let key):
            guard let data: T = try OYMemoryCache().value(key: key) else {
                throw OYError.valueCouldNotRetrieve
            }
            return data

        default:
            guard let data: T = try OYFileManager().value(of: of) else {
                throw OYError.valueCouldNotRetrieve
            }
            return data
        }
    }
    
    /// Get Codable value from location with default value
    /// - Parameters:
    ///   - of: location to get Codable value
    ///   - default: default value for location with key
    /// - Returns: Codable value
    public static func value<T: Codable>(of: Location, default: T) -> T {
        return (try? value(of: of)) ?? `default`
    }
    
    /// Delete value by location with key
    /// - Parameter of: location where the value will be deleted with the key
    /// - Throws: error if there were any issues to remove value from location
    public static func remove(of: Location) throws {
        switch of {
        case .userDefaults(let key):
            OYUserDefaults().remove(keys: key)

        case .keychain(let key):
            OYKeychain().remove(key: key)

        case .memoryCache(let key):
            OYMemoryCache().remove(keys: key)

        default:
            try OYFileManager().remove(of: of)
        }
    }
    
    /// Remove all value in a location
    /// - Parameter of: location where all value will be removed
    /// - Throws: error if there were any issues to remove all value from location
    public static func removeAll(of: ClearLocation) throws {
        switch of {
        case .userDefaults:
            OYUserDefaults().removeAll()
            
        case .keychain:
            OYKeychain().removeAll()
            
        case .memoryCache:
            OYMemoryCache().removeAll()
            
        default:
            try OYFileManager().removeAll(of: of)
        }
    }
}
