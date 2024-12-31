//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import CoreLocation
import Combine
import Foundation
import os.log


@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
public actor LocationManager {
    
    // MARK: Public
    
    @MainActor
    public static let shared = LocationManager()
    
    public typealias LocationStream = AsyncStream<CLLocation?>
    public typealias PlacemarkStream = AsyncStream<CLPlacemark?>
    
    // MARK: Private
    
    private let desiredAccuracy: CLLocationAccuracy
    private let fetchPlacemark: Bool
    private let locationManager = CLLocationManager()
    private let log = Logger(subsystem: "io.hspec.SecondFoundation", category: "LocationManager")
    
    private var currentPlacemark: CLPlacemark? {
        didSet {
            placemarkContinuations.forEach { $0.value.yield(currentPlacemark) }
        }
    }
    private var currentLocation: CLLocation? {
        didSet {
            locationContinuations.forEach { $0.value.yield(currentLocation) }
        }
    }
    
    private var hasAuthorization: Bool {
        let authStatus = locationManager.authorizationStatus
        return authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
    }
    private var isUpdating = false
    private var locationContinuations: [UUID: LocationStream.Continuation] = [:]
    private var placemarkContinuations: [UUID: PlacemarkStream.Continuation] = [:]
    
    // MARK: Lifecycle
    
    init(desiredAccuracy: CLLocationAccuracy = 50, fetchPlacemark: Bool = true) {
        self.desiredAccuracy = desiredAccuracy
        self.fetchPlacemark = fetchPlacemark
        locationManager.desiredAccuracy = desiredAccuracy
    }
    
    // MARK: Authorization
    
    public func requestAuthorization() {
        if hasAuthorization {
            return
        }
        locationManager.requestWhenInUseAuthorization()
        log.info("Requested location authorization")
    }
    
    // MARK: Streams
    
    public func createLocationStream() -> LocationStream {
        LocationStream { continuation in
            let id = UUID()
            self.locationContinuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeLocationContinuation(withId: id)
                }
            }
        }
    }
    
    private func removeLocationContinuation(withId id: UUID) {
        locationContinuations.removeValue(forKey: id)
    }
    
    public func createPlacemarkStream() -> PlacemarkStream {
        PlacemarkStream { continuation in
            let id = UUID()
            self.placemarkContinuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeLocationContinuation(withId: id)
                }
            }
        }
    }
    
    private func removePlacemarkContinuation(withId id: UUID) {
        placemarkContinuations.removeValue(forKey: id)
    }
    
    // MARK: Location
    
    public func startUpdatingLocation() async {
        guard hasAuthorization else {
            log.warning("Not authorized to access location")
            return
        }
        
        guard isUpdating == false else {
            log.info("Already updating location")
            return
        }
        
        Task.detached(priority: .background) { [log] in
            log.info("Starting location updates")
            await self.setUpdating(true)
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    await self.processUpdate(update)
                }
                log.info("No longer processing location updates")
            } catch {
                log.error("Error with location stream: \(error)")
            }
            await self.setUpdating(false)
        }
    }
    
    public func forcePlacemarkUpdate() async {
        guard let currentLocation else {
            return
        }
        await setPlacemark(with: currentLocation)
    }
    
    private func setUpdating(_ isUpdating: Bool) async {
        self.isUpdating = isUpdating
    }
    
    private func processUpdate(_ update: CLLocationUpdate) async {
        guard let location = update.location else {
            return
        }
        
        if let currentLocation = currentLocation, location.distance(from: currentLocation) < desiredAccuracy {
            return
        }
        
        self.currentLocation = location
        log.debug("Set location: \(location.debugDescription)")
        
        await setPlacemark(with: location)
    }
    
    private func setPlacemark(with location: CLLocation) async {
        guard fetchPlacemark else {
            return
        }
        do {
            let placemark = try await CLGeocoder().reverseGeocodeLocation(location).first
            currentPlacemark = placemark
            log.info("Set placemark: \(self.currentPlacemark?.debugDescription ?? "nil")")
        } catch {
            log.error("Error with reverse geocoding: \(error)")
        }
    }
}
