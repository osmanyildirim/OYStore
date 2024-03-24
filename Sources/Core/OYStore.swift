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

    /// Save Codable value to location (for URLCache)
    /// - Parameter to: location to save the Codable value in
    @available(iOS 13.0, *) public static func save(to: Location) throws {
        switch to {
        case .urlCache(let urlRequest, let data, let urlSession, let urlResponse):
            try OYURLCache().save(urlRequest: urlRequest, data: data, urlSession: urlSession, urlResponse: urlResponse)
        default: return
        }
    }
    
    /// Get Codable value from location
    /// - Parameter of: location to get Codable value
    /// - Returns: Codable value
    public static func value<T: Codable>(of: Location) -> T? {
        switch of {
        case .userDefaults(let key):
            guard let data: T = try? OYUserDefaults().value(key: key) else {
                return nil
            }
            return data

        case .keychain(let key):
            guard let data: T = try? OYKeychain().value(key: key) else {
                return nil
            }
            return data

        case .memoryCache(let key):
            guard let data: T = try? OYMemoryCache().value(key: key) else {
                return nil
            }
            return data
            
        case .urlCache(let urlRequest, _, _, _):
            guard let data: T = try? OYURLCache().value(urlRequest: urlRequest) else {
                return nil
            }
            return data

        default:
            guard let data: T = try? OYFileManager().value(of: of) else {
                return nil
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
        return value(of: of) ?? `default`
    }
    
    /// Remove value by location with key
    /// - Parameter of: location where the value will be removed with the key
    /// - Throws: error if there were any issues to remove value from location
    public static func remove(of: Location) throws {
        switch of {
        case .userDefaults(let key):
            OYUserDefaults().remove(keys: key)

        case .keychain(let key):
            OYKeychain().remove(key: key)

        case .memoryCache(let key):
            OYMemoryCache().remove(keys: key)
            
        case .urlCache(let urlRequest, _, _, _):
            OYURLCache().remove(urlRequest: urlRequest)

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
            
        case .urlCache:
            OYURLCache().removeAll()
            
        default:
            try OYFileManager().removeAll(of: of)
        }
    }
}
