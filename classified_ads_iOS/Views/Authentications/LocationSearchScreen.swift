//
//  LocationResult.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 05/05/26.
//


import SwiftUI
import MapKit
import CoreLocation

// MARK: - Location Result Model
struct LocationResult {
    var stateName: String
    var city: String
    var pincode: String
    var locality: String
    var coordinate: CLLocationCoordinate2D?
}

// MARK: - Location Search Screen (Full Screen)
struct LocationSearchScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var searchQuery: String
    @ObservedObject var searchManager: LocationSearchManager
    
    let onSelect: (LocationResult) -> Void
    
    @State private var isFetchingDetail = false
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ── Top Bar
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color(hex: "#1B1F5E"))
                            .frame(width: 38, height: 38)
                            .background(Color(hex: "#F3F4FF"))
                            .clipShape(Circle())
                    }
                    
                    // Search Field
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                        
                        TextField("Search city, locality, or pincode…", text: $searchQuery)
                            .font(.system(size: 15))
                            .foregroundStyle(Color(hex: "#1B1F5E"))
                            .focused($isSearchFocused)
                            .submitLabel(.search)
                            .onChange(of: searchQuery) { _, newValue in
                                searchManager.search(query: newValue)
                            }
                        
                        if !searchQuery.isEmpty {
                            Button(action: {
                                searchQuery = ""
                                searchManager.search(query: "")
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color(hex: "#C8CCEE"))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(Color(hex: "#F7F8FF"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#E0E3FF"), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                Divider()
                    .background(Color(hex: "#F0F1FF"))
                
                // ── Results States
                ZStack {
                    if searchQuery.isEmpty {
                        EmptySearchPlaceholder()
                    } else if searchManager.isSearching {
                        SearchingIndicator()
                    } else if searchManager.suggestions.isEmpty {
                        NoResultsView(query: searchQuery)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                ForEach(searchManager.suggestions, id: \.self) { suggestion in
                                    LocationRow(suggestion: suggestion, isFetching: isFetchingDetail)
                                        .onTapGesture {
                                            selectSuggestion(suggestion)
                                        }
                                    
                                    if suggestion != searchManager.suggestions.last {
                                        Divider()
                                            .padding(.leading, 58)
                                            .background(Color(hex: "#F5F6FF"))
                                    }
                                }
                            }
                            .padding(.bottom, 40)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isSearchFocused = true
            }
        }
    }
    
    // MARK: - Select Suggestion
    private func selectSuggestion(_ suggestion: MKLocalSearchCompletion) {
        guard !isFetchingDetail else { return }
        isFetchingDetail = true
        
        LocationDetailFetcher.fetch(completion: suggestion) { coordinate, placemark in
            DispatchQueue.main.async {
                isFetchingDetail = false
                
                let result = LocationResult(
                    stateName: placemark?.administrativeArea ?? "",
                    city: placemark?.locality
                    ?? placemark?.subAdministrativeArea
                    ?? suggestion.subtitle.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces)
                    ?? "",
                    pincode: placemark?.postalCode ?? "",
                    locality: placemark?.subLocality
                    ?? placemark?.thoroughfare
                    ?? suggestion.title.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces)
                    ?? "",
                    coordinate: coordinate
                )
                
                onSelect(result)
                dismiss()
            }
        }
    }
}

// MARK: - Location Row
private struct LocationRow: View {
    let suggestion: MKLocalSearchCompletion
    let isFetching: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // Pin Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "#EEF0FF"))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(hex: "#4F5BDB"))
            }
            
            // Text
            VStack(alignment: .leading, spacing: 3) {
                HighlightedText(
                    full: suggestion.title,
                    ranges: suggestion.titleHighlightRanges
                )
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(hex: "#1B1F5E"))
                
                if !suggestion.subtitle.isEmpty {
                    HighlightedText(
                        full: suggestion.subtitle,
                        ranges: suggestion.subtitleHighlightRanges
                    )
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: "#7B82B5"))
                }
            }
            
            Spacer()
            
            if isFetching {
                ProgressView()
                    .scaleEffect(0.75)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "#C8CCEE"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

// MARK: - Highlighted Text Helper
private struct HighlightedText: View {
    let full: String
    let ranges: [NSValue]
    
    var body: some View {
        Text(attributedString)
            .lineLimit(1)
    }
    
    private var attributedString: AttributedString {
        var attr = AttributedString(full)
        for value in ranges {
            let nsRange = value.rangeValue
            if let range = Range(nsRange, in: full),
               let attrRange = Range(nsRange, in: attr) {
                attr[attrRange].font = .system(size: 15, weight: .bold)
                attr[attrRange].foregroundColor = Color(hex: "#4F5BDB")
            }
        }
        return attr
    }
}

// MARK: - Empty / State Views
private struct EmptySearchPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(Color(hex: "#C8CCEE"))
            
            Text("Search for your location")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "#5A5F8A"))
            
            Text("Try a city name, neighbourhood,\nor a 6-digit pincode")
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: "#A0A5CC"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 80)
    }
}

private struct SearchingIndicator: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Color(hex: "#4F5BDB"))
            Text("Finding locations…")
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "#A0A5CC"))
        }
        .padding(.top, 80)
    }
}

private struct NoResultsView: View {
    let query: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "map.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color(hex: "#D8DBFF"))
            
            Text("No results for \(query)")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "#5A5F8A"))
            
            Text("Try a different spelling or nearby area")
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: "#A0A5CC"))
        }
        .padding(.top, 80)
    }
}

