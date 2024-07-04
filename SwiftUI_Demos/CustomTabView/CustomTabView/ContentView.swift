//
//  ContentView.swift
//  CustomTabView
//
//  Created by Lurich on 2024/7/4.
//

import SwiftUI

struct ContentView: View {
    @State private var properties: TabProperties = .init()
    var body: some View {
        @Bindable var bindings = properties
        VStack(spacing: 0) {
            TabView(selection: $bindings.activeTab) {
                Tab.init(value: 0) {
                    Home()
                        .environment(properties)
                        .hideTabBar()
                }
                Tab.init(value: 1) {
                    Text("Search")
                        .hideTabBar()
                }
                Tab.init(value: 2) {
                    Text("Notifications")
                        .hideTabBar()
                }
                Tab.init(value: 3) {
                    Text("Community")
                        .hideTabBar()
                }
                Tab.init(value: 4) {
                    Text("Setting")
                        .hideTabBar()
                }
            }
            
            CustomTabBar()
                .environment(properties)
        }
    }
}

struct Home: View {
    @Environment(TabProperties.self) private var properties
    var body: some View {
        @Bindable var binding = properties
        NavigationStack {
            List {
                Toggle("Edit Tab Location", isOn: $binding.editMode)
            }
            .navigationTitle("Home")
        }
    }
}

extension View {
    @ViewBuilder
    func hideTabBar() -> some View {
        self.toolbarVisibility(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func loopingWiggle(_ isEnabled: Bool = false) -> some View {
        self.symbolEffect(.wiggle.byLayer.clockwise, isActive: isEnabled)
    }
}
#Preview {
    ContentView()
}
