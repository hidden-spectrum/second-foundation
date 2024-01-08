//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public struct SemanticColorMap<SC: SemanticColor> {
    
    // MARK: Internal
    
    var map = [ColorSet: [SC]]()
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    init(_ map: [ColorSet: [SC]]) {
        self.map = map
    }
    
    // MARK: Registering Colors
    
    public func register(_ colorSet: ColorSet, for semanticColors: [SC]) -> Self {
        for semanticColor in semanticColors {
            guard map.first(where: { $0.value.contains(semanticColor) }) == nil else {
                assertionFailure("Semantic color already registered: \(semanticColor)")
                return self
            }
        }
        
        var map = self.map
        map[colorSet] = semanticColors
        return .init(map)
    }
    
    // MARK: Getting Colors
    
    public func color(for semanticColor: SC) -> Color {
        guard let colorSet = map.first(where: { $0.value.contains(semanticColor) }) else {
            assertionFailure("No ColorSet registered for semantic color: \(semanticColor)")
            return .red
        }
        return colorSet.key.base
    }
    
    public func color(for semanticColor: SC, vibrant: Bool) -> Color {
        guard let colorSet = map.first(where: { $0.value.contains(semanticColor) }) else {
            assertionFailure("No ColorSet registered for semantic color: \(semanticColor)")
            return .red
        }
        guard let vibrantColor = colorSet.key.vibrant else {
            assertionFailure("No vibrant color in ColorSet for semantic color: \(semanticColor)")
            return .red
        }
        return vibrant ? vibrantColor : colorSet.key.base
    }
}
