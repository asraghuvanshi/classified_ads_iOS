//
//  CustomButton.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 28/04/26.
//

import SwiftUI


// MARK: - Outline Button
struct OutlineButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .foregroundStyle(Color(hex: "#5A5F8A"))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#D8DBFF"), lineWidth: 1.5)
                )
        }
    }
}


// MARK: - Gradient Button
struct GradientButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        colors: isEnabled ? [Color(hex: "#1B1F5E"), Color(hex: "#4F5BDB")] : [Color(hex: "#C8CCEE"), Color(hex: "#D8DBFF")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: isEnabled ? Color(hex: "#4F5BDB").opacity(0.3) : .clear, radius: 8, y: 4)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.7)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}


// MARK: -  Primary Button
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
