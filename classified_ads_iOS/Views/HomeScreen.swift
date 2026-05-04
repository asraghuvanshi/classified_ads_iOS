//
//  HomeScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 02/05/26.
//

import SwiftUI

// MARK: - Home Screen
struct HomeScreen: View {
    @State private var searchText = ""
    
    let categories = [
        ("Cars", "car.fill", "#4F5BDB"),
        ("Electronics", "iphone", "#00C9A7"),
        ("Fashion", "tshirt.fill", "#FF6B35"),
        ("Furniture", "sofa.fill", "#9B59B6"),
        ("Books", "book.fill", "#E67E22"),
        ("Sports", "figure.run", "#2ECC71"),
        ("Jobs", "briefcase.fill", "#E74C3C"),
        ("More", "ellipsis.circle.fill", "#95A5A6"),
    ]
    
    var sampleListings: [ListingItem] {
        [
            ListingItem(title: "iPhone 14 Pro", price: "₹72,000", location: "Sector 17", time: "2h ago", icon: "iphone", color: "#4F5BDB", isFeatured: true),
            ListingItem(title: "Royal Enfield 350", price: "₹1,45,000", location: "Mohali", time: "5h ago", icon: "motorcycle", color: "#FF6B35", isFeatured: false),
            ListingItem(title: "Wooden Sofa Set", price: "₹18,500", location: "Panchkula", time: "1d ago", icon: "sofa.fill", color: "#9B59B6", isFeatured: false),
            ListingItem(title: "MacBook Air M2", price: "₹89,000", location: "Sector 22", time: "3h ago", icon: "laptopcomputer", color: "#00C9A7", isFeatured: true),
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
                            // Banner
                            bannerView
                            
                            // Categories
                            categoriesSection
                            
                            // Recent listings
                            recentListingsSection
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
                
                // Fixed Header
                VStack(spacing: 0) {
                    headerView
                }
                .background(Color(hex: "#FAFBFF"))
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header View (Fixed)
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                        Text("Chandigarh, Punjab")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                    }
                    Text("Good morning 👋")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                }
                Spacer()
                
                // Avatar
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
    
    // MARK: - Banner View
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
    
    // MARK: - Categories Section
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
    
    // MARK: - Recent Listings Section
    private var recentListingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent Near You")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
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
