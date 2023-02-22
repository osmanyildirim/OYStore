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
    
    /// The file to be save is invalid
    case invalidDataToSave
    
    /// The value couldn't retrieve
    case valueCouldNotRetrieve
    
    /// Custom error
    static func custom(description: String?, reason: String?, suggestion: String?) -> Error {
        let info: [String: Any] = [NSLocalizedDescriptionKey: description ?? "",
                                   NSLocalizedRecoverySuggestionErrorKey: reason ?? "",
                                   NSLocalizedFailureReasonErrorKey: suggestion ?? ""]
        return NSError(domain: "OYStore_Error", code: -1, userInfo: info) as Error
    }
}
