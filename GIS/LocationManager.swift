//
//  LocationManager.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import Foundation
import CoreLocation
import Combine

// The LocationManager class manages the user's location.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()

    // Publishes the user's last known location.
    @Published var lastKnownLocation: CLLocationCoordinate2D?

    // Private initializer sets the CLLocationManager delegate and desired accuracy.
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // Requests permission for location access.
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // Starts updating the user's location.
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // Stops updating the user's location.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate Methods

    // Called when location updates are received.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last?.coordinate
    }

    // Called when the authorization status changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            stopUpdatingLocation()
        }
    }
}
