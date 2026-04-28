//
//  FloatingTextField.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 28/04/26.
//

import SwiftUI

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
