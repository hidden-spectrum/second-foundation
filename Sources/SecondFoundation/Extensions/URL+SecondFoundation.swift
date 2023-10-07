//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
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
    
    /// Returns the file size from` resourceValues`, if available.
    var totalFileSize: Int64? {
        if let fileSize = try? resourceValues(forKeys: [.totalFileSizeKey]).totalFileSize {
            return Int64(fileSize)
        } else {
            return nil
        }
    }
}
