//
//  String+Extensions.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

extension String {
    /// Last word of the file to save
    /// e.g. `Caches`, `Documents` etc.
    var filePathLastWord: String {
        String(self.dropLast(1)).components(separatedBy: "/").last ?? ""
    }
    
    /// File to save convert to a valid path
    /// - Returns: valid path of file to save
    /// - Throws: error if there were any issues generating the url of the file to save
    func validPath() throws -> String {
        let fileName = clearPrefixSlashes(of: validFilename)
        guard fileName.count > 0 && fileName != "." else {
            throw OYError.custom(description: "`\(self)` is invalid file name.",
                                 reason: "Cannot write/read a file with the name \(self) on disk.",
                                 suggestion: "Use another file name with alphanumeric characters.")
        }
        return fileName
    }
    
    /// Convert invalid file name to valid file name
    /// e.g. `/folder/:sample.txt` → `/folder/sample.txt`
    private var validFilename: String {
        let invalids = CharacterSet(charactersIn: ":").union(.illegalCharacters).union(.controlCharacters).union(.newlines)
        return components(separatedBy: invalids).joined()
    }
}

extension String {
    /// If file name starts with slash(/) character, the begining slash character is deleted
    /// e.g: `/folder/sample.txt` → `folder/sample.txt`
    private func clearPrefixSlashes(of string: String) -> String {
        var string = string
        if string.prefix(1) == "/" {
            string.remove(at: string.startIndex)
        }
        if string.prefix(1) == "/" {
            string = clearPrefixSlashes(of: string)
        }
        return string
    }
}
