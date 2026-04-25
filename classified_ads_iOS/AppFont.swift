//
//  AppFont.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 24/04/26.
//


import SwiftUI

// MARK: - Color Palette
extension Color {
    // Primary brand - deep indigo-navy
    static let brand         = Color(hex: "#1B1F5E")
    static let brandLight    = Color(hex: "#2D3494")
    static let brandAccent   = Color(hex: "#4F5BDB")

    // Vibrant accents
    static let accentOrange  = Color(hex: "#FF6B35")
    static let accentTeal    = Color(hex: "#00C9A7")
    static let accentGold    = Color(hex: "#FFB800")
    static let accentRose    = Color(hex: "#FF4D6D")

    // Surfaces
    static let surfacePrimary   = Color(hex: "#FFFFFF")
    static let surfaceSecondary = Color(hex: "#F5F6FF")
    static let surfaceTertiary  = Color(hex: "#ECEEFF")
    static let surfaceCard      = Color(hex: "#FFFFFF")

    // Text
    static let textPrimary    = Color(hex: "#0D0F2B")
    static let textSecondary  = Color(hex: "#5A5F8A")
    static let textTertiary   = Color(hex: "#9499C4")
    static let textOnDark     = Color(hex: "#FFFFFF")

    // Status
    static let statusSuccess  = Color(hex: "#00C9A7")
    static let statusWarning  = Color(hex: "#FFB800")
    static let statusError    = Color(hex: "#FF4D6D")
    static let statusInfo     = Color(hex: "#4F5BDB")

    // Category colors
    static let catVehicles    = Color(hex: "#FF6B35")
    static let catElectronics = Color(hex: "#4F5BDB")
    static let catProperty    = Color(hex: "#00C9A7")
    static let catFashion     = Color(hex: "#FF4D6D")
    static let catFurniture   = Color(hex: "#FFB800")
    static let catJobs        = Color(hex: "#7C3AED")
    static let catServices    = Color(hex: "#0EA5E9")
    static let catSports      = Color(hex: "#10B981")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB,
                  red: Double(r)/255,
                  green: Double(g)/255,
                  blue: Double(b)/255,
                  opacity: Double(a)/255)
    }
}

// MARK: - Typography
struct AppFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
    static func heading(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
}

// MARK: - Gradient Library
struct AppGradient {
    static let brandPrimary = LinearGradient(
        colors: [Color(hex: "#1B1F5E"), Color(hex: "#4F5BDB")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let brandVibrant = LinearGradient(
        colors: [Color(hex: "#4F5BDB"), Color(hex: "#FF6B35")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let heroCard = LinearGradient(
        colors: [Color(hex: "#1B1F5E").opacity(0.92), Color(hex: "#2D3494").opacity(0.75)],
        startPoint: .top, endPoint: .bottom
    )
    static let tealFresh = LinearGradient(
        colors: [Color(hex: "#00C9A7"), Color(hex: "#0EA5E9")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let orangeWarm = LinearGradient(
        colors: [Color(hex: "#FF6B35"), Color(hex: "#FFB800")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let surfaceSubtle = LinearGradient(
        colors: [Color(hex: "#F5F6FF"), Color(hex: "#ECEEFF")],
        startPoint: .top, endPoint: .bottom
    )
}

// MARK: - Shadow Styles
extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.brand.opacity(0.08), radius: 16, x: 0, y: 4)
    }
    func subtleShadow() -> some View {
        self.shadow(color: Color.brand.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    func strongShadow() -> some View {
        self.shadow(color: Color.brand.opacity(0.18), radius: 24, x: 0, y: 8)
    }
}

// MARK: - Reusable Components

// Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    var isLoading: Bool = false
    var action: () -> Void

    init(_ title: String, icon: String? = nil, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.white).scaleEffect(0.85)
                } else {
                    if let icon { Image(systemName: icon).font(.system(size: 15, weight: .semibold)) }
                    Text(title).font(AppFont.heading(16))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(AppGradient.brandPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .strongShadow()
        }
        .buttonStyle(.plain)
    }
}

// Secondary Button
struct SecondaryButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.heading(16))
                .foregroundStyle(Color.brand)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.surfaceTertiary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.brandAccent.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// Floating Input Field
struct FloatingField: View {
    let label: String
    let placeholder: String
    var icon: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    @State private var isFocused = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(AppFont.body(11, weight: .semibold))
                .foregroundStyle(isFocused ? Color.brandAccent : Color.textTertiary)
                .textCase(.uppercase)
                .tracking(0.8)
                .padding(.horizontal, 16)
                .padding(.bottom, 4)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isFocused ? Color.brandAccent : Color.textTertiary)
                    .frame(width: 20)

                if isSecure {
                    SecureField(placeholder, text: $text)
                        .font(AppFont.body(16))
                        .foregroundStyle(Color.textPrimary)
                } else {
                    TextField(placeholder, text: $text)
                        .font(AppFont.body(16))
                        .foregroundStyle(Color.textPrimary)
                        .keyboardType(keyboardType)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isFocused ? Color.surfaceTertiary : Color.surfaceSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isFocused ? Color.brandAccent.opacity(0.5) : Color.clear, lineWidth: 1.5)
                    )
            )
        }
    }
}

// Category Pill
struct CategoryPill: View {
    let name: String
    let icon: String
    let color: Color
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isSelected ? color : color.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isSelected ? .white : color)
            }
            Text(name)
                .font(AppFont.body(11, weight: .medium))
                .foregroundStyle(isSelected ? Color.textPrimary : Color.textSecondary)
                .lineLimit(1)
        }
        .frame(width: 68)
    }
}

// Ad Card — Grid style
struct AdCard: View {
    let ad: AdItem
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(ad.categoryColor.opacity(0.12))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: ad.categoryIcon)
                            .font(.system(size: 36, weight: .light))
                            .foregroundStyle(ad.categoryColor.opacity(0.5))
                    )

                // Paid badge
                HStack(spacing: 3) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 9))
                    Text("Verified")
                        .font(AppFont.body(9, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.statusSuccess)
                .clipShape(Capsule())
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(ad.title)
                    .font(AppFont.heading(13))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)

                Text("₹\(ad.price)")
                    .font(AppFont.display(15, weight: .bold))
                    .foregroundStyle(Color.brand)

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 9))
                    Text(ad.location)
                        .font(AppFont.body(10))
                    Spacer()
                    Text(ad.timeAgo)
                        .font(AppFont.body(10))
                }
                .foregroundStyle(Color.textTertiary)
            }
            .padding(10)
        }
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .cardShadow()
    }
}

// Pill Tag
struct PillTag: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text)
            .font(AppFont.body(11, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Sample Data Models
struct AdItem: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let location: String
    let timeAgo: String
    let category: String
    let categoryIcon: String
    let categoryColor: Color
    let description: String
    let seller: String
    let sellerRating: Double
}

struct ChatThread: Identifiable {
    let id: UUID
    let name: String
    let lastMessage: String
    let time: String
    let unread: Int
    let initials: String
    let color: Color
    let adTitle: String
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
    let time: String
}

// MARK: - Sample Data
struct SampleData {
    static let ads: [AdItem] = [
        AdItem(title: "iPhone 14 Pro Max 256GB Deep Purple", price: "72,000", location: "Sector 17, CHD", timeAgo: "2h ago", category: "Electronics", categoryIcon: "iphone", categoryColor: .catElectronics, description: "Brand new sealed box iPhone 14 Pro Max. Bill and warranty card included. Genuine Apple product.", seller: "Priya S.", sellerRating: 4.8),
        AdItem(title: "Honda Activa 6G 2023 Model", price: "68,500", location: "Mohali", timeAgo: "5h ago", category: "Vehicles", categoryIcon: "motorcycle", categoryColor: .catVehicles, description: "Single owner, well maintained. Only 4200 km done. All papers clear.", seller: "Rahul K.", sellerRating: 4.6),
        AdItem(title: "2BHK Flat for Rent – Sector 22", price: "14,000/mo", location: "Sector 22, CHD", timeAgo: "1d ago", category: "Property", categoryIcon: "house.fill", categoryColor: .catProperty, description: "Spacious 2BHK with modular kitchen, 2 baths, parking. Semi-furnished.", seller: "Amit M.", sellerRating: 4.9),
        AdItem(title: "Nike Air Jordan 1 Retro High OG", price: "9,800", location: "Panchkula", timeAgo: "3h ago", category: "Fashion", categoryIcon: "shoeprints.fill", categoryColor: .catFashion, description: "UK size 10. Worn twice. Original box and accessories.", seller: "Sara T.", sellerRating: 4.7),
        AdItem(title: "Dining Table Set – Teak Wood 6 Seater", price: "22,000", location: "Zirakpur", timeAgo: "6h ago", category: "Furniture", categoryIcon: "chair.fill", categoryColor: .catFurniture, description: "Premium teak wood dining set, barely used. Moving sale.", seller: "Vikram J.", sellerRating: 4.5),
        AdItem(title: "MacBook Air M2 13\" 8GB/256GB", price: "89,000", location: "Sector 34, CHD", timeAgo: "1h ago", category: "Electronics", categoryIcon: "laptopcomputer", categoryColor: .catElectronics, description: "8 months old MacBook Air M2. Excellent condition, Apple Care valid.", seller: "Neha R.", sellerRating: 5.0),
    ]

    static let chats: [ChatThread] = [
        ChatThread(id: UUID(), name: "Priya Sharma", lastMessage: "Is the iPhone still available?", time: "2m", unread: 3, initials: "PS", color: .catElectronics, adTitle: "iPhone 14 Pro Max"),
        ChatThread(id: UUID(), name: "Rahul Kapoor", lastMessage: "Can you share more photos?", time: "1h", unread: 1, initials: "RK", color: .catVehicles, adTitle: "Honda Activa 6G"),
        ChatThread(id: UUID(), name: "Amit Mehta", lastMessage: "Deal! I'll visit tomorrow.", time: "3h", unread: 0, initials: "AM", color: .catProperty, adTitle: "2BHK Flat Sector 22"),
        ChatThread(id: UUID(), name: "Sara Thakur", lastMessage: "What's your lowest price?", time: "Yesterday", unread: 0, initials: "ST", color: .catFashion, adTitle: "Nike Air Jordan 1"),
        ChatThread(id: UUID(), name: "Vikram Jain", lastMessage: "Can I check it today evening?", time: "Yesterday", unread: 0, initials: "VJ", color: .catFurniture, adTitle: "Teak Dining Set"),
        ]

    static let messages: [Message] = [
        Message(text: "Hi! Is the iPhone still available?", isMe: false, time: "10:02 AM"),
        Message(text: "Yes it is! Just listed it today.", isMe: true, time: "10:04 AM"),
        Message(text: "Great. What's the condition? Any scratches?", isMe: false, time: "10:05 AM"),
        Message(text: "Absolutely mint. I always kept it in a case. Screen has no scratches at all.", isMe: true, time: "10:06 AM"),
        Message(text: "Does it come with original box and charger?", isMe: false, time: "10:08 AM"),
        Message(text: "Yes — sealed box, original cable, documentation, everything is there.", isMe: true, time: "10:09 AM"),
        Message(text: "Can you do ₹70,000?", isMe: false, time: "10:12 AM"),
        Message(text: "Best I can do is ₹71,500. It's barely 4 months old.", isMe: true, time: "10:14 AM"),
    ]
}
