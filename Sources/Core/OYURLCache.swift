//
//  OYURLCache.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

final class OYURLCache {
    private let shared = URLCache.shared

    @available(iOS 13.0, *)
    func save(urlRequest: URLRequest, data: Data?, urlSession: URLSession?, urlResponse: URLResponse?) throws {
        guard let data, let urlSession, let urlResponse, let cachesPath = FileManager.caches?.appendingPathComponent("OYStore_URLCache") else {
            throw OYError.invalidDataToSave
        }

        urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
        urlSession.configuration.urlCache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 1_000_000_000, directory: cachesPath)

        let cached = CachedURLResponse(response: urlResponse, data: data)
        shared.storeCachedResponse(cached, for: urlRequest)
    }

    func value<T: Decodable>(urlRequest: URLRequest) throws -> T? {
        guard let cached = shared.cachedResponse(for: urlRequest)?.data else {
            throw OYError.valueCouldNotRetrieve
        }

        guard let decoded: T? = try cached.decode() else {
            return cached as? T
        }
        return decoded
    }
    
    /// Remove cached response of URLRequest
    /// - Parameter urlRequest: URLRequest of cached value to remove
    func remove(urlRequest: URLRequest) {
        shared.removeCachedResponse(for: urlRequest)
    }
    
    /// Remove all cached responses
    func removeAll() {
        shared.removeAllCachedResponses()
    }
}
