//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Lurich on 2023/12/16.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(.isFirstTime) private var isFirstTime: Bool = true
    @AppStorage(.isAppLockEnabled) private var isAppLockEnabled: Bool = false
    @AppStorage(.lockWhenAppGoesBackground) private var lockWhenAppGoesBackground: Bool = false
    
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        LockView(lockType: .biometric, lockPin: "1234", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection: $activeTab) {
                Recents()
                    .tag(Tab.recents)
                    .tabItem {
                        Tab.recents.tabContent
                    }
                
                Search()
                    .tag(Tab.search)
                    .tabItem {
                        Tab.search.tabContent
                    }
                
                Charts()
                    .tag(Tab.charts)
                    .tabItem {
                        Tab.charts.tabContent
                    }
                
                Settings()
                    .tag(Tab.settings)
                    .tabItem {
                        Tab.settings.tabContent
                    }
            }
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        }
    }
}

#Preview {
    ContentView()
}
