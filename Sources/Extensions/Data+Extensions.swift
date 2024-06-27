//
//  Data+Extensions.swift
//  OYStore
//
//  Created by osmanyildirim
//

import UIKit

extension Data {
    /// Decode the Decodable data
    func decode<T: Decodable>() throws -> T? {
        return try JSONDecoder().decode(T.self, from: self)
    }

    /// Convert Data to UIImage
    var toImage: UIImage? {
        UIImage(data: self)
    }
}
