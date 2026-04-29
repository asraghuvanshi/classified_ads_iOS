//
//  Step1View.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 30/04/26.
//

import SwiftUI


struct Step1View: View {
    @Binding var stateName: String
    @Binding var city: String
    @Binding var pincode: String
    @Binding var locality: String
 
    @Binding var userCoordinate: CLLocationCoordinate2D?
 
    let onContinue: () -> Void
    let onBack: () -> Void
 
    // Search state
    @StateObject private var searchManager = LocationSearchManager()
    @StateObject private var locationManager = CurrentLocationManager()
    @State private var locationQuery = ""
    @State private var showSuggestions = false
    @State private var isResolvingLocation = false
    @State private var locationConfirmed = false
    @FocusState private var searchFieldFocused: Bool
 
    var isFormValid: Bool {
        !stateName.isEmpty && !city.isEmpty && pincode.count >= 6
    }
 
    var body: some View {
        VStack(spacing: 24) {
 
            // MARK: Location Search Field
            VStack(alignment: .leading, spacing: 6) {
                Text("SEARCH LOCATION")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "#9499C4"))
                    .tracking(1.5)
 
                HStack(spacing: 10) {
                    Image(systemName: locationConfirmed ? "checkmark.circle.fill" : "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundStyle(
                            locationConfirmed ? Color(hex: "#00C9A7") : Color(hex: "#9499C4")
                        )
                        .animation(.spring(response: 0.3), value: locationConfirmed)
 
                    TextField("Type city, area or pincode…", text: $locationQuery)
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                        .focused($searchFieldFocused)
                        .onChange(of: locationQuery) { _, newValue in
                            locationConfirmed = false
                            searchManager.search(query: newValue)
                            showSuggestions = !newValue.isEmpty
                        }
 
                    if !locationQuery.isEmpty {
                        Button {
                            clearSearch()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 15))
                                .foregroundStyle(Color(hex: "#C8CCEE"))
                        }
                    }
 
                    if isResolvingLocation || searchManager.isSearching {
                        ProgressView()
                            .scaleEffect(0.7)
                            .tint(Color(hex: "#4F5BDB"))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white)
                        .shadow(color: Color(hex: "#4F5BDB").opacity(searchFieldFocused ? 0.15 : 0.05),
                                radius: searchFieldFocused ? 8 : 4, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    searchFieldFocused ? Color(hex: "#4F5BDB").opacity(0.4) : Color(hex: "#E8EAFF"),
                                    lineWidth: 1.5
                                )
                        )
                )
 
                // MARK: Suggestions Dropdown
                if showSuggestions && !searchManager.suggestions.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(searchManager.suggestions.prefix(5), id: \.self) { suggestion in
                            SuggestionRow(suggestion: suggestion)
                                .onTapGesture {
                                    selectSuggestion(suggestion)
                                }
 
                            if suggestion != searchManager.suggestions.prefix(5).last {
                                Divider()
                                    .padding(.leading, 44)
                                    .background(Color(hex: "#F0F1FF"))
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#E8EAFF"), lineWidth: 1)
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: searchManager.suggestions.count)
                }
            }
 
            // MARK: Auto-filled Fields (read-only, pre-filled from selection)
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    AutoFilledField(
                        label: "State",
                        value: stateName,
                        icon: "map.fill"
                    )
                    AutoFilledField(
                        label: "City",
                        value: city,
                        icon: "building.2.fill"
                    )
                }
 
                HStack(spacing: 12) {
                    AutoFilledField(
                        label: "Pincode",
                        value: pincode,
                        icon: "mappin.circle.fill"
                    )
                    AutoFilledField(
                        label: "Locality",
                        value: locality,
                        icon: "location.fill"
                    )
                }
            }
            .opacity(locationConfirmed ? 1 : 0.4)
            .animation(.easeInOut(duration: 0.3), value: locationConfirmed)
 
            // MARK: Coordinate badge
            if let coord = userCoordinate {
                HStack(spacing: 8) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: "#00C9A7"))
 
                    Text(String(format: "%.4f°, %.4f°", coord.latitude, coord.longitude))
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color(hex: "#5A5F8A"))
 
                    Spacer()
 
                    Text("Location saved")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(hex: "#00C9A7"))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#00C9A7").opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#00C9A7").opacity(0.2), lineWidth: 1)
                        )
                )
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.4), value: userCoordinate != nil)
            }
 
            // MARK: Location hint
            HStack(spacing: 8) {
                Image(systemName: "location.north.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: "#4F5BDB"))
 
                Text("Pincode helps rank your ads to nearby buyers first")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "#5A5F8A"))
 
                Spacer()
            }
 
            // MARK: Current Location Button
            Button {
                requestCurrentLocation()
            } label: {
                HStack {
                    if locationManager.isLoading {
                        ProgressView()
                            .scaleEffect(0.75)
                            .tint(Color(hex: "#4F5BDB"))
                    } else {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                    }
                    Text(locationManager.isLoading ? "Detecting location…" : "Use my current location")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color(hex: "#4F5BDB"))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#F0F1FF"))
                )
            }
            .disabled(locationManager.isLoading)
 
            // MARK: Action Buttons
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
            .padding(.top, 8)
        }
        .onAppear {
            locationManager.onLocationReceived = { coord, placemark in
                applyPlacemark(placemark, coordinate: coord)
            }
        }
    }
 
    // MARK: - Helpers
 
    private func selectSuggestion(_ suggestion: MKLocalSearchCompletion) {
        searchFieldFocused = false
        showSuggestions = false
        locationQuery = suggestion.title + (suggestion.subtitle.isEmpty ? "" : ", \(suggestion.subtitle)")
        isResolvingLocation = true
 
        LocationDetailFetcher.fetch(completion: suggestion) { coord, placemark in
            DispatchQueue.main.async {
                isResolvingLocation = false
                if let coord = coord {
                    applyPlacemark(placemark, coordinate: coord)
                }
            }
        }
    }
 
    private func applyPlacemark(_ placemark: CLPlacemark?, coordinate: CLLocationCoordinate2D) {
        userCoordinate = coordinate
        locationConfirmed = true
 
        // Auto-fill from placemark
        stateName = placemark?.administrativeArea ?? ""          // e.g. "Punjab"
        city = placemark?.locality
            ?? placemark?.subAdministrativeArea
            ?? ""                                                 // e.g. "Chandigarh"
        pincode = placemark?.postalCode ?? ""                     // e.g. "160017"
        locality = placemark?.subLocality
            ?? placemark?.thoroughfare
            ?? ""                                                  // e.g. "Sector 17"
 
        if locationQuery.isEmpty {
            locationQuery = [locality, city, stateName]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        }
    }
 
    private func requestCurrentLocation() {
        locationManager.requestLocation()
    }
 
    private func clearSearch() {
        locationQuery = ""
        showSuggestions = false
        locationConfirmed = false
        userCoordinate = nil
        stateName = ""
        city = ""
        pincode = ""
        locality = ""
        searchManager.suggestions = []
    }
}
 
// MARK: - Suggestion Row
struct SuggestionRow: View {
    let suggestion: MKLocalSearchCompletion
 
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color(hex: "#4F5BDB"))
                .frame(width: 28)
 
            VStack(alignment: .leading, spacing: 2) {
                Text(suggestion.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
                    .lineLimit(1)
 
                if !suggestion.subtitle.isEmpty {
                    Text(suggestion.subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#9499C4"))
                        .lineLimit(1)
                }
            }
 
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
 
// MARK: - Auto Filled Field (read-only display after selection)
struct AutoFilledField: View {
    let label: String
    let value: String
    let icon: String
 
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color(hex: "#9499C4"))
                .tracking(0.8)
 
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundStyle(value.isEmpty ? Color(hex: "#C8CCEE") : Color(hex: "#4F5BDB"))
 
                Text(value.isEmpty ? "—" : value)
                    .font(.system(size: 14, weight: value.isEmpty ? .regular : .medium))
                    .foregroundStyle(value.isEmpty ? Color(hex: "#C8CCEE") : Color(hex: "#0D0F2B"))
                    .lineLimit(1)
 
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(value.isEmpty ? Color(hex: "#F7F8FF") : Color(hex: "#F0F4FF"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                value.isEmpty ? Color(hex: "#E8EAFF") : Color(hex: "#4F5BDB").opacity(0.2),
                                lineWidth: 1.2
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: value)
        }
        .frame(maxWidth: .infinity)
    }
}
 
