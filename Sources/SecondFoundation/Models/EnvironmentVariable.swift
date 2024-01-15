//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import Foundation


public struct EnvironmentVariable {
    
    // MARK: Public
    
    public typealias Variable = EnvironmentVariable
    
    public let key: String
    
    // MARK: Lifecycle
    
    public init(_ key: String) {
        self.key = key
    }
}

public extension ProcessInfo {
    static func value(for environmentVariable: EnvironmentVariable) -> String? {
        processInfo.environment[environmentVariable.key]
    }
}
