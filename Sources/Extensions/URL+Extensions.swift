//
//  URL+Extensions.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

extension URL {
    /// Check the url of the file to save
    /// If url not contains a `file://` prefix, added as a prefix
    mutating func check() {
        guard containsFilePrefix(Constants.filePrefix), let url = URL(string: Constants.filePrefix + absoluteString) else { return }
        self = url
    }
}

extension URL {
    struct Constants {
        static let filePrefix = "file://"
    }
    
    /// Check if url contains `file://`
    private func containsFilePrefix(_ prefix: String) -> Bool {
        absoluteString.lowercased().prefix(prefix.count) != prefix
    }
}
