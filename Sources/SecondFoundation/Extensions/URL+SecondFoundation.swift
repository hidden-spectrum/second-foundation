//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import Foundation
import UniformTypeIdentifiers


public extension URL {
    
    /// Appends the filename from another URL replacing it's extension with the given `UTType`.
    /// - Parameter utType: `UTType` of the file extension to use.
    /// - Returns: Completed `URL`.
    func appendingFileName(from otherUrl: URL, conformingTo utType: UTType) -> URL {
        return appendingPathComponent(otherUrl.deletingPathExtension().lastPathComponent, conformingTo: utType)
    }
    
    /// Replaces file extension from given `UTType`.
    /// - Parameter utType:`UTType` of the file extension to use.
    /// - Returns: Updated `URL`.
    func replacingFileExtension(with utType: UTType) -> URL {
        return deletingPathExtension().appendingPathExtension(for: utType)
    }
    
    /// Returns whether the URL is a directory by checking `resourceValues`, if available.
    var isDirectory: Bool? {
        try? resourceValues(forKeys: [.isDirectoryKey]).isDirectory
    }
    
    /// Returns the file size from` resourceValues`, if available.
    var totalFileSize: Int64? {
        if let fileSize = try? resourceValues(forKeys: [.totalFileSizeKey]).totalFileSize {
            return Int64(fileSize)
        } else {
            return nil
        }
    }
}

public extension Array where Element == URL {
    
    /// Sorts the array of URLs by the folder path then the file name. This assumes all URLs are for a file.
    /// - Returns: Sorted array.
    func sortedByFolderPathThenFilename() -> [URL] {
        sorted {
            let lhsPath = $0.deletingLastPathComponent().path
            let rhsPath = $1.deletingLastPathComponent().path
            
            if lhsPath == rhsPath {
                return $0.lastPathComponent < $1.lastPathComponent
            } else {
                return lhsPath < rhsPath
            }
        }
    }
}
