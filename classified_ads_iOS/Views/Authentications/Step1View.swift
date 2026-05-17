//
//  Step1View.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 30/04/26.
//

import SwiftUI
import CoreLocation
import MapKit



// MARK: - Step 1 View (Updated)
struct Step1View: View {
    @Binding var stateName: String
    @Binding var city: String
    @Binding var pincode: String
    @Binding var locality: String
    @Binding var userCoordinate: CLLocationCoordinate2D?

    let onContinue: () -> Void
    let onBack: () -> Void

    @StateObject private var searchManager = LocationSearchManager()
    @StateObject private var locationManager = CurrentLocationManager()

    @State private var searchQuery = ""
    @State private var showLocationSearch = false
    @State private var showPartialInfoBanner = false

    // Allow continuing even if pincode/locality are missing,
    // as long as state and city are filled.
    var isFormValid: Bool {
        !stateName.isEmpty && !city.isEmpty
    }

    var hasPartialData: Bool {
        isFormValid && (pincode.isEmpty || locality.isEmpty)
    }

    var body: some View {
        VStack(spacing: 24) {
            // ── Search bar
            Button(action: { showLocationSearch = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "#4F5BDB"))

                    Text(searchQuery.isEmpty ? "Search city, locality or pincode…" : searchQuery)
                        .font(.system(size: 15))
                        .foregroundStyle(searchQuery.isEmpty ? Color(hex: "#A0A5CC") : Color(hex: "#1B1F5E"))

                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Color(hex: "#F7F8FF"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#E0E3FF"), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())

            // Use Current Location
            Button(action: fetchCurrentLocation) {
                HStack(spacing: 10) {
                    if locationManager.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(Color(hex: "#4F5BDB"))
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                    }
                    Text(locationManager.isLoading ? "Detecting location…" : "Use current location")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(hex: "#4F5BDB"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Color(hex: "#EEF0FF"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(locationManager.isLoading)

            // ── Filled fields
            if isFormValid {
                VStack(spacing: 0) {
                    LocationSummaryRow(icon: "building.2.fill",   label: "State",    value: stateName)
                    Divider().padding(.leading, 42)
                    LocationSummaryRow(icon: "mappin.circle.fill", label: "City",    value: city)

                    if !locality.isEmpty {
                        Divider().padding(.leading, 42)
                        LocationSummaryRow(icon: "map.fill",       label: "Locality", value: locality)
                    }

                    if !pincode.isEmpty {
                        Divider().padding(.leading, 42)
                        LocationSummaryRow(icon: "number.circle.fill", label: "Pincode", value: pincode)
                    }
                }
                .background(Color(hex: "#F7F8FF"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#E0E3FF"), lineWidth: 1)
                )
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
            }

            // ── Partial info banner
            if hasPartialData {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#FF6B35"))

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Some details not found")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color(hex: "#1B1F5E"))

                        Text(missingFieldsMessage)
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "#5A5F8A"))
                    }

                    Spacer()
                }
                .padding(14)
                .background(Color(hex: "#FFF5F0"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#FFD4C2"), lineWidth: 1)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Spacer()

            // ── Action Buttons
            VStack(spacing: 12) {
                GradientButton(
                    title: "Continue",
                    isEnabled: isFormValid,
                    action: onContinue
                )

                OutlineButton(
                    title: "Back",
                    action: onBack
                )
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isFormValid)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: hasPartialData)
        .fullScreenCover(isPresented: $showLocationSearch) {
            LocationSearchScreen(
                searchQuery: $searchQuery,
                searchManager: searchManager
            ) { result in
                applyResult(result)
            }
        }
        .onAppear {
            locationManager.onLocationReceived = { coord, placemark in
                let result = LocationResult(
                    stateName: placemark?.administrativeArea ?? "",
                    city: placemark?.locality ?? placemark?.subAdministrativeArea ?? "",
                    pincode: placemark?.postalCode ?? "",
                    locality: placemark?.subLocality ?? placemark?.thoroughfare ?? "",
                    coordinate: coord
                )
                applyResult(result)
            }
        }
    }

    // MARK: - Helpers
    private var missingFieldsMessage: String {
        var missing: [String] = []
        if pincode.isEmpty  { missing.append("pincode") }
        if locality.isEmpty { missing.append("locality") }
        let joined = missing.joined(separator: " and ")
        return "We couldn't find the \(joined) for this location. You can still continue — you may fill these in later."
    }

    private func fetchCurrentLocation() {
        locationManager.requestLocation()
    }

    private func applyResult(_ result: LocationResult) {
        withAnimation(.spring(response: 0.35)) {
            stateName      = result.stateName
            city           = result.city
            pincode        = result.pincode
            locality       = result.locality
            userCoordinate = result.coordinate
        }
        // Update the search bar display text
        let parts = [result.locality, result.city, result.stateName]
            .filter { !$0.isEmpty }
        searchQuery = parts.prefix(2).joined(separator: ", ")
    }
}


// MARK: - Location Summary Row
private struct LocationSummaryRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "#4F5BDB"))
                .frame(width: 20)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(hex: "#A0A5CC"))
                .frame(width: 52, alignment: .leading)

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(hex: "#1B1F5E"))
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }
}
