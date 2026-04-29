//
//  LocationSearchManager.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 29/04/26.
//


import SwiftUI
import MapKit
import CoreLocation
import Combine

 
// MARK: - Location Search Manager
final class LocationSearchManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var suggestions: [MKLocalSearchCompletion] = []
    @Published var isSearching = false
 
    private let completer = MKLocalSearchCompleter()
 
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        // Bias results to India
        completer.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629),
            span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)
        )
    }
 
    func search(query: String) {
        if query.isEmpty {
            suggestions = []
            isSearching = false
            return
        }
        isSearching = true
        completer.queryFragment = query
    }
 
    // MARK: MKLocalSearchCompleterDelegate
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.suggestions = completer.results
            self.isSearching = false
        }
    }
 
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.isSearching = false
        }
    }
}
 
// MARK: - Location Detail Fetcher
final class LocationDetailFetcher {
    static func fetch(
        completion: MKLocalSearchCompletion,
        result: @escaping (CLLocationCoordinate2D?, CLPlacemark?) -> Void
    ) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else {
                result(nil, nil)
                return
            }
            result(mapItem.placemark.coordinate, mapItem.placemark)
        }
    }
}
 
// MARK: - Current Location Manager
final class CurrentLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var coordinate: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
 
    private let manager = CLLocationManager()
    var onLocationReceived: ((CLLocationCoordinate2D, CLPlacemark?) -> Void)?
 
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
    }
 
    func requestLocation() {
        isLoading = true
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            isLoading = false
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        isLoading = false
        coordinate = location.coordinate
 
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            DispatchQueue.main.async {
                self?.onLocationReceived?(location.coordinate, placemarks?.first)
            }
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
    }
 
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else {
            isLoading = false
        }
    }
}
 
