//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import SwiftUI


public struct ColorSet<ACC: AssetCatalogColorProvider>: Hashable {
    
    // MARK: Internal
    
    let base: Color
    let vibrant: Color?
    
    // MARK: Lifecycle
    
    init(base: Color, vibrant: Color? = nil) {
        self.base = base
        self.vibrant = vibrant
    }
    
    // Color
    
    public static func single(_ color: Color) -> ColorSet {
        .init(base: color)
    }
    
    public static func vibrantVaried(_ color: Color, vibrant: Color) -> ColorSet {
        .init(base: color, vibrant: vibrant)
    }
    
    // Bundle
    
    public static func single(_ color: ACC, opacity: CGFloat = 1) -> ColorSet {
        .init(base: Color(color.name, bundle: color.bundle).opacity(opacity))
    }
    
    public static func vibrantVaried(_ color: ACC, vibrant: ACC) -> ColorSet {
        .init(
            base: Color(color.name, bundle: color.bundle),
            vibrant: Color(vibrant.name, bundle: vibrant.bundle)
        )
    }
    
    // Mixed
    
    public static func vibrantVaried(_ color: Color, vibrant: ACC, opacity: CGFloat = 1) -> ColorSet {
        .init(
            base: color,
            vibrant: Color(vibrant.name, bundle: vibrant.bundle).opacity(opacity)
        )
    }
    
    public static func vibrantVaried(_ color: ACC, vibrant: Color, opacity: CGFloat = 1) -> ColorSet {
        .init(
            base: Color(color.name, bundle: color.bundle).opacity(opacity),
            vibrant: vibrant
        )
    }
}
