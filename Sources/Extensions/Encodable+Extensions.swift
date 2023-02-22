//
//  Encodable+Extensions.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

extension Encodable {
    /// Convert Encodable to value of type Data
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
