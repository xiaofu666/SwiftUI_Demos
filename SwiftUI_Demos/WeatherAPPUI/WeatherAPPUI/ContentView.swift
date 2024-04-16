//
//  ContentView.swift
//  WeatherAPPUI
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeatherAPPUI()
                .tabItem {
                    Image(systemName: "cloud.drizzle.circle.fill")
                    Text("样式1")
                }
                .tag(1)
            
            WeatherApp()
                .tabItem {
                    Image(systemName: "cloud.drizzle.circle.fill")
                    Text("样式2")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
