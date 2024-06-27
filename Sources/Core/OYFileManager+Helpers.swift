//
//  OYFileManager+Helpers.swift
//  OYStore
//
//  Created by osmanyildirim
//

import Foundation

extension OYFileManager {
    /// Create url of the file to save with location
    /// - Parameter location: location with file and type
    /// - Returns: url of the file to save, e.g. `file:///.../Documents/folder/sample.txt`
    /// - Throws: error if there were any issues creating the url
    func createURL(location: Location, willMakeDirectory: Bool = true) throws -> URL? {
        switch location {
        case .applicationSupport(let file, let type):
            return try filePath(with: FileManager.applicationSupport, name: type.fileName(file), willMakeDirectory: willMakeDirectory)
        case .diskCache(let file, let type):
            return try filePath(with: FileManager.caches, name: type.fileName(file), willMakeDirectory: willMakeDirectory)
        case .documents(let file, let type):
            return try filePath(with: FileManager.documents, name: type.fileName(file), willMakeDirectory: willMakeDirectory)
        case .temporary(let file, let type):
            return try filePath(with: FileManager.temporary, name: type.fileName(file), willMakeDirectory: willMakeDirectory)
        default: return nil
        }
    }
}

extension OYFileManager {
    /// Get full path with directory and file name
    /// - Parameters:
    ///   - directory: directory url, e.g.`file:///.../Caches/`
    ///   - name: file name and parent folder name if declared, e.g. `folder/sample.txt`
    /// - Returns: url of the file to save, e.g. `file:///.../Caches/folder/sample.txt`
    /// - Throws: error if there were any issues generating the url of the file to save
    private func filePath(with directory: URL?, name: String, willMakeDirectory: Bool) throws -> URL? {
        let filePath = try name.validPath()
        let url = directory?.appendingPathComponent(filePath, isDirectory: false)

        guard var url = url else {
            throw OYError.custom(description: "Could not create URL for \(directory?.absoluteString.filePathLastWord ?? "")/\(filePath)",
                                 reason: "Could not get access to the file system's user domain mask.",
                                 suggestion: "Use a different directory.")
        }

        url.check()

        guard willMakeDirectory else { return url }
        try makeDirectory(url)

        return url
    }
    
    /// If there is no directory in the file system it will be create
    private func makeDirectory(_ url: URL) throws {
        var isDirectory: ObjCBool = false
        let directoryPath = url.deletingLastPathComponent()

        if !(FileManager.default.fileExists(atPath: directoryPath.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            try FileManager.default.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
