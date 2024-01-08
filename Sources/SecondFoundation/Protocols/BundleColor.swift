//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public protocol BundleColor: Hashable {
    var name: String { get }
    var bundle: Bundle { get }
}

extension BundleColor where Self: RawRepresentable, RawValue == String {
    public var name: String { rawValue }
}


public extension Color {
    init<BC: BundleColor>(bundle bundleColor: BC) {
        self.init(bundleColor.name, bundle: bundleColor.bundle)
    }
}
