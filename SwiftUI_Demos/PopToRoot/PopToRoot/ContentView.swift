//
//  ContentView.swift
//  PopToRoot
//
//  Created by Lurich on 2024/2/20.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: Tab = .home
    @State private var homeStack: NavigationPath = .init()
    @State private var settingStack: NavigationPath = .init()
    @State private var tapCount: Int = .zero
    
    var body: some View {
        TabView(selection: tabSelection,
                content:  {
            NavigationStack(path: $homeStack) {
                List {
                    NavigationLink("Detail", value: "Detail")
                }
                .navigationTitle(Tab.home.rawValue)
                .navigationDestination(for: String.self) { value in
                    List {
                        if value == "Detail" {
                            NavigationLink("More", value: "More")
                        }
                    }
                    .navigationTitle(value)
                }
            }
            .tag(Tab.home)
            .tabItem {
                Image(systemName: Tab.home.symbolImage)
                Text(Tab.home.rawValue)
            }
            
            NavigationStack(path: $settingStack) {
                List {
                    
                }
                .navigationTitle(Tab.settings.rawValue)
            }
            .tag(Tab.settings)
            .tabItem {
                Image(systemName: Tab.settings.symbolImage)
                Text(Tab.settings.rawValue)
            }
        })
    }
    
    var tabSelection: Binding<Tab> {
        return .init {
            return activeTab
        } set: { newValue in
            if newValue == activeTab {
                print("pop to root")
                tapCount += 1
                if tapCount == 2 {
                    switch newValue {
                    case .home:
                        homeStack = .init()
                    case .settings:
                        settingStack = .init()
                    }
                    tapCount = .zero
                }
            } else {
                tapCount = .zero
            }
            activeTab = newValue
        }
    }
}

#Preview {
    ContentView()
}

enum Tab: String {
    case home = "Home"
    case settings = "Settings"
    var symbolImage: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gearshape"
        }
    }
}
