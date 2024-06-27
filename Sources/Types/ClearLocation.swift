//
//  ClearLocation.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

/// Location to remove all values
public enum ClearLocation {
    /// UserDefaults
    case userDefaults
    
    /// Keychain
    case keychain
    
    /// NSCache
    case memoryCache
    
    /// URLCache
    case urlCache
    
    /// `/Library/Caches` Directory
    case diskCache
    
    /// `/Library/Application Support` Directory
    case applicationSupport
    
    /// `Documents` Directory
    case documents
    
    /// `tmp` Directory
    case temporary
}
