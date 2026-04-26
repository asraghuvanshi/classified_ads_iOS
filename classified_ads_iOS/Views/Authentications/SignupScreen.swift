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
    @State private var stateName = ""
    @State private var city = ""
    @State private var pincode = ""
    @State private var locality = ""
    @State private var enteredOTP = ""
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    @State private var contentOpacity: Double = 0

    private var otpDigits: [String] {
        let chars = Array(enteredOTP.prefix(6))
        return (0..<6).map { i in i < chars.count ? String(chars[i]) : "" }
    }

    var body: some View {
        ZStack {
            // ── Background             Color(hex: "#FAFBFF").ignoresSafeArea()

            // Soft ambient blobs
            GeometryReader { geo in
                ZStack {
                    RadialGradient(
                        colors: [Color(hex: "#4F5BDB").opacity(0.18), .clear],
                        center: .center, startRadius: 0, endRadius: 180
                    )
                    .frame(width: 360, height: 360)
                    .offset(x: geo.size.width - 60, y: -80)

                    RadialGradient(
                        colors: [Color(hex: "#FF6B35").opacity(0.13), .clear],
                        center: .center, startRadius: 0, endRadius: 150
                    )
                    .frame(width: 300, height: 300)
                    .offset(x: -80, y: geo.size.height * 0.3)

                    RadialGradient(
                        colors: [Color(hex: "#00C9A7").opacity(0.12), .clear],
                        center: .center, startRadius: 0, endRadius: 140
                    )
                    .frame(width: 280, height: 280)
                    .offset(x: geo.size.width * 0.5, y: geo.size.height * 0.75)
                }
            }
            .ignoresSafeArea()

            // ── Main content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Logo
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(Color(hex: "#4F5BDB").opacity(0.15), lineWidth: 1)
                                .frame(width: 72, height: 72)
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#1B1F5E"), Color(hex: "#4F5BDB")],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)

                        Text("AdBazaar")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#1B1F5E"))
                            .opacity(logoOpacity)
                    }
                    .padding(.top, 64)
                    .padding(.bottom, 36)

                    // ── Step content
                    ZStack {
                        if step == 0 { step0View.transition(slide) }
                        else if step == 1 { step1View.transition(slide) }
                        else { step2View.transition(slide) }
                    }
                    .animation(.spring(response: 0.42, dampingFraction: 0.8), value: step)
                    .offset(y: contentOffset)
                    .opacity(contentOpacity)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 56)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.72).delay(0.1)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
                contentOffset = 0
                contentOpacity = 1.0
            }
        }
    }

    private var slide: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        )
    }

    // MARK: ── Step 0
    private var step0View: some View {
        VStack(alignment: .leading, spacing: 0) {
            stepHeader(emoji: "👋", title: "Create account", subtitle: "Let's get you started")
            progressDots(current: 0).padding(.bottom, 36)

            VStack(spacing: 28) {
                UnderlineField(label: "Full Name", placeholder: "Ravi Kumar",
                               icon: "person.fill", accent: Color(hex: "#4F5BDB"), text: $fullName)
                UnderlineField(label: "Email Address", placeholder: "you@example.com",
                               icon: "envelope.fill", accent: Color(hex: "#FF6B35"), text: $email,
                               keyboard: .emailAddress)
                UnderlinePhoneField(phone: $phone)
                UnderlineField(label: "Password", placeholder: "Min. 8 characters",
                               icon: "lock.fill", accent: Color(hex: "#7C3AED"), text: $password,
                               isSecure: true)
            }
            .padding(.bottom, 28)

            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill").font(.system(size: 13)).foregroundStyle(Color(hex: "#00C9A7"))
                Text("Your data is encrypted and never shared")
                    .font(.system(size: 12, weight: .medium)).foregroundStyle(Color(hex: "#5A5F8A"))
            }
            .padding(.bottom, 36)

            FlatButton(label: "Continue", style: .primary) {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) { step = 1 }
            }
            .padding(.bottom, 16)

            HStack(spacing: 4) {
                Text("Already have an account?").font(.system(size: 13)).foregroundStyle(Color(hex: "#9499C4"))
                Button("Sign in") {}.font(.system(size: 13, weight: .semibold)).foregroundStyle(Color(hex: "#4F5BDB"))
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    // MARK: ── Step 1
    private var step1View: some View {
        VStack(alignment: .leading, spacing: 0) {
            stepHeader(emoji: "📍", title: "Your location", subtitle: "Where are you based?")
            progressDots(current: 1).padding(.bottom, 36)

            VStack(spacing: 28) {
                UnderlineStatePicker(selected: $stateName)
                UnderlineField(label: "City / District", placeholder: "Chandigarh",
                               icon: "building.2.fill", accent: Color(hex: "#FF6B35"), text: $city)
                UnderlineField(label: "Pincode", placeholder: "160017",
                               icon: "mappin.circle.fill", accent: Color(hex: "#4F5BDB"), text: $pincode,
                               keyboard: .numberPad)
                UnderlineField(label: "Locality / Area (Optional)", placeholder: "Sector 17",
                               icon: "location.fill", accent: Color(hex: "#00C9A7"), text: $locality)
            }
            .padding(.bottom, 28)

            HStack(spacing: 8) {
                Image(systemName: "location.north.circle.fill").font(.system(size: 13)).foregroundStyle(Color(hex: "#4F5BDB"))
                Text("Pincode helps rank your ads to nearby buyers first")
                    .font(.system(size: 12, weight: .medium)).foregroundStyle(Color(hex: "#5A5F8A"))
            }
            .padding(.bottom, 36)

            FlatButton(label: "Continue", style: .primary) {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) { step = 2 }
            }
            .padding(.bottom, 12)

            FlatButton(label: "Back", style: .ghost) {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) { step = 0 }
            }
        }
    }

    // MARK: ── Step 2
    private var step2View: some View {
        VStack(alignment: .leading, spacing: 0) {
            stepHeader(emoji: "✉️", title: "Verify email",
                       subtitle: email.isEmpty ? "Enter the code we sent" : "Code sent to \(email)")
            progressDots(current: 2).padding(.bottom, 40)

            // OTP label
            Text("6-DIGIT CODE")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color(hex: "#9499C4"))
                .tracking(1.4)
                .padding(.bottom, 18)

            // OTP display
            ZStack {
                // Hidden keyboard capture
                TextField("", text: $enteredOTP)
                    .keyboardType(.numberPad)
                    .frame(width: 1, height: 1)
                    .opacity(0.011)
                    .onChange(of: enteredOTP) { val in
                        let f = val.filter { $0.isNumber }
                        enteredOTP = f.count <= 6 ? f : String(f.prefix(6))
                    }

                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { i in
                        OTPUnderlineBox(
                            digit: otpDigits[i],
                            isActive: otpDigits[i].isEmpty && (i == 0 || (i > 0 && !otpDigits[i-1].isEmpty))
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .padding(.bottom, 16)

            // Resend
            HStack(spacing: 4) {
                Text("Didn't get it?").font(.system(size: 12)).foregroundStyle(Color(hex: "#9499C4"))
                Button("Resend in 42s") {}
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(Color(hex: "#4F5BDB"))
            }
            .padding(.bottom, 44)

            // Divider
            Rectangle().fill(Color(hex: "#E8EAFF")).frame(height: 1).padding(.bottom, 28)

            // Consent heading
            Text("BEFORE YOU JOIN")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color(hex: "#9499C4"))
                .tracking(1.4)
                .padding(.bottom, 20)

            // Consent rows — open, no card
            VStack(spacing: 0) {
                OpenConsentRow(icon: "doc.text.fill", color: Color(hex: "#4F5BDB"),
                               text: "I agree to the Terms of Service and Privacy Policy")
                OpenConsentRow(icon: "indianrupeesign.circle.fill", color: Color(hex: "#FF6B35"),
                               text: "Each ad post costs ₹10 — I understand this pricing", bold: true)
                OpenConsentRow(icon: "person.badge.shield.checkmark.fill", color: Color(hex: "#00C9A7"),
                               text: "I confirm I am 18 years of age or older")
            }
            .padding(.bottom, 36)

            FlatButton(label: "Create My Account", style: .primary) {}
                .padding(.bottom, 12)

            FlatButton(label: "Back", style: .ghost) {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.8)) { step = 1 }
            }
        }
    }

    // MARK: ── Shared sub-views
    @ViewBuilder
    private func stepHeader(emoji: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(emoji).font(.system(size: 34)).padding(.bottom, 2)
            Text(title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: "#0D0F2B"))
            Text(subtitle)
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "#9499C4"))
        }
        .padding(.bottom, 22)
    }

    @ViewBuilder
    private func progressDots(current: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { i in
                if i == current {
                    Capsule()
                        .fill(Color(hex: "#1B1F5E"))
                        .frame(width: 26, height: 7)
                } else if i < current {
                    Circle().fill(Color(hex: "#00C9A7")).frame(width: 7, height: 7)
                } else {
                    Circle().fill(Color(hex: "#D8DBFF")).frame(width: 7, height: 7)
                }
            }
            Spacer()
            Text("Step \(current + 1) of 3")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color(hex: "#9499C4"))
        }
        .animation(.spring(response: 0.4), value: current)
    }
}

// MARK: - Flat Button 
enum FlatButtonStyle { case primary, ghost }

struct FlatButton: View {
    let label: String
    let style: FlatButtonStyle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundStyle(style == .primary ? .white : Color(hex: "#5A5F8A"))
                .background {
                    if style == .primary {
                        LinearGradient(
                            colors: [Color(hex: "#1B1F5E"), Color(hex: "#4F5BDB")],
                            startPoint: .leading, endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color(hex: "#1B1F5E").opacity(0.28), radius: 14, x: 0, y: 7)
                    } else {
                        Color.clear
                    }
                }
                .overlay {
                    if style == .ghost {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#D8DBFF"), lineWidth: 1.5)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Underline Field
struct UnderlineField: View {
    let label: String
    let placeholder: String
    let icon: String
    let accent: Color
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var isSecure: Bool = false
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label + tick
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(focused ? accent : Color(hex: "#9499C4"))
                Text(label.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(focused ? accent : Color(hex: "#9499C4"))
                    .tracking(0.9)
                Spacer()
                if !text.isEmpty {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#00C9A7"))
                        .transition(.scale(scale: 0.3).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: focused)
            .animation(.spring(response: 0.3), value: text.isEmpty)

            // Input
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text).focused($focused)
                } else {
                    TextField(placeholder, text: $text).keyboardType(keyboard).focused($focused)
                }
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(Color(hex: "#0D0F2B"))
            .tint(accent)

            // Animated underline
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(hex: "#E8EAFF")).frame(height: 1.5)
                    Rectangle()
                        .fill(accent)
                        .frame(width: focused ? geo.size.width : 0, height: 2.5)
                        .animation(.spring(response: 0.38, dampingFraction: 0.72), value: focused)
                }
            }
            .frame(height: 2.5)
        }
    }
}

// MARK: - Underline Phone Field
struct UnderlinePhoneField: View {
    @Binding var phone: String
    @FocusState private var focused: Bool
    private let accent = Color(hex: "#00C9A7")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(focused ? accent : Color(hex: "#9499C4"))
                Text("MOBILE NUMBER")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(focused ? accent : Color(hex: "#9499C4"))
                    .tracking(0.9)
                Spacer()
                if !phone.isEmpty {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 14)).foregroundStyle(accent)
                        .transition(.scale(scale: 0.3).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: focused)

            HStack(spacing: 14) {
                HStack(spacing: 5) {
                    Text("🇮🇳").font(.system(size: 16))
                    Text("+91").font(.system(size: 17, weight: .semibold)).foregroundStyle(Color(hex: "#0D0F2B"))
                    Image(systemName: "chevron.down").font(.system(size: 9, weight: .bold)).foregroundStyle(Color(hex: "#9499C4"))
                }
                Rectangle().fill(Color(hex: "#E0E2F8")).frame(width: 1, height: 22)
                TextField("98765 43210", text: $phone)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(hex: "#0D0F2B"))
                    .keyboardType(.phonePad)
                    .focused($focused)
                    .tint(accent)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(hex: "#E8EAFF")).frame(height: 1.5)
                    Rectangle()
                        .fill(accent)
                        .frame(width: focused ? geo.size.width : 0, height: 2.5)
                        .animation(.spring(response: 0.38, dampingFraction: 0.72), value: focused)
                }
            }
            .frame(height: 2.5)
        }
    }
}

// MARK: - Underline State Picker
struct UnderlineStatePicker: View {
    @Binding var selected: String
    let states = ["Punjab", "Haryana", "Delhi", "Himachal Pradesh", "Uttarakhand", "Rajasthan", "Uttar Pradesh", "Maharashtra"]
    @State private var open = false
    private let accent = Color(hex: "#FF6B35")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "map.fill").font(.system(size: 11, weight: .bold)).foregroundStyle(open ? accent : Color(hex: "#9499C4"))
                Text("STATE").font(.system(size: 10, weight: .bold)).foregroundStyle(open ? accent : Color(hex: "#9499C4")).tracking(0.9)
                Spacer()
                if !selected.isEmpty {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 14)).foregroundStyle(Color(hex: "#00C9A7"))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: open)

            Button { withAnimation(.spring(response: 0.32)) { open.toggle() } } label: {
                HStack {
                    Text(selected.isEmpty ? "Select your state" : selected)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(selected.isEmpty ? Color(hex: "#C8CCEE") : Color(hex: "#0D0F2B"))
                    Spacer()
                    Image(systemName: open ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(hex: "#9499C4"))
                }
            }
            .buttonStyle(.plain)

            // Underline
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(hex: "#E8EAFF")).frame(height: 1.5)
                    Rectangle()
                        .fill(accent)
                        .frame(width: open ? geo.size.width : 0, height: 2.5)
                        .animation(.spring(response: 0.38, dampingFraction: 0.72), value: open)
                }
            }
            .frame(height: 2.5)

            // Dropdown — open rows, no card
            if open {
                VStack(spacing: 0) {
                    ForEach(states, id: \.self) { s in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selected = s; open = false }
                        } label: {
                            HStack {
                                Text(s)
                                    .font(.system(size: 15, weight: selected == s ? .semibold : .regular))
                                    .foregroundStyle(selected == s ? accent : Color(hex: "#3A3F6B"))
                                Spacer()
                                if selected == s {
                                    Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundStyle(accent)
                                }
                            }
                            .padding(.vertical, 11)
                        }
                        .buttonStyle(.plain)
                        if s != states.last {
                            Rectangle().fill(Color(hex: "#F0F1FF")).frame(height: 1)
                        }
                    }
                }
                .padding(.top, 6)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - OTP Underline Box (non-editable)
struct OTPUnderlineBox: View {
    let digit: String
    var isActive: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            // Digit / cursor / placeholder
            ZStack {
                if digit.isEmpty {
                    if isActive {
                        Capsule()
                            .fill(Color(hex: "#4F5BDB"))
                            .frame(width: 2, height: 28)
                            .opacity(0.85)
                    } else {
                        Text("–")
                            .font(.system(size: 26, weight: .light))
                            .foregroundStyle(Color(hex: "#D8DBFF"))
                    }
                } else {
                    Text(digit)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "#1B1F5E"))
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.4).combined(with: .opacity),
                            removal:   .scale(scale: 1.4).combined(with: .opacity)
                        ))
                }
            }
            .frame(height: 36)
            .animation(.spring(response: 0.2, dampingFraction: 0.65), value: digit)

            // Underline
            Rectangle()
                .fill(
                    digit.isEmpty
                        ? (isActive ? Color(hex: "#4F5BDB") : Color(hex: "#D8DBFF"))
                        : Color(hex: "#1B1F5E")
                )
                .frame(height: digit.isEmpty ? (isActive ? 2.5 : 1.5) : 2.5)
                .animation(.spring(response: 0.25), value: isActive)
                .animation(.spring(response: 0.25), value: digit)
        }
    }
}

// MARK: - Open Consent Row
struct OpenConsentRow: View {
    let icon: String
    let color: Color
    let text: String
    var bold: Bool = false
    @State private var checked = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) { checked.toggle() }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(checked ? Color(hex: "#1B1F5E") : Color.clear)
                        .frame(width: 22, height: 22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(checked ? Color.clear : Color(hex: "#C8CCEE"), lineWidth: 1.5)
                        )
                    if checked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .transition(.scale(scale: 0.2).combined(with: .opacity))
                    }
                }
                .padding(.top, 1)

                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundStyle(color)
                    .padding(.top, 3)

                Text(text)
                    .font(.system(size: 13, weight: bold ? .semibold : .regular))
                    .foregroundStyle(bold ? Color(hex: "#0D0F2B") : Color(hex: "#5A5F8A"))
                    .lineSpacing(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .padding(.bottom, 18)
    }
}

// MARK: - Preview
#Preview {
    SignupScreen()
}
