//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import Foundation


public struct LaunchArgument {
    
    // MARK: Public
    
    public typealias Argument = LaunchArgument
    
    public let key: String
    
    // MARK: Lifecycle
    
    public init(_ key: String) {
        self.key = key
    }
}

public extension ProcessInfo {
    static func hasLaunchArgument(_ argument: LaunchArgument) -> Bool {
        processInfo.arguments.contains(argument.key)
    }
}
