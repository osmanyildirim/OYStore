//
//  OYFileManager.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

final class OYFileManager {
    /// Save data to location with key
    /// - Parameters:
    ///   - to: location of data to save
    ///   - data: data to save
    /// - Throws: error if there were any issues to save data for location by key
    func save<T>(to: Location, data: T) throws {
        let url = try createURL(location: to)

        if [.jpg, .png, .mov, .mp4].contains(to.fileType), let data = data as? Data, let url = url {
            try data.write(to: url)
        } else if let data = data as? Codable, let url = url {
            try data.data?.write(to: url, options: .atomic)
        }
    }
    
    /// Get Decodable data from location
    /// - Parameter of: location to get Decodable data
    /// - Returns: Decodable data
    /// - Throws: error if there were any issues to get data from location
    func data<T: Decodable>(of: Location) throws -> T? {
        guard let url = try createURL(location: of) else { throw OYError.createURLError }
        let data = try Data(contentsOf: url)

        if [.jpg, .png, .mov, .mp4].contains(of.fileType) {
            return data as? T
        } else {
            return try data.decode()
        }
    }
    
    /// Remove data by location with key
    /// - Parameter of: location where the data will be removed with the key
    /// - Throws: error if there were any issues to remove data from location
    func remove(of: Location) throws {
        guard let url = try createURL(location: of) else { throw OYError.createURLError }
        try FileManager.default.removeItem(at: url)
    }
    
    /// Remove all data in a location
    /// - Parameter of: location where all data will be removed
    /// - Throws: error if there were any issues to remove all data from location
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
    
    /// Check if the data at the location exists
    /// - Parameter at: location to check if the data exists
    /// - Returns: returns `true` if the data is stored at the location, otherwise returns `false`
    func isExist(at: Location) -> Bool {
        guard let relativePath = try? createURL(location: at, willMakeDirectory: false)?.relativePath else { return false }
        return FileManager.default.fileExists(atPath: relativePath)
    }
    
    /// Move data between locations
    /// - Parameters:
    ///   - from: location of the data
    ///   - to: location to be moved
    func move(from: Location, to: Location) throws {
        switch to {
        case .userDefaults:
            throw OYError.dataCanNotMoveToUserDefaults

        case .keychain:
            throw OYError.dataCanNotMoveToKeychain

        case .memoryCache:
            throw OYError.dataCanNotMoveToMemoryCache

        case .urlCache:
            throw OYError.dataCanNotMoveToUrlCache

        default: break
        }

        switch from {
        case .userDefaults:
            throw OYError.dataCanNotMoveToUserDefaults

        case .keychain:
            throw OYError.dataCanNotMoveToKeychain

        case .memoryCache:
            throw OYError.dataCanNotMoveToMemoryCache

        case .urlCache:
            throw OYError.dataCanNotMoveToUrlCache

        default:
            let fileManager = OYFileManager()

            guard let fromPath = try fileManager.createURL(location: from, willMakeDirectory: false)?.relativePath, isExist(at: from) else {
                throw OYError.dataNotExistAtLocation
            }

            guard let toPath = try fileManager.createURL(location: to, willMakeDirectory: true)?.relativePath else {
                throw OYError.invalidLocationForToMoveData
            }

            try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
        }
    }
}
