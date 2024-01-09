//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import SwiftUI


public struct ColorSemanticsMap<CR: ColorRoleProvider, ACC: AssetCatalogColorProvider> {
    
    // MARK: Internal
    
    var map = [ColorSet<ACC>: [CR]]()
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    init(_ map: [ColorSet<ACC>: [CR]]) {
        self.map = map
    }
    
    // MARK: Registering Colors
    
    public func register(_ colorSet: ColorSet<ACC>, for semanticColors: [CR]) -> Self {
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
    
    public func color(for colorRole: CR) -> Color {
        guard let colorSet = map.first(where: { $0.value.contains(colorRole) }) else {
            assertionFailure("No ColorSet registered for semantic color: \(colorRole)")
            return .red
        }
        return colorSet.key.base
    }
    
    public func color(for colorRole: CR, vibrant: Bool) -> Color {
        guard let colorSet = map.first(where: { $0.value.contains(colorRole) }) else {
            assertionFailure("No ColorSet registered for semantic color: \(colorRole)")
            return .red
        }
        guard let vibrantColor = colorSet.key.vibrant else {
            assertionFailure("No vibrant color in ColorSet for semantic color: \(colorRole)")
            return .red
        }
        return vibrant ? vibrantColor : colorSet.key.base
    }
}
