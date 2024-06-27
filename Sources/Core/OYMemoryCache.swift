//
//  OYMemoryCache.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

final class OYMemoryCache {
    /// Private NSCache instance
    private static var cache = NSCache<NSString, CacheStore>()
    
    private let queue = DispatchQueue(label: "com.oystore.cache.queue", attributes: .concurrent)

    /// Private CacheStore
    private class CacheStore: NSObject {
        let object: Any?

        init(object: Any?) {
            self.object = object
        }
    }
    
    /// Save data with key
    /// - Parameters:
    ///   - data: data to save
    ///   - key: key of data to save
    func save<T>(_ data: T, key: String) {
        switch data {
        case is Int, is Float, is Double, is Bool, is URL, is URL?:
            queue.sync(flags: .barrier, execute: {
                Self.cache.setObject(CacheStore(object: data), forKey: key as NSString)
            })
        default:
            if let data = data as? Codable {
                queue.sync(flags: .barrier, execute: {
                    Self.cache.setObject(CacheStore(object: data.data), forKey: key as NSString)
                })
            }
        }
    }
    
    /// Get data by key
    /// - Parameter key: key of stored data
    /// - Returns: decodable data
    /// - Throws: error if there were any issues to get data from MemoryCache by key
    func data<T: Decodable>(key: String) throws -> T? {
        guard let data = stored(of: key) else { return nil }

        if let data = data as? Data {
            return try data.decode()
        } else {
            return data as? T
        }
    }
    
    /// Remove data by keys from MemoryCache
    /// - Parameter keys: keys of datas to remove
    func remove(keys: String...) {
        queue.sync(flags: .barrier, execute: {
            keys.forEach({ Self.cache.removeObject(forKey: $0 as NSString) })
        })
    }
    
    /// Remove all data in MemoryCache
    func removeAll() {
        queue.sync(flags: .barrier, execute: {
            Self.cache.removeAllObjects()
        })
    }
    
    /// Check if it is empty by with key
    /// - Parameter key: key of stored data
    /// - Returns: returns `true` if the data is stored at the location, otherwise returns `false`
    func isEmpty(key: String) -> Bool {
        stored(of: key) != nil
    }
}

private extension OYMemoryCache {
    /// Get stored data by key
    /// - Parameter key: key of stored data
    /// - Returns: stored data
    func stored(of key: String) -> Any? {
        var data: Any?

        queue.sync {
            data = Self.cache.object(forKey: key as NSString)?.object
        }

        return data
    }
}
