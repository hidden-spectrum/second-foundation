//
//  Copyright © 2024 Hidden Spectrum, LLC. All rights reserved.
//

import CoreLocation
import Combine
import Foundation
import os.log


@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
public actor LocationManager: ObservableObject {
    
    // MARK: Public
    
    @MainActor
    public static let shared = LocationManager()
    
    public typealias LocationStream = AsyncStream<CLLocation?>
    public typealias PlacemarkStream = AsyncStream<CLPlacemark?>
    
    public lazy var locationStream: LocationStream = {
        LocationStream { continuation in
            self.locationContinuation = continuation
        }
    }()
    public lazy var placemarkStream: PlacemarkStream = {
        PlacemarkStream { continuation in
            self.placemarkContinuation = continuation
        }
    }()
    
    // MARK: Private
    
    private let desiredAccuracy: CLLocationAccuracy
    private let fetchPlacemark: Bool
    private let locationManager = CLLocationManager()
    private let log = Logger(subsystem: "io.hspec.SecondFoundation", category: "LocationManager")
    
    private var currentPlacemark: CLPlacemark? {
        didSet {
            placemarkContinuation?.yield(currentPlacemark)
        }
    }
    private var currentLocation: CLLocation? {
        didSet {
            locationContinuation?.yield(currentLocation)
        }
    }
    
    private var hasAuthorization: Bool {
        let authStatus = locationManager.authorizationStatus
        return authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
    }
    private var isUpdating = false
    private var locationContinuation: LocationStream.Continuation?
    private var placemarkContinuation: PlacemarkStream.Continuation?
    
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
    }
    
    // MARK: Location
    
    public func startUpdatingLocation() {
        guard isUpdating == false, hasAuthorization else {
            log.warning("Already updating or not authorized")
            return
        }
        log.info("Starting location updates")
        isUpdating = true
        Task.detached(priority: .background) {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    await self.processUpdate(update)
                }
            } catch {
                self.log.error("Error with location stream: \(error)")
                await self.setUpdating(false)
            }
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
        locationContinuation?.yield(location)
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
