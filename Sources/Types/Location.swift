//
//  Location.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

public enum Location {
    /// UserDefaults
    case userDefaults(key: String)
    
    /// Keychain
    case keychain(key: String)
    
    /// NSCache
    case memoryCache(key: String)
    
    /// URLCache
    case urlCache(urlRequest: URLRequest, data: Data? = nil, urlSession: URLSession? = nil, urlResponse: URLResponse? = nil)
    
    /// `/Library/Caches` Directory
    case diskCache(file: String, type: FileType)
    
    /// `/Library/Application Support` Directory
    case applicationSupport(file: String, type: FileType)
    
    /// `Documents` Directory
    case documents(file: String, type: FileType)
    
    /// `tmp` Directory
    case temporary(file: String, type: FileType)

    /// FileType of the location where the file will be stored
    /// `png, mov, html, txt` etc.
    var fileType: FileType? {
        switch self {
        case .diskCache(_, let type):
            return type
        case .applicationSupport(_, let type):
            return type
        case .documents(_, let type):
            return type
        case .temporary(_, let type):
            return type
        default: return nil
        }
    }
}
