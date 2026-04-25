//
//  LoginScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 26/04/26.
//

import SwiftUI

// MARK: - Login Screen
struct LoginScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var isRedirectToSignup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradient.surfaceSubtle.ignoresSafeArea()
                
                GeometryReader { geo in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            LoginHeaderView()
                                .offset(y: -geo.safeAreaInsets.top)
                            
                            // Form
                            VStack(spacing: 16) {
                                FloatingField(
                                    label: "Email Address",
                                    placeholder: "you@example.com",
                                    icon: "envelope.fill",
                                    text: $email,
                                    keyboardType: .emailAddress
                                )
                                
                                FloatingField(
                                    label: "Password",
                                    placeholder: "Enter password",
                                    icon: "lock.fill",
                                    text: $password,
                                    isSecure: true
                                )
                                
                                HStack {
                                    Spacer()
                                    Button("Forgot Password?") {}
                                        .font(AppFont.body(13, weight: .medium))
                                        .foregroundStyle(Color.brandAccent)
                                }
                                
                                PrimaryButton("Sign In", icon: "arrow.right", isLoading: isLoading) {
                                    isLoading = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        isLoading = false
                                    }
                                }
                                
                                HStack {
                                    Rectangle().fill(Color.textTertiary.opacity(0.3)).frame(height: 0.5)
                                    Text("or continue with")
                                        .font(AppFont.body(12))
                                        .foregroundStyle(Color.textTertiary)
                                    Rectangle().fill(Color.textTertiary.opacity(0.3)).frame(height: 0.5)
                                }
                                
                                HStack(spacing: 12) {
                                    SocialLoginButton(icon: "apple.logo", label: "Apple") {}
                                    SocialLoginButton(icon: "g.circle.fill", label: "Google") {}
                                }
                                
                                HStack(spacing: 4) {
                                    Text("Don't have an account?")
                                        .font(AppFont.body(14))
                                        .foregroundStyle(Color.textSecondary)
                                    
                                    Button("Sign Up") {
                                        isRedirectToSignup = true
                                    }
                                    .font(AppFont.heading(14))
                                    .foregroundStyle(Color.brandAccent)
                                }
                                .padding(.top, 4)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 28)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isRedirectToSignup) {
                SignupScreen()
            }
        }
    }
}

struct LoginHeaderView: View {
    @State private var float = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            AppGradient.brandPrimary
                .clipShape(WaveBottomShape())
                .frame(height: 320)
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.18),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Ambient shapes
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 220, height: 220)
                .offset(x: 140, y: float ? -60 : -90)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: float)
            
            Circle()
                .fill(Color.accentOrange.opacity(0.18))
                .frame(width: 120, height: 120)
                .offset(x: -130, y: float ? 10 : 40)
            //                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: float)
            
            // Content
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                        .frame(width: 66, height: 66)
                        .shadow(color: .black.opacity(0.25), radius: 20, y: 10)
                    
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }
                .offset(y: float ? -6 : 6)
                //                .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: float)
                
                Text("Welcome back")
                    .font(AppFont.display(28))
                    .foregroundStyle(.white)
                
                Text("Sign in to continue")
                    .font(AppFont.body(14))
                    .bold()
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.bottom, 46)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { float = true }
    }
}

struct WaveBottomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 40))
        
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height - 40),
            control1: CGPoint(x: rect.width * 0.75, y: rect.height),
            control2: CGPoint(x: rect.width * 0.25, y: rect.height - 80)
        )
        
        path.closeSubpath()
        return path
    }
}

struct SocialLoginButton: View {
    let icon: String
    let label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                Text(label)
                    .font(AppFont.heading(14))
            }
            .foregroundStyle(Color.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.textTertiary.opacity(0.3), lineWidth: 1))
            .subtleShadow()
        }
        .buttonStyle(.plain)
    }
}
