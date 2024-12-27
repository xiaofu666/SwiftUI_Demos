//
//  ContentView.swift
//  InteractiveTab
//
//  Created by Xiaofu666 on 2024/12/27.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    @State private var switchTab: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Tab.init(value: tab) {
                            Text(tab.rawValue)
                                .toolbarVisibility(.hidden, for: .tabBar)
                                .onTapGesture {
                                    switchTab.toggle()
                                }
                        }
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Text(tab.rawValue)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
            
            if switchTab {
                InteractiveTabBar1(activeTab: $activeTab)
            } else {
                InteractiveTabBar2(activeTab: $activeTab)
            }
        }
    }
}

#Preview {
    ContentView()
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case notifications = "Notifications"
    case settings = "Settings"
    
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .search:"magnifyingglass"
        case .notifications:"bell"
        case .settings: "gearshape"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
