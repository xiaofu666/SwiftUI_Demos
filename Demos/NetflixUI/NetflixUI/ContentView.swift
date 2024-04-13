//
//  ContentView.swift
//  NetflixUI
//
//  Created by Lurich on 2024/4/13.
//

import SwiftUI

struct ContentView: View {
    private var appData: AppData = .init()
    var body: some View {
        ZStack {
            MainScreen()
            
            if appData.hideMainView {
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
            }
            
            if appData.showProfileView {
                ZStack {
                    ProfileScreen()
                }
                .animation(.snappy, value: appData.showProfileView)
            }
            
            if !appData.isSplashFinished {
                SplashScreen()
            }
        }
        .environment(appData)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
