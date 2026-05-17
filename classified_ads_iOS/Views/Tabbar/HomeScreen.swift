//
//  HomeScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 02/05/26.
//

import SwiftUI
import MapKit
import CoreLocation
 
// MARK: - Selected Location Model
struct SelectedLocation: Equatable {
    var city: String
    var state: String
    var locality: String
    var coordinate: CLLocationCoordinate2D?
 
    static var `default` = SelectedLocation(city: "Chandigarh", state: "Punjab", locality: "", coordinate: nil)
 
    var displayName: String {
        if !locality.isEmpty && !city.isEmpty {
            return "\(locality), \(city)"
        } else if !city.isEmpty && !state.isEmpty {
            return "\(city), \(state)"
        } else if !city.isEmpty {
            return city
        }
        return "Select location"
    }
 
    static func == (lhs: SelectedLocation, rhs: SelectedLocation) -> Bool {
        lhs.city == rhs.city && lhs.state == rhs.state && lhs.locality == rhs.locality
    }
}
 
// MARK: - Home Screen
struct HomeScreen: View {
    @State private var searchText = ""
    @State private var showLocationPicker = false
    @State private var selectedLocation: SelectedLocation = .default
 
    let categories = [
        ("Cars",         "car.fill",                  "#4F5BDB"),
        ("Electronics",  "iphone",                    "#00C9A7"),
        ("Fashion",      "tshirt.fill",               "#FF6B35"),
        ("Furniture",    "sofa.fill",                 "#9B59B6"),
        ("Books",        "book.fill",                 "#E67E22"),
        ("Sports",       "figure.run",                "#2ECC71"),
        ("Jobs",         "briefcase.fill",            "#E74C3C"),
        ("More",         "ellipsis.circle.fill",      "#95A5A6"),
    ]
 
    var sampleListings: [ListingItem] {
        [
            ListingItem(title: "iPhone 14 Pro",    price: "₹72,000",   location: selectedLocation.city.isEmpty ? "Nearby" : selectedLocation.city, time: "2h ago",  icon: "iphone",        color: "#4F5BDB", isFeatured: true),
            ListingItem(title: "Royal Enfield 350", price: "₹1,45,000", location: selectedLocation.city.isEmpty ? "Nearby" : selectedLocation.city, time: "5h ago",  icon: "motorcycle",    color: "#FF6B35", isFeatured: false),
            ListingItem(title: "Wooden Sofa Set",   price: "₹18,500",   location: selectedLocation.city.isEmpty ? "Nearby" : selectedLocation.city, time: "1d ago",  icon: "sofa.fill",     color: "#9B59B6", isFeatured: false),
            ListingItem(title: "MacBook Air M2",    price: "₹89,000",   location: selectedLocation.city.isEmpty ? "Nearby" : selectedLocation.city, time: "3h ago",  icon: "laptopcomputer",color: "#00C9A7", isFeatured: true),
        ]
    }
 
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#FAFBFF").ignoresSafeArea()
 
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 150)
                        VStack(spacing: 28) {
                            bannerView
                            categoriesSection
                            recentListingsSection
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
 
                VStack(spacing: 0) {
                    headerView
                }
                .background(Color(hex: "#FAFBFF"))
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showLocationPicker) {
            LocationPickerSheet(currentLocation: selectedLocation) { result in
                withAnimation(.spring(response: 0.35)) {
                    selectedLocation = SelectedLocation(
                        city:     result.city,
                        state:    result.stateName,
                        locality: result.locality,
                        coordinate: result.coordinate
                    )
                    print("Selected locations", selectedLocation)
                }
            }
        }
    }
 
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    // Tappable location pill
                    Button(action: { showLocationPicker = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#4F5BDB"))
 
                            Text(selectedLocation.displayName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color(hex: "#4F5BDB"))
                                .lineLimit(1)
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                                .id(selectedLocation.displayName) // triggers transition on change
 
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color(hex: "#4F5BDB"))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color(hex: "#4F5BDB").opacity(0.08))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
 
                    Text("Good morning 👋")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                }
                Spacer()
 
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#4F5BDB"), Color(hex: "#6B78FF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 42, height: 42)
                    .overlay(
                        Text("A")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    )
            }
 
            // Search bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "#9499C4"))
                Text("Search anything…")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "#C8CCEE"))
                Spacer()
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "#4F5BDB"))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "#F7F8FF"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#E8EAFF"), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
 
    // MARK: - Banner
    private var bannerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#4F5BDB"), Color(hex: "#7B85F0")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
 
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Post for Free")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("No hidden charges.\nJust fair deals.")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineSpacing(3)
                }
                Spacer()
                Image(systemName: "tag.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(.white.opacity(0.18))
            }
            .padding(.horizontal, 24)
        }
    }
 
    // MARK: - Categories
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Browse Categories")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
                Spacer()
                Text("See all")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#4F5BDB"))
            }
 
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(categories, id: \.0) { cat in
                    CategoryCell(name: cat.0, icon: cat.1, color: cat.2)
                }
            }
        }
    }
 
    // MARK: - Recent Listings
    private var recentListingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recent Near You")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                    // Dynamic location subtitle
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: "#9499C4"))
                        Text(selectedLocation.displayName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color(hex: "#9499C4"))
                            .transition(.opacity)
                            .id("subtitle-\(selectedLocation.displayName)")
                    }
                    .animation(.easeInOut(duration: 0.25), value: selectedLocation.displayName)
                }
                Spacer()
                Text("See all")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#4F5BDB"))
            }
 
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 14) {
                ForEach(sampleListings, id: \.title) { listing in
                    ListingCard(listing: listing)
                }
            }
        }
    }
}
 
// MARK: - Location Picker Sheet (Full Screen)
struct LocationPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
 
    let currentLocation: SelectedLocation
    let onSelect: (LocationResult) -> Void
 
    @StateObject private var searchManager = LocationSearchManager()
    @StateObject private var locationManager = CurrentLocationManager()
 
    @State private var locationQuery = ""
    @State private var isFetchingDetail = false
    @FocusState private var isSearchFocused: Bool
 
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
 
            VStack(spacing: 0) {
                // ── Top Bar ──────────────────────────────────────────
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color(hex: "#1B1F5E"))
                            .frame(width: 38, height: 38)
                            .background(Color(hex: "#F3F4FF"))
                            .clipShape(Circle())
                    }
 
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Change Location")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#1B1F5E"))
                        Text("Showing results for \(currentLocation.displayName)")
                            .font(.system(size: 11))
                            .foregroundStyle(Color(hex: "#9499C4"))
                    }
 
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 16)
 
                // ── Search Field ─────────────────────────────────────
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(hex: "#4F5BDB"))
 
                    TextField("Search city, area or pincode…", text: $locationQuery)
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                        .focused($isSearchFocused)
                        .onChange(of: locationQuery) { _, newValue in
                            searchManager.search(query: newValue)
                        }
 
                    if !locationQuery.isEmpty {
                        Button(action: {
                            locationQuery = ""
                            searchManager.search(query: "")
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color(hex: "#C8CCEE"))
                        }
                    }
 
                    if searchManager.isSearching {
                        ProgressView()
                            .scaleEffect(0.75)
                            .tint(Color(hex: "#4F5BDB"))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(Color(hex: "#F7F8FF"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#4F5BDB").opacity(0.3), lineWidth: 1.5)
                )
                .padding(.horizontal, 16)
 
                // ── Use Current Location ─────────────────────────────
                Button(action: fetchCurrentLocation) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#4F5BDB").opacity(0.10))
                                .frame(width: 36, height: 36)
                            if locationManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.7)
                                    .tint(Color(hex: "#4F5BDB"))
                            } else {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(hex: "#4F5BDB"))
                            }
                        }
 
                        VStack(alignment: .leading, spacing: 1) {
                            Text(locationManager.isLoading ? "Detecting…" : "Use current location")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(hex: "#1B1F5E"))
                            Text("Auto-detect via GPS")
                                .font(.system(size: 11))
                                .foregroundStyle(Color(hex: "#9499C4"))
                        }
 
                        Spacer()
 
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color(hex: "#C8CCEE"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(locationManager.isLoading)
                .padding(.top, 8)
 
                Divider()
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .background(Color(hex: "#F0F1FF"))
 
                // ── Results ──────────────────────────────────────────
                Group {
                    if locationQuery.isEmpty {
                        emptyPlaceholder
                    } else if searchManager.isSearching {
                        searchingIndicator
                    } else if searchManager.suggestions.isEmpty {
                        noResultsView
                    } else {
                        resultsList
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            // Pre-fill query with current location
            locationQuery = currentLocation.displayName == "Select location" ? "" : ""
            locationManager.onLocationReceived = { coord, placemark in
                let result = LocationResult(
                    stateName: placemark?.administrativeArea ?? "",
                    city:      placemark?.locality ?? placemark?.subAdministrativeArea ?? "",
                    pincode:   placemark?.postalCode ?? "",
                    locality:  placemark?.subLocality ?? placemark?.thoroughfare ?? "",
                    coordinate: coord
                )
                onSelect(result)
                dismiss()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isSearchFocused = true
            }
        }
    }
 
    // MARK: - Results List
    private var resultsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(searchManager.suggestions, id: \.self) { suggestion in
                    Button(action: { selectSuggestion(suggestion) }) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#EEF0FF"))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color(hex: "#4F5BDB"))
                            }
 
                            VStack(alignment: .leading, spacing: 3) {
                                Text(suggestion.title)
                                    .font(.system(size: 14, weight: .semibold))
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
 
                            if isFetchingDetail {
                                ProgressView().scaleEffect(0.7)
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
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isFetchingDetail)
 
                    if suggestion != searchManager.suggestions.last {
                        Divider()
                            .padding(.leading, 66)
                            .background(Color(hex: "#F5F6FF"))
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
 
    // MARK: - Empty States
    private var emptyPlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(Color(hex: "#C8CCEE"))
            Text("Search for a location")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "#5A5F8A"))
            Text("Find listings in any city,\nneighbourhood, or pincode")
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: "#A0A5CC"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
 
    private var searchingIndicator: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Color(hex: "#4F5BDB"))
            Text("Finding locations…")
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "#A0A5CC"))
        }
        .padding(.top, 60)
    }
 
    private var noResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "map.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color(hex: "#D8DBFF"))
            Text("No results for \(locationQuery)")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "#5A5F8A"))
            Text("Try a different spelling or nearby area")
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: "#A0A5CC"))
        }
        .padding(.top, 60)
    }
 
    // MARK: - Helpers
    private func selectSuggestion(_ suggestion: MKLocalSearchCompletion) {
        guard !isFetchingDetail else { return }
        isFetchingDetail = true
 
        LocationDetailFetcher.fetch(completion: suggestion) { coordinate, placemark in
            DispatchQueue.main.async {
                isFetchingDetail = false
                let result = LocationResult(
                    stateName: placemark?.administrativeArea ?? "",
                    city:      placemark?.locality ?? placemark?.subAdministrativeArea ?? "",
                    pincode:   placemark?.postalCode ?? "",
                    locality:  placemark?.subLocality ?? placemark?.thoroughfare ?? "",
                    coordinate: coordinate
                )
                onSelect(result)
                dismiss()
            }
        }
    }
 
    private func fetchCurrentLocation() {
        locationManager.requestLocation()
    }
}
struct CategoryCell: View {
    let name: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: color).opacity(0.10))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color(hex: color))
            }
            Text(name)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color(hex: "#5A5F8A"))
                .lineLimit(1)
        }
    }
}

struct ListingItem {
    let title: String
    let price: String
    let location: String
    let time: String
    let icon: String
    let color: String
    let isFeatured: Bool
}

struct ListingCard: View {
    let listing: ListingItem
    @State private var isWishlisted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: listing.color).opacity(0.08))
                    .frame(height: 110)
                    .overlay(
                        Image(systemName: listing.icon)
                            .font(.system(size: 38))
                            .foregroundStyle(Color(hex: listing.color).opacity(0.4))
                    )
                
                // Wishlist
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isWishlisted.toggle()
                    }
                } label: {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(isWishlisted ? Color(hex: "#FF6B35") : Color(hex: "#9499C4"))
                        .frame(width: 28, height: 28)
                        .background(
                            Circle().fill(.white)
                                .shadow(color: Color.black.opacity(0.08), radius: 4)
                        )
                }
                .padding(8)
                
                // Featured badge
                if listing.isFeatured {
                    Text("Featured")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color(hex: "#4F5BDB")))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(listing.price)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
                
                Text(listing.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "#5A5F8A"))
                    .lineLimit(1)
                
                HStack(spacing: 3) {
                    Image(systemName: "mappin")
                        .font(.system(size: 9))
                        .foregroundStyle(Color(hex: "#C8CCEE"))
                    Text(listing.location)
                        .font(.system(size: 10))
                        .foregroundStyle(Color(hex: "#C8CCEE"))
                    Text("·")
                        .foregroundStyle(Color(hex: "#C8CCEE"))
                    Text(listing.time)
                        .font(.system(size: 10))
                        .foregroundStyle(Color(hex: "#C8CCEE"))
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 6)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: Color(hex: "#1B1F5E").opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
}
