//
//  SimpleLocationManager.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 29/04/26.
//


import SwiftUI
import Combine
import CoreLocation

class SimpleLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationName: String = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        
        // Reverse geocode to get city/area name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let pincode = placemark.postalCode ?? ""
                let area = placemark.subLocality ?? placemark.thoroughfare ?? ""
                
                self.locationName = "\(area), \(city)"
                
                // Save these to your backend
                self.saveUserLocation(
                    lat: location.coordinate.latitude,
                    lng: location.coordinate.longitude,
                    city: city,
                    state: state,
                    pincode: pincode,
                    area: area
                )
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    private func saveUserLocation(lat: Double, lng: Double, city: String, state: String, pincode: String, area: String) {

    }
}
