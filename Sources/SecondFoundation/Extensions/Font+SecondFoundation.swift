//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import SwiftUI


public extension Font {
    static func custom(_ customFont: CustomFont, _ weight: CustomFont.Weight = .regular, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Self {
        return .custom(customFont.name(for: weight), size: size, relativeTo: textStyle)
    }
    
    static func fixed(_ customFont: CustomFont, _ weight: CustomFont.Weight = .regular, size: CGFloat) -> Self {
        return .custom(customFont.name(for: weight), size: size)
    }
}
