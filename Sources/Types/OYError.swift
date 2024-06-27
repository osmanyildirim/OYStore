//
//  OYError.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

enum OYError: Error {
    /// When creating url for file to save
    case createURLError
    
    /// Data to be save is invalid
    case invalidDataToSave
    
    /// Data couldn't retrieve
    case dataCouldNotRetrieve
    
    /// Data doesn't exist at location
    case dataNotExistAtLocation
    
    /// Location of the data to be moved is invalid
    case invalidLocationForToMoveData
    
    /// UserDefaults data can't move to location
    case dataCanNotMoveToUserDefaults
    
    /// Keychain data can't move to location
    case dataCanNotMoveToKeychain
    
    /// Memory Cache data can't move to location
    case dataCanNotMoveToMemoryCache
    
    /// URL Cache data can't move to location
    case dataCanNotMoveToUrlCache
    
    /// Data can't move to UserDefaults
    case dataCanNotMoveFromUserDefaults
    
    /// Data can't move to Keychain
    case dataCanNotMoveFromKeychain
    
    /// Data can't move to Memory Cache
    case dataCanNotMoveFromMemoryCache
    
    /// Data can't move to URL Cache
    case dataCanNotMoveFromUrlCache
    
    /// Custom error
    static func custom(description: String?, reason: String?, suggestion: String?) -> Error {
        let info: [String: Any] = [NSLocalizedDescriptionKey: description ?? "",
                                   NSLocalizedRecoverySuggestionErrorKey: reason ?? "",
                                   NSLocalizedFailureReasonErrorKey: suggestion ?? ""]
        return NSError(domain: "OYStore_Error", code: -1, userInfo: info) as Error
    }
}
