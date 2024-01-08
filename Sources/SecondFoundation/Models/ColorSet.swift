//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public struct ColorSet: Hashable {
    
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
    
    public static func single<BC: BundleColor>(_ color: BC, opacity: CGFloat = 1) -> ColorSet {
        .init(base: Color(color.name, bundle: color.bundle).opacity(opacity))
    }
    
    public static func vibrantVaried<BC: BundleColor, VBC: BundleColor>(_ color: BC, vibrant: VBC) -> ColorSet {
        .init(
            base: Color(color.name, bundle: color.bundle),
            vibrant: Color(vibrant.name, bundle: vibrant.bundle)
        )
    }
    
    // Mixed
    
    public static func vibrantVaried<BC: BundleColor>(_ color: Color, vibrant: BC, opacity: CGFloat = 1) -> ColorSet {
        .init(
            base: color,
            vibrant: Color(vibrant.name, bundle: vibrant.bundle).opacity(opacity)
        )
    }
    
    public static func vibrantVaried<BC: BundleColor>(_ color: BC, vibrant: Color, opacity: CGFloat = 1) -> ColorSet {
        .init(
            base: Color(color.name, bundle: color.bundle).opacity(opacity),
            vibrant: vibrant
        )
    }
}
