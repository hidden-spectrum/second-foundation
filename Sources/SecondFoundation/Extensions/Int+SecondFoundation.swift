//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public extension Int {
    
    /// Wraps an integer within a given range and base.
    /// - Parameters:
    ///   - limit: Upper limit to wrap around.
    ///   - base: Lower limit to wrap around.
    /// - Returns: Wrapped number.
    func wrapped(limit: Int, base: Int = 0) -> Int {
        let range = limit - base + 1
        let value = (self - base) % range
        return (value >= 0 ? value : value + range) + base
    }
}
