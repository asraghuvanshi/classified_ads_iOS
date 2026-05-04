//
//  OTPScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 04/05/26.
//


import SwiftUI

// MARK: - OTP Verification Screen
struct OTPScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    let email: String
    
    @State private var otp = ["", "", "", "", "", ""]
    @State private var isLoading = false
    @State private var timeRemaining = 60
    @State private var canResend = false
    
    var body: some View {
        ZStack {
            AppGradient.surfaceSubtle.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // Header
                    LogoSectionView(
                        title: "Verify OTP",
                        subtitle: "Enter the 6-digit code sent to \(email)"
                    )
                    
                    VStack(spacing: 20) {
                        
                        // OTP Fields
                        HStack(spacing: 12) {
                            ForEach(0..<6, id: \.self) { index in
                                OTPTextField(
                                    text: $otp[index]
                                )
                            }
                        }
                        
                        // Timer
                        if canResend {
                            Button("Resend OTP") {
                                resendOTP()
                            }
                            .font(AppFont.heading(14))
                            .foregroundStyle(Color.brandAccent)
                        } else {
                            Text("Resend OTP in \(timeRemaining)s")
                                .font(AppFont.body(13))
                                .foregroundStyle(Color.textSecondary)
                        }
                        
                        // Verify Button
                        PrimaryButton(
                            "Verify & Continue",
                            icon: "checkmark.circle.fill",
                            isLoading: isLoading
                        ) {
                            verifyOTP()
                        }
                        .disabled(!isOTPValid)
                        
                        // Back
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(AppFont.heading(14))
                            .foregroundStyle(Color.brandAccent)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: startTimer)
    }
    
    // MARK: - Computed
    private var isOTPValid: Bool {
        otp.joined().count == 6
    }
    
    // MARK: - Actions
    private func verifyOTP() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            // Navigate to reset password / home
        }
    }
    
    private func resendOTP() {
        otp = Array(repeating: "", count: 6)
        timeRemaining = 60
        canResend = false
        startTimer()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                canResend = true
            }
        }
    }
}


struct OTPTextField: View {
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(AppFont.heading(18))
            .frame(width: 46, height: 52)
            .background(Color.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.textTertiary.opacity(0.3), lineWidth: 1)
            )
            .onChange(of: text) { newValue in
                if newValue.count > 1 {
                    text = String(newValue.last ?? Character(""))
                }
            }
    }
}
