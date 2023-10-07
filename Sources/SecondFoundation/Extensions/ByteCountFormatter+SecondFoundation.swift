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
