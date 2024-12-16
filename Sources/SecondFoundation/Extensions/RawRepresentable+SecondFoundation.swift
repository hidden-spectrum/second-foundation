//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public extension RawRepresentable where RawValue == String {
    init?(_ rawValue: RawValue?) {
        guard let rawValue else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    
    init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)!
    }
}

public extension RawRepresentable where RawValue: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

public extension RawRepresentable where RawValue: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
