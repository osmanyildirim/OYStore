//
//  OYStore.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

public final class OYStore {
    /// Save Codable data to location
    /// - Parameters:
    ///   - to: location to save the Codable data in
    ///   - data: data to save
    /// - Throws: error if there were any issues encoding or saving it to location
    public static func save<T: Codable>(to: Location, data: T) throws {
        switch to {
        case .userDefaults(let key):
            OYUserDefaults().save(data, key: key)

        case .keychain(let key):
            try OYKeychain().save(data, key: key)

        case .memoryCache(let key):
            OYMemoryCache().save(data, key: key)

        default:
            try OYFileManager().save(to: to, data: data)
        }
    }

    /// Save Codable data to location (for URLCache)
    /// - Parameter to: location to save the Codable data in
    @available(iOS 13.0, *) public static func save(to: Location) throws {
        switch to {
        case .urlCache(let urlRequest, let data, let urlSession, let urlResponse):
            try OYURLCache().save(urlRequest: urlRequest, data: data, urlSession: urlSession, urlResponse: urlResponse)
        default: return
        }
    }
    
    /// Get Codable data from location
    /// - Parameter of: location to get Codable data
    /// - Returns: Codable data
    public static func data<T: Codable>(of: Location) -> T? {
        switch of {
        case .userDefaults(let key):
            guard let data: T = try? OYUserDefaults().data(key: key) else {
                return nil
            }
            return data

        case .keychain(let key):
            guard let data: T = try? OYKeychain().data(key: key) else {
                return nil
            }
            return data

        case .memoryCache(let key):
            guard let data: T = try? OYMemoryCache().data(key: key) else {
                return nil
            }
            return data
            
        case .urlCache(let urlRequest, _, _, _):
            guard let data: T = try? OYURLCache().data(urlRequest: urlRequest) else {
                return nil
            }
            return data

        default:
            guard let data: T = try? OYFileManager().data(of: of) else {
                return nil
            }
            return data
        }
    }
    
    /// Get Codable data from location with default data
    /// - Parameters:
    ///   - of: location to get Codable data
    ///   - default: default data for location with key
    /// - Returns: Codable data
    public static func data<T: Codable>(of: Location, default: T) -> T {
        return data(of: of) ?? `default`
    }
    
    /// Remove data by location with key
    /// - Parameter of: location where the data will be removed with the key
    /// - Throws: error if there were any issues to remove data from location
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
    
    /// Remove all data at  location
    /// - Parameter of: location where all data will be removed
    /// - Throws: error if there were any issues to remove all data from location
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
    
    /// Check if the data at the location exists
    /// - Parameter at: location to check if the data exists
    /// - Returns: returns `true` if the data is stored at the location, otherwise returns `false`
    public static func isExist(at: Location) -> Bool {
        switch at {
        case .userDefaults(let key):
            return OYUserDefaults().isEmpty(key: key)

        case .keychain(let key):
            return OYKeychain().isEmpty(key: key)

        case .memoryCache(let key):
            return OYMemoryCache().isEmpty(key: key)

        default:
            let fileManager = OYFileManager()
            return fileManager.isExist(at: at)
        }
    }
    
    /// Move data between locations
    /// - Parameters:
    ///   - from: location of the data
    ///   - to: location to be moved
    public static func move(from: Location, to: Location) throws {
        let fileManager = OYFileManager()
        try fileManager.move(from: from, to: to)
    }
}
