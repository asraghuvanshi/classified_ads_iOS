//
//  MainTabView.swift
//  classified_ads_iOS
//
//  Created by iOS Developer on 30/04/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { }
                .tabItem { Label("Home", systemImage: "house") }

            NavigationStack {  }
                .tabItem { Label("Chat", systemImage: "message") }

            NavigationStack {  }
                .tabItem { Label("Post", systemImage: "plus.circle") }

            NavigationStack {  }
                .tabItem { Label("Profile", systemImage: "person") }
        }
    }
}
