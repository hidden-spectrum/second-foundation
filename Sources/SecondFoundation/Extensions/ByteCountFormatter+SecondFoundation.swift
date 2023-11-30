//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import SwiftUI


private let byteCountFormatter: ByteCountFormatter = {
    let byteCountFormatter = ByteCountFormatter()
    byteCountFormatter.allowedUnits = [.useAll]
    byteCountFormatter.countStyle = .file
    return byteCountFormatter
}()


public extension Int64 {
    func fileSizeString() -> String {
        byteCountFormatter.string(fromByteCount: self)
    }
}


@available(macOS 13, *)
@available(iOS 16, *)
public extension LocalizedStringResource.StringInterpolation {
    mutating func appendInterpolation(fileSize: Int64) {
        appendInterpolation(byteCountFormatter.string(fromByteCount: fileSize))
    }
}


public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation(fileSize: Int64) {
        appendInterpolation(byteCountFormatter.string(fromByteCount: fileSize))
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(fileSize: Int64) {
        appendInterpolation(byteCountFormatter.string(fromByteCount: fileSize))
    }
}
