//
//  MainTabView.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 30/04/26.
//

import SwiftUI


// MARK: - Tab Definition
enum AppTab: Int, CaseIterable {
    case home
    case myAds
    case sell
    case chat
    case profile
    
    var icon: String {
        switch self {
        case .home:    return "house.fill"
        case .myAds:   return "rectangle.stack.fill"
        case .sell:    return "plus"
        case .chat:    return "bubble.left.and.bubble.right.fill"
        case .profile: return "person.fill"
        }
    }
    
    var label: String {
        switch self {
        case .home:    return "Home"
        case .myAds:   return "My Ads"
        case .sell:    return ""
        case .chat:    return "Inbox"
        case .profile: return "Profile"
        }
    }
}

// MARK: - Main Tab Container
struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    @State private var fabRotation: Double = 0
    @State private var showSellSheet = false
    
    // Badge counts
    var chatUnread: Int = 3
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabContentView(selectedTab: selectedTab)
                .ignoresSafeArea(edges: .bottom)
            
            floatingTabBar
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showSellSheet) {
            SellScreen()
        }
    }
    
    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                if tab == .sell {
                    fabButton
                } else {
                    tabButton(tab)
                }
            }
        }
        .frame(height: 64)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.white)
                .shadow(color: Color(hex: "#1B1F5E").opacity(0.10), radius: 24, x: 0, y: 8)
                .shadow(color: Color(hex: "#4F5BDB").opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(Color(hex: "#F0F1FF"), lineWidth: 1)
        )
    }
    
    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab
        
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color(hex: "#4F5BDB").opacity(0.10))
                            .frame(width: 44, height: 28)
                            .matchedGeometryEffect(id: "tabPill", in: namespace)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(
                            isSelected ? Color(hex: "#4F5BDB") : Color(hex: "#B0B4D8")
                        )
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                }
                
                Text(tab.label)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(
                        isSelected ? Color(hex: "#4F5BDB") : Color(hex: "#B0B4D8")
                    )
            }
            .frame(maxWidth: .infinity)
            // Badge for chat
            .overlay(alignment: .topTrailing) {
                if tab == .chat && chatUnread > 0 {
                    Text("\(chatUnread)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(
                            Capsule().fill(Color(hex: "#FF6B35"))
                        )
                        .offset(x: 6, y: -4)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var fabButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                fabRotation += 45
                showSellSheet = true
            }
        } label: {
            ZStack {
                // Glow
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#6B78FF"), Color(hex: "#4F5BDB")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: Color(hex: "#4F5BDB").opacity(0.45), radius: 12, x: 0, y: 6)
                
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(fabRotation))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: fabRotation)
            }
//            .offset(y: -14)
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
    }
    
    @Namespace private var namespace
}

// MARK: - Tab Content Router
struct TabContentView: View {
    let selectedTab: AppTab
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:    HomeScreen()
            case .myAds:   MyAdsScreen()
            case .sell:    Color.clear
            case .chat:    ChatScreen()
            case .profile: ProfileScreen()
            }
        }
    }
}

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
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
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
                    .padding(.bottom, 24)
                    
                    // Banner
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
                    
                    // Categories
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
                        .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ForEach(categories, id: \.0) { cat in
                                CategoryCell(name: cat.0, icon: cat.1, color: cat.2)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 28)
                    
                    // Recent listings header
                    HStack {
                        Text("Recent Near You")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#0D0F2B"))
                        Spacer()
                        Text("See all")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)
                    
                    // Listings grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 14) {
                        ForEach(sampleListings, id: \.title) { listing in
                            ListingCard(listing: listing)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // tab bar clearance
                }
            }
            .background(Color(hex: "#FAFBFF").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    var sampleListings: [ListingItem] {
        [
            ListingItem(title: "iPhone 14 Pro", price: "₹72,000", location: "Sector 17", time: "2h ago", icon: "iphone", color: "#4F5BDB", isFeatured: true),
            ListingItem(title: "Royal Enfield 350", price: "₹1,45,000", location: "Mohali", time: "5h ago", icon: "motorcycle", color: "#FF6B35", isFeatured: false),
            ListingItem(title: "Wooden Sofa Set", price: "₹18,500", location: "Panchkula", time: "1d ago", icon: "sofa.fill", color: "#9B59B6", isFeatured: false),
            ListingItem(title: "MacBook Air M2", price: "₹89,000", location: "Sector 22", time: "3h ago", icon: "laptopcomputer", color: "#00C9A7", isFeatured: true),
        ]
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

// MARK: - My Ads Screen
struct MyAdsScreen: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Ads")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                    Spacer()
                    Button {} label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(Color(hex: "#4F5BDB"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // Status tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(["All", "Active", "Pending", "Expired", "Sold"], id: \.self) { status in
                            StatusChip(label: status, isSelected: status == "All")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#4F5BDB").opacity(0.06))
                            .frame(width: 120, height: 120)
                        Image(systemName: "rectangle.stack.badge.plus")
                            .font(.system(size: 44))
                            .foregroundStyle(Color(hex: "#4F5BDB").opacity(0.5))
                    }
                    Text("No ads yet")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                    Text("Post your first ad for free.\nNo charges, no subscriptions.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#9499C4"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    Button {} label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                            Text("Post Free Ad")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(
                            Capsule().fill(
                                LinearGradient(
                                    colors: [Color(hex: "#6B78FF"), Color(hex: "#4F5BDB")],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                        )
                        .shadow(color: Color(hex: "#4F5BDB").opacity(0.35), radius: 12, x: 0, y: 6)
                    }
                    Spacer()
                }
                .padding(.bottom, 100)
            }
            .background(Color(hex: "#FAFBFF").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct StatusChip: View {
    let label: String
    let isSelected: Bool
    
    var body: some View {
        Text(label)
            .font(.system(size: 13, weight: isSelected ? .bold : .medium))
            .foregroundStyle(isSelected ? .white : Color(hex: "#9499C4"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: "#4F5BDB") : Color(hex: "#F0F1FF"))
            )
    }
}

// MARK: - Sell Screen
struct SellScreen: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color(hex: "#0D0F2B"))
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color(hex: "#F0F1FF")))
                    }
                    Spacer()
                    Text("Post Free Ad")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Category grid
                        Text("What are you selling?")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#0D0F2B"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach([
                                ("Cars & Bikes", "car.fill", "#4F5BDB"),
                                ("Electronics", "iphone", "#00C9A7"),
                                ("Fashion", "tshirt.fill", "#FF6B35"),
                                ("Furniture", "sofa.fill", "#9B59B6"),
                                ("Books", "book.fill", "#E67E22"),
                                ("Sports", "figure.run", "#2ECC71"),
                                ("Appliances", "washer.fill", "#E74C3C"),
                                ("Property", "building.2.fill", "#3498DB"),
                                ("Other", "ellipsis.circle.fill", "#95A5A6"),
                            ], id: \.0) { item in
                                SellCategoryCard(name: item.0, icon: item.1, color: item.2)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 8)
                }
            }
            .background(Color(hex: "#FAFBFF").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct SellCategoryCard: View {
    let name: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: color).opacity(0.10))
                    .frame(height: 64)
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundStyle(Color(hex: color))
            }
            Text(name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color(hex: "#5A5F8A"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 28)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: Color(hex: "#1B1F5E").opacity(0.05), radius: 8, x: 0, y: 3)
        )
    }
}

// MARK: - Chat Screen
struct ChatScreen: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Inbox")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(hex: "#4F5BDB"))
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // Chat list
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(sampleChats, id: \.name) { chat in
                            ChatRow(chat: chat)
                            Divider().padding(.leading, 76)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(Color(hex: "#FAFBFF").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    var sampleChats: [ChatItem] {
        [
            ChatItem(name: "Rahul S.", message: "Is the phone still available?", time: "2m", unread: 2, color: "#4F5BDB"),
            ChatItem(name: "Priya M.", message: "Can you do 65,000?", time: "1h", unread: 1, color: "#FF6B35"),
            ChatItem(name: "Amit K.", message: "Where can I pick it up?", time: "3h", unread: 0, color: "#00C9A7"),
            ChatItem(name: "Sunita R.", message: "Thanks, I'll come tomorrow.", time: "1d", unread: 0, color: "#9B59B6"),
        ]
    }
}

struct ChatItem {
    let name: String
    let message: String
    let time: String
    let unread: Int
    let color: String
}

struct ChatRow: View {
    let chat: ChatItem
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: chat.color).opacity(0.15))
                    .frame(width: 48, height: 48)
                Text(String(chat.name.prefix(1)))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(hex: chat.color))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(chat.name)
                    .font(.system(size: 15, weight: chat.unread > 0 ? .bold : .semibold))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
                Text(chat.message)
                    .font(.system(size: 13, weight: chat.unread > 0 ? .medium : .regular))
                    .foregroundStyle(chat.unread > 0 ? Color(hex: "#5A5F8A") : Color(hex: "#9499C4"))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(chat.time)
                    .font(.system(size: 11))
                    .foregroundStyle(chat.unread > 0 ? Color(hex: "#4F5BDB") : Color(hex: "#C8CCEE"))
                
                if chat.unread > 0 {
                    Text("\(chat.unread)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 18, height: 18)
                        .background(Circle().fill(Color(hex: "#4F5BDB")))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: "#FAFBFF"))
    }
}

// MARK: - Profile Screen
struct ProfileScreen: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header card
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#4F5BDB"), Color(hex: "#6B78FF")],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            Text("A")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: Color(hex: "#4F5BDB").opacity(0.35), radius: 12, x: 0, y: 6)
                        
                        VStack(spacing: 4) {
                            Text("Arjun Singh")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "#0D0F2B"))
                            Text("Member since Jan 2024")
                                .font(.system(size: 13))
                                .foregroundStyle(Color(hex: "#9499C4"))
                        }
                        
                        // Stats row
                        HStack(spacing: 0) {
                            ProfileStat(value: "12", label: "Ads Posted")
                            Divider().frame(height: 32)
                            ProfileStat(value: "8", label: "Sold")
                            Divider().frame(height: 32)
                            ProfileStat(value: "4.8★", label: "Rating")
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "#F7F8FF"))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 28)
                    
                    // Menu items
                    VStack(spacing: 8) {
                        ProfileMenuSection(title: "ACCOUNT") {
                            ProfileMenuItem(icon: "person.fill",color: "#4F5BDB", label: "Edit Profile")
                            ProfileMenuItem(icon: "bell.fill", color: "#FF6B35", label: "Notifications")
                            ProfileMenuItem(icon: "shield.fill",color: "#00C9A7", label: "Privacy & Safety")
                        }
                        
                        ProfileMenuSection(title: "MY ACTIVITY") {
                            ProfileMenuItem(icon: "heart.fill", color: "#E74C3C", label: "Saved Ads")
                            ProfileMenuItem(icon: "clock.fill", color: "#9B59B6", label: "Recently Viewed")
                            ProfileMenuItem(icon: "star.fill", color: "#E67E22", label: "My Reviews")
                        }
                        
                        ProfileMenuSection(title: "SUPPORT") {
                            ProfileMenuItem(icon: "questionmark.circle.fill", color: "#3498DB", label: "Help Center")
                            ProfileMenuItem(icon: "envelope.fill", color: "#2ECC71", label: "Contact Us")
                        }
                        
                        // Sign out
                        Button {} label: {
                            HStack {
                                Spacer()
                                Text("Sign Out")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color(hex: "#E74C3C"))
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.white)
                                    .shadow(color: Color.black.opacity(0.04), radius: 8)
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            .background(Color(hex: "#FAFBFF").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct ProfileStat: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: "#0D0F2B"))
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: "#9499C4"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }
}

struct ProfileMenuSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color(hex: "#C8CCEE"))
                .tracking(1.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
            )
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let color: String
    let label: String
    
    var body: some View {
        Button {} label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: color).opacity(0.12))
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: color))
                }
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "#D8DBFF"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
