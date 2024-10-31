//
//  Home.swift
//  AppleMusicMiniPlayer
//
//  Created by Xiaofu666 on 2024/10/30.
//

import SwiftUI

struct Home: View {
    @State private var showMiniPlayer: Bool = false
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house") {
                Text("Home")
            }
            Tab.init("Search", systemImage: "magnifyingglass") {
                Text("Search")
            }
            Tab.init("Notifications", systemImage: "bell") {
                Text("Notifications")
            }
            Tab.init("Settings", systemImage: "gearshape") {
                Text("Settings")
            }
        }
        .universalOverlay(show: $showMiniPlayer) {
            ExpandableMusicPlayer(show: $showMiniPlayer)
        }
        .onAppear {
            showMiniPlayer = true
        }
    }
}

#Preview {
    ContentView()
}
