//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct Version: Sendable {
    
    // MARK: Public
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public var stringValue: String {
        "\(major).\(minor).\(patch)"
    }
    
    // MARK: Lifecycle
    
    public init?(string versionString: String) {
        let versionComponents = versionString.components(separatedBy: ".")
        guard versionComponents.count >= 2 else {
            return nil
        }
        guard let major = Int(versionComponents[0]),
              let minor = Int(versionComponents[1])
        else {
            return nil
        }
        self.major = major
        self.minor = minor
        if versionComponents.count >= 3 {
            self.patch = Int(versionComponents[2]) ?? 0
        } else {
            self.patch = 0
        }
    }
    
    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension Version: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else  {
            return lhs.patch < rhs.patch
        }
    }
}

extension Version: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

extension Version: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major 
        && lhs.minor == rhs.minor
        && lhs.patch == rhs.patch
    }
}
