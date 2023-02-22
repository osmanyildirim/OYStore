//
//  FileManager+Extensions.swift
//  OYExtensions
//
//  Created by osmanyildirim
//

import Foundation

extension FileManager {
    /// Path url of `applicationSupportDirectory`
    static var applicationSupport: URL? {
        if #available(iOS 16.0, *) {
            return URL.applicationSupportDirectory
        } else {
            return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        }
    }

    /// Path url of `cachesDirectory`
    static var caches: URL? {
        if #available(iOS 16.0, *) {
            return URL.cachesDirectory
        } else {
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        }
    }

    /// Path url of `documentDirectory`
    static var documents: URL? {
        if #available(iOS 16.0, *) {
            return URL.documentsDirectory
        } else {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        }
    }

    /// Path url of `temporaryDirectory`
    static var temporary: URL? {
        if #available(iOS 16.0, *) {
            return URL.temporaryDirectory
        } else {
            return URL(string: "file://" + NSTemporaryDirectory())
        }
    }

    /// Contents in the `applicationSupportDirectory`
    static var applicationSupportContents: [String] {
        if #available(iOS 16.0, *) {
            return (try? FileManager.default.contentsOfDirectory(at: .applicationSupportDirectory, includingPropertiesForKeys: nil).map(\.path)) ?? []
        } else {
            guard let documents = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return [] }
            return (try? FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil).map(\.path)) ?? []
        }
    }

    /// Contents in the `cachesDirectory`
    static var cachesContents: [String] {
        if #available(iOS 16.0, *) {
            return (try? FileManager.default.contentsOfDirectory(at: .cachesDirectory, includingPropertiesForKeys: nil).map(\.path)) ?? []
        } else {
            guard let documents = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return [] }
            return (try? FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil).map(\.path)) ?? []
        }
    }

    /// Contents in the `documentDirectory`
    static var documentsContents: [String] {
        if #available(iOS 16.0, *) {
            return (try? FileManager.default.contentsOfDirectory(at: .documentsDirectory, includingPropertiesForKeys: nil).map(\.path)) ?? []
        } else {
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
            return (try? FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil).map(\.path)) ?? []
        }
    }

    /// Contents in the `temporaryDirectory`
    static var temporaryContents: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()).map({ NSTemporaryDirectory() + $0 })) ?? []
    }
}
