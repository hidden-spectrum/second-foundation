//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import CoreLocation


public struct CLBoundingBox {
    
    // MARK: Public
    
    public let lowerLeft: CLLocationCoordinate2D
    public let upperRight: CLLocationCoordinate2D
    
    // MARK: Lifecycle
    
    public init(lowerLeft: CLLocationCoordinate2D, upperRight: CLLocationCoordinate2D) {
        self.lowerLeft = lowerLeft
        self.upperRight = upperRight
    }
}
