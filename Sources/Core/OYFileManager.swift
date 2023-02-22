//
//  OYFileManager.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

final class OYFileManager {
    /// Save value to location with key
    /// - Parameters:
    ///   - to: location of value to save
    ///   - value: value to save
    /// - Throws: error if there were any issues to save value for location by key
    func save<T>(to: Location, value: T) throws {
        let url = try createURL(location: to)

        if [.jpg, .png, .mov, .mp4].contains(to.fileType), let value = value as? Data, let url = url {
            try value.write(to: url)
        } else if let value = value as? Codable, let url = url {
            try value.data?.write(to: url, options: .atomic)
        }
    }
    
    /// Get Decodable value from location
    /// - Parameter of: location to get Decodable value
    /// - Returns: Decodable value
    /// - Throws: error if there were any issues to get value from location
    func value<T: Decodable>(of: Location) throws -> T? {
        guard let url = try createURL(location: of) else { throw OYError.createURLError }
        let data = try Data(contentsOf: url)

        if [.jpg, .png, .mov, .mp4].contains(of.fileType) {
            return data as? T
        } else {
            return try data.decode()
        }
    }
    
    /// Delete value by location with key
    /// - Parameter of: location where the value will be deleted with the key
    /// - Throws: error if there were any issues to remove value from location
    func remove(of: Location) throws {
        guard let url = try createURL(location: of) else { throw OYError.createURLError }
        try FileManager.default.removeItem(at: url)
    }
    
    /// Remove all value in a location
    /// - Parameter of: location where all value will be removed
    /// - Throws: error if there were any issues to remove all value from location
    func removeAll(of: ClearLocation) throws {
        switch of {
        case .diskCache:
            try FileManager.cachesContents.forEach({ try FileManager.default.removeItem(atPath: $0) })
            
        case .applicationSupport:
            try FileManager.applicationSupportContents.forEach({ try FileManager.default.removeItem(atPath: $0) })
            
        case .documents:
            try FileManager.documentsContents.forEach({ try FileManager.default.removeItem(atPath: $0) })
            
        case .temporary:
            try FileManager.temporaryContents.forEach({ try FileManager.default.removeItem(atPath: $0) })
        default: return
        }
    }
}
