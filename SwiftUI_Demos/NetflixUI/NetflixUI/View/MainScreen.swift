//
//  MainScreen.swift
//  NetflixUI
//
//  Created by Lurich on 2024/4/13.
//

import SwiftUI

struct MainScreen: View {
    @Environment(AppData.self) private var appData
    
    var body: some View {
        VStack {
            Group {
                switch appData.activeTab {
                case .home:
                    Text("Home")
                case .new:
                    Text("New")
                case .account:
                    Text("Account")
                }
            }
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar()
        }
        .coordinateSpace(.named("MAIN_SCREEN"))
    }
}

#Preview {
    MainScreen()
        .environment(AppData())
        .preferredColorScheme(.dark)
}
