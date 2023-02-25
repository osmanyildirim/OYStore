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
    
    /// Save value with key
    /// - Parameters:
    ///   - value: value to save
    ///   - key: key of value to save
    func save<T>(_ value: T, key: String) {
        switch value {
        case is Int, is Float, is Double, is Bool, is URL, is URL?:
            queue.sync(flags: .barrier, execute: {
                Self.cache.setObject(CacheStore(object: value), forKey: key as NSString)
            })
        default:
            if let value = value as? Codable {
                queue.sync(flags: .barrier, execute: {
                    Self.cache.setObject(CacheStore(object: value.data), forKey: key as NSString)
                })
            }
        }
    }
    
    /// Get value by key
    /// - Parameter key: key of saved value
    /// - Returns: decodable value
    /// - Throws: error if there were any issues to get value from MemoryCache by key
    func value<T: Decodable>(key: String) throws -> T? {
        var value: Any?

        queue.sync {
            value = Self.cache.object(forKey: key as NSString)?.object
        }

        guard let value else { return nil }

        if let data = value as? Data {
            return try data.decode()
        } else {
            return value as? T
        }
    }
    
    /// Delete value by keys from MemoryCache
    /// - Parameter keys: keys of values to remove
    func remove(keys: String...) {
        queue.sync(flags: .barrier, execute: {
            keys.forEach({ Self.cache.removeObject(forKey: $0 as NSString) })
        })
    }
    
    /// Remove all value in MemoryCache
    func removeAll() {
        queue.sync(flags: .barrier, execute: {
            Self.cache.removeAllObjects()
        })
    }
}
