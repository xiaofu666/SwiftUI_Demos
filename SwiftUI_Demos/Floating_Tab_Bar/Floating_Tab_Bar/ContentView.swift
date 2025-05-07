//
//  ContentView.swift
//  Floating_Tab_Bar
//
//  Created by Xiaofu666 on 2025/5/7.
//

import SwiftUI

enum AppTab: String, CaseIterable, FloatingTabProtocol {
    case memories = "Memories"
    case library = "Library"
    case albums = "Albums"
    case search = "Search"
    
    var symbolImage: String {
        switch self {
        case .memories: "memories"
        case .library: "photo.fill.on.rectangle.fill"
        case .albums: "square.stack.fill"
        case .search: "magnifyingglass"
        }
    }
}
    
struct ContentView: View {
    @State private var activeTab: AppTab = .library
    
    var body: some View {
        FloatingTabView(selection: $activeTab) { tab, tabHeight in
            switch tab {
            case .memories:
                Text(tab.rawValue)
            case .library:
                LibraryView(tabBarHeight: tabHeight)
            case .albums:
                Text(tab.rawValue)
            case .search:
                Text(tab.rawValue)
            }
        }
    }
}

struct LibraryView: View {
    var tabBarHeight: CGFloat
    @State private var hideTabBar: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 0)
                
                Button("Hide Tab Bar") {
                    hideTabBar.toggle()
                }
            }
            .padding()
            .navigationTitle("Library")
            .safeAreaPadding(.bottom, tabBarHeight)
        }
        .hideFloatingTabBar(hideTabBar)
    }
}


#Preview {
    ContentView()
}
