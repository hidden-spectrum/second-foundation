//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public extension String {
    var trimmedNullIfEmpty: String? {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : self
    }
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
