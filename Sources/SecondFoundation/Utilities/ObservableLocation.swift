//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import Combine
import CoreLocation
import Foundation
import os.log


@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
@MainActor
public final class ObservableLocation: ObservableObject {
    
    // MARK: Public private(set)
    
    @Published public private(set) var placemark: CLPlacemark?
    @Published public private(set) var current: CLLocation?
    
    public var hasAuthorization: Bool {
        let authStatus = CLLocationManager().authorizationStatus
        return authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
    }
    
    // MARK: Private
    
    private let locationManager = LocationManager.shared
    private var tasks: [Task<Void, Never>] = []
    
    // MARK: Lifecycle
    
    public init() {
        subscribeToPlacemarkUpdates()
    }
    
    deinit {
        tasks.forEach { $0.cancel() }
    }
    
    private func subscribeToPlacemarkUpdates() {
        let placemarkTask = Task { [weak self] in
            guard let self else { return }
            
            let stream = await self.locationManager.createLocationStream()
            for await location in stream {
                self.current = location
            }
        }
        tasks.append(placemarkTask)
        
        let locationTask = Task { [weak self] in
            guard let self else { return }
            
            let placemarkStream = await self.locationManager.createPlacemarkStream()
            for await placemark in placemarkStream {
                self.placemark = placemark
            }
        }
        tasks.append(locationTask)
    }
    
    // MARK: Location Manager
    
    public func startUpdatingLocation() {
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
