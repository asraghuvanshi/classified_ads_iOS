//
//  SplashScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 25/04/26.
//

import SwiftUI

// MARK: - Splash Screen

struct SplashScreen: View {
    @EnvironmentObject var appState: AppState
    
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    @State private var taglineOffset: CGFloat = 20
    
    var body: some View {
        ZStack {
            AppGradient.brandPrimary.ignoresSafeArea()
            
            // Background decoration
            Circle()
                .fill(Color.brandAccent.opacity(0.15))
                .frame(width: 300, height: 300)
                .offset(x: 120, y: -200)
            
            Circle()
                .fill(Color.accentOrange.opacity(0.12))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: 280)
            
            VStack(spacing: 20) {
                Spacer()
                
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 90, height: 90)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 72, height: 72)
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppGradient.brandVibrant)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                VStack(spacing: 6) {
                    Text("AdBazaar")
                        .font(AppFont.display(36))
                        .foregroundStyle(.white)
                    Text("Buy. Sell. Connect.")
                        .font(AppFont.body(16))
                        .foregroundStyle(.white.opacity(0.7))
                        .offset(y: taglineOffset)
                        .opacity(opacity)
                }
                
                Spacer()
                
                // Tagline strip
                HStack(spacing: 24) {
                    ForEach(["₹10/post", "No spam", "Verified sellers"], id: \.self) { item in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.accentTeal)
                                .frame(width: 6, height: 6)
                            Text(item)
                                .font(AppFont.body(12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.bottom, 60)
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
                scale = 1.0
                opacity = 1.0
                taglineOffset = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                appState.didFinishSplash = true
            }
        }
    }
}
