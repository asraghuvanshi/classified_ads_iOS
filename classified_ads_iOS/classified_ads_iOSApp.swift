//
//  classified_ads_iOSApp.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 24/04/26.
//

import SwiftUI
import Combine

@main
struct classified_ads_iOSApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.didFinishSplash {
                SplashScreen()
            } else if appState.isLoggedIn {
                MainTabView()
            } else {
                AuthFlowView()
            }
        }
    }
}

struct AuthFlowView: View {
    var body: some View {
        NavigationStack {
            LoginScreen()
        }
    }
}

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var didFinishSplash: Bool = false

    init() {
        checkLoginStatus()
    }

    func checkLoginStatus() {
        // Example: token check
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
