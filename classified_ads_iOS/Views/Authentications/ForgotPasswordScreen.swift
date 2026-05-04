//
//  ForgotPasswordScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 04/05/26.
//


import SwiftUI

// MARK: - Forgot Password Screen
struct ForgotPasswordScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var isLoading = false
    @State private var isEmailSent = false
    @State private var navigateToOTP = false
    
    var body: some View {
        ZStack {
            AppGradient.surfaceSubtle.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    LogoSectionView(
                        title: "Forgot Password",
                        subtitle: "Enter your email to receive reset instructions"
                    )
                    
                    VStack(spacing: 25) {
                        
                        FloatingField(
                            label: "Email Address",
                            placeholder: "you@example.com",
                            icon: "envelope.fill",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                        
                        PrimaryButton(
                            "Send OTP",
                            icon: "paperplane.fill",
                            isLoading: isLoading
                        ) {
                            sendResetLink()
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                Text("Back to Sign In")
                            }
                            .font(AppFont.heading(14))
                            .foregroundStyle(Color.brandAccent)
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToOTP) {
            OTPScreen(email: email)
        }
    }
    
    private func sendResetLink() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            navigateToOTP = true
        }
    }
}
