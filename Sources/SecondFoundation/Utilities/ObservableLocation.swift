//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
import os.log


@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
@MainActor
@Observable
public final class ObservableLocation {
    
    // MARK: Public private(set)
    
    public private(set) var placemark: CLPlacemark?
    public private(set) var current: CLLocation?
    
    // MARK: Private
    
    private let locationManager = LocationManager.shared
    
    // MARK: Lifecycle
    
    public init() {
        subscribeToPlacemarkUpdates()
        startUpdatingLocation()
    }
    
    private func subscribeToPlacemarkUpdates() {
        Task {
            let stream = await self.locationManager.locationStream
            for await location in stream {
                self.current = location
            }
        }
        Task {
            let placemarkStream = await self.locationManager.placemarkStream
            for await placemark in placemarkStream {
                self.placemark = placemark
            }
        }
    }
    
    // MARK: Location Manager
    
    func startUpdatingLocation() {
        Task {
            await locationManager.requestAuthorization()
            await locationManager.startUpdatingLocation()
        }
    }
    
    public func forcePlacemarkUpdate() {
        Task {
            await locationManager.forcePlacemarkUpdate()
        }
    }
}
