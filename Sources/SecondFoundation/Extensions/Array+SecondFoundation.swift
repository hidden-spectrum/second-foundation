//
//  Copyright © 2023 Hidden Spectrum, LLC.
//

import Foundation


public extension Array {
    
    /// Shifts elements by given amount, rotating the values around.
    /// - Parameter amount: Amount to shift the array.
    /// - Returns: Shifted array.
    func rotated(by amount: Int) -> [Element] {
        guard count > 0 else {
            return self
        }
        
        let offset = (amount % count + count) % count
        return Array(self[offset ..< count] + self[0 ..< offset])
    }
}
