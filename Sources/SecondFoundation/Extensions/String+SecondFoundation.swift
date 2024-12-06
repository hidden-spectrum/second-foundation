//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public extension String {
    var trimmedNullIfEmpty: String? {
        trimmed.isEmpty ? nil : trimmed
    }
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
