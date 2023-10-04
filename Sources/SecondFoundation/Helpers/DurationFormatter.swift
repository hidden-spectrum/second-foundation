//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct DurationFormatter {
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    // MARK: Lifecycle
    
    public func string(for duration: TimeInterval) -> String {
        let totalMilliseconds = Int(duration * 1000)
        
        let hours = totalMilliseconds / 3600000
        let minutes = (totalMilliseconds % 3600000) / 60000
        let seconds = (totalMilliseconds % 60000) / 1000
        let milliseconds = totalMilliseconds % 1000
        
        var components: [String] = []
        
        if hours > 0 { components.append("\(hours)h") }
        if minutes > 0 { components.append("\(minutes)m") }
        if seconds > 0 { components.append("\(seconds)s") }
        if milliseconds > 0 { components.append("\(milliseconds)ms") }
        
        return components.joined(separator: " ")
    }
}
