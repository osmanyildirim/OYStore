//
//  FileType.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

public enum FileType {
    case html
    case json
    case txt
    case jpg
    case png
    case mov
    case mp4

    /// Generate path of file name and file type
    /// - Parameter name: name of file to save
    /// - Returns: path of file name, e.g `folder/sample.json`
    func fileName(_ name: String) -> String {
        "\(name).\(self)"
    }
}
