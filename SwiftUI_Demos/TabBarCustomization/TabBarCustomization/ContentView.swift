//
//  ContentView.swift
//  TabBarCustomization
//
//  Created by Xiaofu666 on 2024/10/16.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabValue = .home
    @State private var symbolEffectTrigger: TabValue?
    // Type 1
    @SceneStorage("hideTabBar") private var hideTabBar: Bool = false
    // Type 2
    var tabBarData = TabBarData()
    
    var body: some View {
        NavigationStack {
            TabView(selection: .init(get: {
                activeTab
            }, set: { newValue in
                activeTab = newValue
                symbolEffectTrigger = newValue
                
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    symbolEffectTrigger = nil
                }
            })) {
                Tab(value: .home) {
                    DummyScrollView()
                        .overlay(alignment: .top) {
                            TextField("Test In Put", text: .constant(""))
                                .frame(width: 200, height: 45)
                        }
                }
                Tab(value: .search) {
                    VStack {
                        Button("Hidden Tab Bar Type 1") {
                            hideTabBar.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(height: 100)
                        
                        Spacer()
                    }
                    .toolbarVisibility(hideTabBar ? .hidden : .visible, for: .tabBar)
                }
                Tab(value: .setting) {
                    VStack {
                        Button("Hidden Tab Bar Type 2") {
                            tabBarData.hideTabBar.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(height: 100)
                        
                        Spacer()
                    }
                    .toolbarVisibility(tabBarData.hideTabBar ? .hidden : .visible, for: .tabBar)
                }
            }
            .navigationTitle("Custom Tab Bar")
            .environment(tabBarData)
            .overlay(alignment: .bottom) {
                AnimationTabBar()
                    .opacity(hideTabBar ? 0 : 1)
                    .opacity(tabBarData.hideTabBar ? 0 : 1)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
    }
    
    @ViewBuilder
    func AnimationTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(TabValue.allCases, id: \.rawValue) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbolImage)
                        .font(.title2)
                        .symbolVariant(.fill)
                        .modifiers { content in
                            switch tab {
                            case .home: content
                                    .symbolEffect(.bounce.byLayer.down, options: .speed(1.2), value: symbolEffectTrigger == tab)
                            case .search: content
                                    .symbolEffect(.wiggle.counterClockwise, options: .speed(1.4), value: symbolEffectTrigger == tab)
                            case .setting: content
                                    .symbolEffect(.rotate.byLayer, options: .speed(2), value: symbolEffectTrigger == tab)
                            }
                        }
                    
                    Text(tab.name)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? .blue : .secondary)
                .frame(maxWidth: .infinity)
            }
        }
        .allowsTightening(false)
        .frame(height: 48)
    }
    
    @ViewBuilder
    func DummyScrollView() -> some View {
        ScrollView(.vertical) {
            ForEach(1...20, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 15)
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 45)
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 15)
        .safeAreaPadding(.bottom, 15)
    }
}

extension View {
    @ViewBuilder
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}

#Preview {
    ContentView()
}

enum TabValue: String, CaseIterable {
    case home
    case search
    case setting
    
    var symbolImage: String {
        switch self {
        case .home:
            "house"
        case .search:
            "magnifyingglass"
        case .setting:
            "gearshape"
        }
    }
    
    var name: String {
        self.rawValue.capitalized
    }
}

@Observable
class TabBarData {
    var hideTabBar: Bool = false
}
