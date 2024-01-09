//
//  Copyright © 2024 Hidden Spectrum, LLC.
//

import SwiftUI


public protocol AssetCatalogColorProvider: Hashable {
    var name: String { get }
    var bundle: Bundle { get }
}

extension AssetCatalogColorProvider where Self: RawRepresentable, RawValue == String {
    public var name: String { rawValue }
}
