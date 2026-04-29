//
//  SignupScreen.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 26/04/26.
//
import SwiftUI
import CoreLocation

// MARK: - Signup Screen
struct SignupScreen: View {
    @State private var step = 0
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var stateName = ""
    @State private var city = ""
    @State private var pincode = ""
    @State private var locality = ""
    @State private var enteredOTP = ""
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var contentOpacity: Double = 0
    @State private var showPassword = false
    @State private var resendTimer: Int = 0
    @State private var canResend = false
    @State private var keyboardHeight: CGFloat = 0
  
     @State private var userCoordinate: CLLocationCoordinate2D?

    private var otpDigits: [String] {
        let chars = Array(enteredOTP.prefix(6))
        return (0..<6).map { i in i < chars.count ? String(chars[i]) : "" }
    }
    
    var body: some View {
        ZStack {
            // Enhanced animated background
            AnimatedBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Logo Section
                    LogoSectionView()
                    
                    // Progress Indicator
                    progressSection
                    
                    // Step Content
                    stepContent
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 8)
        }
        .onAppear {
            animateEntrance()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                keyboardHeight = 0
            }
        }
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(spacing: 20) {
            // Step Title
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(stepTitle)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#0D0F2B"))
                    
                    Text(stepSubtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#9499C4"))
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            
            // Progress Indicator
            HStack(spacing: 8) {
                ForEach(0..<3) { i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(step >= i ? Color(hex: "#4F5BDB") : Color(hex: "#E8EAFF"))
                        .frame(height: 4)
                        .frame(width: step == i ? 32 : 24)
                        .animation(.spring(response: 0.4), value: step)
                }
            }
            .padding(.horizontal, 12)
            
            Text("Step \(step + 1) of 3")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(hex: "#9499C4"))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 12)
        }
        .padding(.bottom, 32)
        .offset(y: contentOffset)
        .opacity(contentOpacity)
    }
    
    // MARK: - Step Content
    @ViewBuilder
    private var stepContent: some View {
        Group {
            if step == 0 {
                Step0View(
                    fullName: $fullName,
                    email: $email,
                    phone: $phone,
                    password: $password,
                    showPassword: $showPassword,
                    onContinue: { moveToNextStep() }
                )
            } else if step == 1 {
                 Step1View(
                     stateName: $stateName,
                     city: $city,
                     pincode: $pincode,
                     locality: $locality,
                     userCoordinate: $userCoordinate,
                     onContinue: { moveToNextStep() },
                     onBack: { moveToPreviousStep() }
                 )
            } else {
                Step2View(
                    email: email,
                    otpDigits: otpDigits,
                    enteredOTP: $enteredOTP,
                    resendTimer: resendTimer,
                    canResend: canResend,
                    onResend: startResendTimer,
                    onConfirm: handleSignUp,
                    onBack: { moveToPreviousStep() }
                )
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .animation(.spring(response: 0.42, dampingFraction: 0.8), value: step)
        .offset(y: contentOffset)
        .opacity(contentOpacity)
    }
    
    // MARK: - Computed Properties
    private var stepTitle: String {
        switch step {
        case 0: return "Create account"
        case 1: return "Your location"
        default: return "Verify email"
        }
    }
    
    private var stepSubtitle: String {
        switch step {
        case 0: return "Let's get you started"
        case 1: return "Where are you based?"
        default: return email.isEmpty ? "Enter the code we sent" : "Code sent to \(email)"
        }
    }
    
    // MARK: - Functions
    private func animateEntrance() {
        withAnimation(.spring(response: 0.65, dampingFraction: 0.72).delay(0.1)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
            contentOffset = 0
            contentOpacity = 1.0
        }
    }
    
    private func moveToNextStep() {
        withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) {
            if step < 2 {
                step += 1
                if step == 2 {
                    startResendTimer()
                }
            }
        }
    }
    
    private func moveToPreviousStep() {
        withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) {
            if step > 0 {
                step -= 1
            }
        }
    }
    
    private func startResendTimer() {
        resendTimer = 30
        canResend = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if resendTimer > 0 {
                resendTimer -= 1
            } else {
                canResend = true
                timer.invalidate()
            }
        }
    }
    
    private func handleSignUp() {
        // Handle sign up
        print("Sign up completed")
    }
}

// MARK: - Step 0 View
struct Step0View: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var phone: String
    @Binding var password: String
    @Binding var showPassword: Bool
    let onContinue: () -> Void
    
    @State private var showValidation = false
    
    var isFormValid: Bool {
        !fullName.isEmpty &&
        email.contains("@") && email.contains(".") &&
        phone.count >= 10 &&
        password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: 28) {
            // Floating Fields
            FloatingField(
                label: "Full Name",
                placeholder: "Enter your full name",
                icon: "person.fill",
                text: $fullName
            )
            
            FloatingField(
                label: "Email Address",
                placeholder: "you@example.com",
                icon: "envelope.fill",
                text: $email,
                keyboardType: .emailAddress
            )
            
            FloatingField(
                label: "Phone Number",
                placeholder: "98765 43210",
                icon: "phone.fill",
                text: $phone,
                keyboardType: .numberPad
            )
            
            FloatingField(
                label: "Password",
                placeholder: "Enter password",
                icon: "lock.fill",
                text: $password,
                isSecure: true
            )
            
            // Password hint
            if !password.isEmpty {
                HStack(spacing: 12) {
                    PasswordRequirement(text: "6+ chars", isMet: password.count >= 6)
                    PasswordRequirement(text: "Number", isMet: password.contains(where: { $0.isNumber }))
                    PasswordRequirement(text: "Uppercase", isMet: password.contains(where: { $0.isUppercase }))
                }
                .transition(.opacity.combined(with: .scale))
            }
            
            // Security note
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: "#00C9A7"))
                
                Text("Your data is encrypted and never shared")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "#5A5F8A"))
                
                Spacer()
            }
            .padding(.top, 8)
            
            // Continue Button
            GradientButton(
                title: "Continue",
                isEnabled: isFormValid,
                action: onContinue
            )
            .padding(.top, 16)
            
            // Sign In link
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: "#9499C4"))
                
                Button("Sign in") { }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(hex: "#4F5BDB"))
            }
        }
    }
}

// MARK: - Step 2 View
struct Step2View: View {
    let email: String
    let otpDigits: [String]
    @Binding var enteredOTP: String
    let resendTimer: Int
    let canResend: Bool
    let onResend: () -> Void
    let onConfirm: () -> Void
    let onBack: () -> Void
    
    @State private var agreedToTerms = false
    @State private var agreedToPricing = false
    @State private var confirmedAge = false
    
    var allAgreements: Bool {
        agreedToTerms && agreedToPricing && confirmedAge
    }
    
    var body: some View {
        VStack(spacing: 28) {
            // OTP Section
            VStack(spacing: 16) {
                Text("6-DIGIT CODE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "#9499C4"))
                    .tracking(1.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // OTP Input
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPSlotView(
                            digit: otpDigits.indices.contains(index) ? otpDigits[index] : "",
                            isActive: enteredOTP.count == index
                        )
                    }
                }
                .background(
                    TextField("", text: $enteredOTP)
                        .keyboardType(.numberPad)
                        .frame(width: 0, height: 0)
                        .opacity(0)
                        .onChange(of: enteredOTP) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            enteredOTP = String(filtered.prefix(6))
                        }
                )
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                }
                
                // Resend
                HStack(spacing: 4) {
                    Text("Didn't get it?")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#9499C4"))
                    
                    if canResend {
                        Button("Resend Code") {
                            onResend()
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(hex: "#4F5BDB"))
                    } else {
                        Text("Resend in \(resendTimer)s")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(hex: "#C8CCEE"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
                .background(Color(hex: "#E8EAFF"))
            
            // Agreements Section
            VStack(spacing: 20) {
                Text("BEFORE YOU JOIN")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(hex: "#9499C4"))
                    .tracking(1.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AgreementRow(
                    icon: "doc.text.fill",
                    color: Color(hex: "#4F5BDB"),
                    text: "I agree to the Terms of Service and Privacy Policy",
                    isChecked: $agreedToTerms
                )
                
                AgreementRow(
                    icon: "indianrupeesign.circle.fill",
                    color: Color(hex: "#FF6B35"),
                    text: "Each ad post costs ₹10 — I understand this pricing",
                    isChecked: $agreedToPricing
                )
                
                AgreementRow(
                    icon: "person.badge.shield.checkmark.fill",
                    color: Color(hex: "#00C9A7"),
                    text: "I confirm I am 18 years of age or older",
                    isChecked: $confirmedAge
                )
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                GradientButton(
                    title: "Create My Account",
                    isEnabled: enteredOTP.count == 6 && allAgreements,
                    action: onConfirm
                )
                
                OutlineButton(
                    title: "Back",
                    action: onBack
                )
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Password Requirement Component
struct PasswordRequirement: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 10))
                .foregroundStyle(isMet ? Color(hex: "#00C9A7") : Color(hex: "#C8CCEE"))
            
            Text(text)
                .font(.system(size: 11))
                .foregroundStyle(isMet ? Color(hex: "#5A5F8A") : Color(hex: "#C8CCEE"))
        }
    }
}

// MARK: - OTP Slot View
struct OTPSlotView: View {
    let digit: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if digit.isEmpty {
                    if isActive {
                        Rectangle()
                            .fill(Color(hex: "#4F5BDB"))
                            .frame(width: 2, height: 24)
                            .opacity(0.8)
                    } else {
                        Text("•")
                            .font(.system(size: 24))
                            .foregroundStyle(Color(hex: "#D8DBFF"))
                    }
                } else {
                    Text(digit)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(hex: "#1B1F5E"))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(height: 40)
            .animation(.spring(response: 0.2), value: digit)
            
            Rectangle()
                .fill(!digit.isEmpty ? Color(hex: "#1B1F5E") : (isActive ? Color(hex: "#4F5BDB") : Color(hex: "#D8DBFF")))
                .frame(height: !digit.isEmpty ? 2.5 : (isActive ? 2 : 1.5))
                .animation(.spring(response: 0.25), value: digit)
                .animation(.spring(response: 0.25), value: isActive)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Agreement Row
struct AgreementRow: View {
    let icon: String
    let color: Color
    let text: String
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                isChecked.toggle()
            }
        }) {
            HStack(alignment: .top, spacing: 12) {
                // Custom Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isChecked ? Color(hex: "#1B1F5E") : Color.white)
                        .frame(width: 20, height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isChecked ? Color.clear : Color(hex: "#C8CCEE"), lineWidth: 1.5)
                        )
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)
                
                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(isChecked ? Color(hex: "#0D0F2B") : Color(hex: "#5A5F8A"))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}




// MARK: - Animated Background
struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                // Animated Gradient Blobs
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#4F5BDB").opacity(0.08), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(x: animate ? geo.size.width - 100 : geo.size.width - 200, y: -100)
                    .blur(radius: 60)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B35").opacity(0.07), .clear],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .frame(width: 350, height: 350)
                    .offset(x: animate ? -50 : -100, y: geo.size.height * 0.3)
                    .blur(radius: 55)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#00C9A7").opacity(0.06), .clear],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(x: animate ? geo.size.width * 0.5 : geo.size.width * 0.6, y: geo.size.height * 0.8)
                    .blur(radius: 50)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }
}


// MARK: - Preview
//#Preview {
//    SignupScreen()
//}
