//
//  SignupScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 26/04/26.
//


import SwiftUI


// MARK: - Signup Screen
struct SignupScreen: View {
    @State private var step = 0
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var state = ""
    @State private var city = ""
    @State private var pincode = ""
    @State private var locality = ""
    @State private var otpDigits = ["", "", "", "", "", ""]
    @State private var isComplete = false
    
    var body: some View {
        ZStack {
            AppGradient.surfaceSubtle.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar
                ZStack {
                    AppGradient.brandPrimary
                    VStack(spacing: 12) {
                        // Progress bar
                        HStack(spacing: 6) {
                            ForEach(0..<3) { i in
                                Capsule()
                                    .fill(i <= step ? Color.white : Color.white.opacity(0.25))
                                    .frame(height: 4)
                                    .animation(.spring(), value: step)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Text(stepTitles[step])
                            .font(AppFont.display(22))
                            .foregroundStyle(.white)
                        Text(stepSubtitles[step])
                            .font(AppFont.body(13))
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 24)
                }
                .frame(height: 180)
                .clipShape(BottomRoundedShape(radius: 32))
                .ignoresSafeArea(edges: .top)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        Group {
                            if step == 0 { step0 }
                            else if step == 1 { step1 }
                            else { step2 }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    var step0: some View {
        VStack(spacing: 16) {
            FloatingField(label: "Full Name", placeholder: "Ravi Kumar", icon: "person.fill", text: $fullName)
            FloatingField(label: "Email Address", placeholder: "you@example.com", icon: "envelope.fill", text: $email, keyboardType: .emailAddress)
            // Phone with country code
            VStack(alignment: .leading, spacing: 0) {
                Text("Mobile Number")
                    .font(AppFont.body(11, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
                    .textCase(.uppercase)
                    .tracking(0.8)
                    .padding(.bottom, 4)
                HStack(spacing: 0) {
                    HStack(spacing: 6) {
                        Text("🇮🇳").font(.system(size: 16))
                        Text("+91")
                            .font(AppFont.heading(14))
                            .foregroundStyle(Color.textPrimary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color.textTertiary)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 50)
                    .background(Color.surfaceTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    TextField("98765 43210", text: $phone)
                        .font(AppFont.body(16))
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.leading, 6)
                }
            }
            FloatingField(label: "Password", placeholder: "Min. 8 characters", icon: "lock.fill", text: $password, isSecure: true)
            
            PrimaryButton("Continue", icon: "arrow.right") {
                withAnimation(.spring()) { step = 1 }
            }
            
            HStack(spacing: 4) {
                Text("Already have an account?").font(AppFont.body(13)).foregroundStyle(Color.textSecondary)
                Button("Sign In") {}.font(AppFont.heading(13)).foregroundStyle(Color.brandAccent)
            }
        }
    }
    
    var step1: some View {
        VStack(spacing: 16) {
            // State picker mock
            VStack(alignment: .leading, spacing: 0) {
                Text("State")
                    .font(AppFont.body(11, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
                    .textCase(.uppercase)
                    .tracking(0.8)
                    .padding(.bottom, 4)
                HStack {
                    Image(systemName: "map.fill").font(.system(size: 15)).foregroundStyle(Color.textTertiary).frame(width: 20)
                    Text("Punjab").font(AppFont.body(16)).foregroundStyle(Color.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.down").font(.system(size: 12)).foregroundStyle(Color.textTertiary)
                }
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color.surfaceSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            FloatingField(label: "City / District", placeholder: "Chandigarh", icon: "building.2.fill", text: $city)
            FloatingField(label: "Pincode", placeholder: "160017", icon: "mappin.circle.fill", text: $pincode, keyboardType: .numberPad)
            FloatingField(label: "Locality / Area (Optional)", placeholder: "Sector 17", icon: "location.fill", text: $locality)
            
            // Location tip card
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.brandAccent)
                Text("Your pincode helps show ads to nearby buyers first.")
                    .font(AppFont.body(12))
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(14)
            .background(Color.brandAccent.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            PrimaryButton("Continue", icon: "arrow.right") {
                withAnimation(.spring()) { step = 2 }
            }
            SecondaryButton(title: "← Back") {
                withAnimation(.spring()) { step = 0 }
            }
        }
    }
    
    var step2: some View {
        VStack(spacing: 20) {
            // OTP input
            VStack(spacing: 12) {
                Text("Enter the 6-digit code sent to\n\(email.isEmpty ? "your email" : email)")
                    .font(AppFont.body(14))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { i in
                        OTPBox(digit: $otpDigits[i], isFilled: !otpDigits[i].isEmpty)
                    }
                }
                
                Button("Resend code in 42s") {}
                    .font(AppFont.body(12, weight: .medium))
                    .foregroundStyle(Color.textTertiary)
            }
            
            // Consent checkboxes
            VStack(alignment: .leading, spacing: 12) {
                Text("Before you continue")
                    .font(AppFont.heading(13))
                    .foregroundStyle(Color.textSecondary)
                
                ConsentRow(text: "I agree to the Terms of Service and Privacy Policy")
                ConsentRow(text: "I understand each ad post costs ₹10 to reduce spam and scams", isPrimary: true)
                ConsentRow(text: "I confirm I am 18 years of age or older")
            }
            .padding(16)
            .background(Color.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .cardShadow()
            
            PrimaryButton("Verify & Create Account ✓") {}
            SecondaryButton(title: "← Back") {
                withAnimation(.spring()) { step = 1 }
            }
        }
    }
    
    let stepTitles = ["Create account", "Your location", "Verify email"]
    let stepSubtitles = ["Step 1 of 3 — Basic details", "Step 2 of 3 — Where are you?", "Step 3 of 3 — Almost done!"]
}

struct OTPBox: View {
    @Binding var digit: String
    var isFilled: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isFilled ? Color.brandAccent.opacity(0.1) : Color.surfaceSecondary)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isFilled ? Color.brandAccent : Color.textTertiary.opacity(0.3), lineWidth: isFilled ? 1.5 : 0.5))
            Text(isFilled ? digit : "–")
                .font(AppFont.display(20))
                .foregroundStyle(isFilled ? Color.brand : Color.textTertiary)
        }
        .frame(width: 44, height: 50)
    }
}

struct ConsentRow: View {
    let text: String
    var isPrimary: Bool = false
    @State private var isChecked = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Button { isChecked.toggle() } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isChecked ? Color.brand : Color.surfaceSecondary)
                        .frame(width: 20, height: 20)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(isChecked ? Color.clear : Color.textTertiary.opacity(0.5), lineWidth: 1))
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            
            Text(text)
                .font(AppFont.body(13))
                .foregroundStyle(isPrimary ? Color.textPrimary : Color.textSecondary)
                .lineSpacing(3)
        }
    }
}

// MARK: - Shape helpers
struct BottomRoundedShape: Shape {
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.width - radius, y: rect.height),
            control: CGPoint(x: rect.width, y: rect.height)
        )
        path.addLine(to: CGPoint(x: radius, y: rect.height))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - radius),
            control: CGPoint(x: 0, y: rect.height)
        )
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}

//
