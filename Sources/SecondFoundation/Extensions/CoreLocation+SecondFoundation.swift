//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import CoreLocation


public extension CLLocationCoordinate2D {
    
    func approximateBoundingBox(for radius: CLLocationDistance) -> CLBoundingBox {
        
        // Approximate conversion from meters to degrees latitude.
        // About 111,320 meters in one degree of latitude.
        let metersPerDegreeLat = 111_320.0
        let latRange = radius / metersPerDegreeLat
        
        let latMin = latitude - latRange
        let latMax = latitude + latRange
        
        // For longitude, we scale by cos(latitude)
        let metersPerDegreeLon = metersPerDegreeLat * cos(latitude * .pi / 180)
        let lonRange = radius / metersPerDegreeLon
        
        let lonMin = longitude - lonRange
        let lonMax = longitude + lonRange
        
        let lowerLeft = CLLocationCoordinate2D(latitude: latMin, longitude: lonMin)
        let upperRight = CLLocationCoordinate2D(latitude: latMax, longitude: lonMax)
        
        return CLBoundingBox(lowerLeft: lowerLeft, upperRight: upperRight)
    }
}
