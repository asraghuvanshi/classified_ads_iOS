//
//  LogoSectionView.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 29/04/26.
//


import SwiftUI

struct LogoSectionView: View {

    var title: String = "AdBazaar"
    var subtitle: String = "Your Local Marketplace"

    var logoScale: CGFloat = 1.0
    var logoOpacity: Double = 1.0

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "#4F5BDB"), Color(hex: "#FF6B35")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(logoScale)

                // Inner circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#1B1F5E"), Color(hex: "#4F5BDB")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 68, height: 68)
                    .scaleEffect(logoScale)
                    .shadow(
                        color: Color(hex: "#4F5BDB").opacity(0.3),
                        radius: 10
                    )

                // Icon
                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(hex: "#E8EAFF")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(logoScale)
            }

            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: "#1B1F5E"))

            Text(subtitle)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(hex: "#9499C4"))
        }
        .padding(.top, 50)
        .padding(.bottom, 30)
        .opacity(logoOpacity)
    }
}