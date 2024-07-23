//
//  LocationManager.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func requestLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

