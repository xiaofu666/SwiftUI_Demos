//
//  FloatingTabView.swift
//  Floating_Tab_Bar
//
//  Created by Xiaofu666 on 2025/5/7.
//

import SwiftUI

protocol FloatingTabProtocol {
    var symbolImage: String { get }
}

fileprivate class FloatingTabViewHelper: ObservableObject {
    @Published var hideTabBar: Bool = false
}

fileprivate struct HideFloatingTabBarModifier: ViewModifier {
    var status: Bool
    @EnvironmentObject private var helper: FloatingTabViewHelper
    
    func body(content:Content) -> some View {
        content
            .onChange(of: status, initial: true) { oldValue, newValue in
                helper.hideTabBar = newValue
            }
    }
}

extension View {
    func hideFloatingTabBar(_ status: Bool) -> some View {
        self
            .modifier(HideFloatingTabBarModifier(status: status))
    }
}

struct FloatingTabView<Content: View, Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
    private var config: FloatingTabConfig
    @Binding private var selection: Value
    private var content: (Value,CGFloat) -> Content
    
    init(config: FloatingTabConfig = .init(), selection: Binding<Value>, @ViewBuilder content: @escaping (Value, CGFloat) -> Content) {
        self.config = config
        self._selection = selection
        self.content = content
    }
    
    @State private var tabBarSize: CGSize = .zero
    @StateObject private var helper: FloatingTabViewHelper = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                /// New Tab View
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        Tab.init(value: tab) {
                            content(tab, tabBarSize.height)
                                // 隐藏本机选项卡栏
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                }
            } else {
                /// Old Tab view
                TabView(selection: $selection) {
                    ForEach(Value.allCases, id: \.hashValue) { tab in
                        content(tab, tabBarSize.height)
                            .tag(tab)
                            // 隐藏本机选项卡栏
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
            
            FloatingTabBar(config: config, activeTab: $selection)
                .padding(.horizontal, config.hPadding)
                .padding(.bottom, config.bPadding)
                .onGeometryChange(for: CGSize.self, of: { $0.size }) { newValue in
                    tabBarSize = newValue
                }
                .offset(y: helper.hideTabBar ? (tabBarSize.height + 100) : 0)
                .animation(config.tabAnimation, value: helper.hideTabBar)
        }
        .environmentObject(helper)
    }
}
/// Floating Tab Bar Configuration
struct FloatingTabConfig {
    var activeTint: Color = .white
    var activeBackgroundTint: Color = .blue
    var inactiveTint: Color = .gray
    var tabAnimation: Animation = .smooth(duration: 0.35, extraBounce: 0)
    var backgroundColor: Color = .gray.opacity(0.1)
    var insetAmount: CGFloat = 6
    var isTranslucent: Bool = true
    var hPadding: CGFloat = 15
    var bPadding: CGFloat = 5

}

fileprivate struct FloatingTabBar<Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
    var config: FloatingTabConfig
    @Binding var activeTab: Value
    // 用于选项卡滑动效果
    @Namespace private var animation
    // 用于符号效果
    @State private var toggleSymbolEffect: [Bool] = Array(repeating: false, count: Value.allCases.count)

    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Value.allCases, id: \.hashValue) { tab in
                let isActive = activeTab == tab
                let index = (Value.allCases.firstIndex(of: tab) as? Int) ?? 0
                Image(systemName: tab.symbolImage)
                    .font(.title3)
                    .foregroundStyle(isActive ? config.activeTint : config.inactiveTint)
                    .symbolEffect(.bounce.byLayer.down, value: toggleSymbolEffect[index])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .background {
                        if isActive {
                            Capsule(style: .continuous)
                                .fill(config.activeBackgroundTint.gradient)
                                .matchedGeometryEffect(id:"ACTIVETAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        activeTab = tab
                        toggleSymbolEffect[index].toggle()
                    }
                    .padding(.vertical, config.insetAmount)
            }
        }
        .padding(.horizontal, config.insetAmount)
        .frame(height: 50)
        .background {
            ZStack {
                if config.isTranslucent {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.background)
                }
                
                Rectangle()
                    .fill(config.backgroundColor)
            }
        }
        .clipShape(.capsule(style: .continuous))
        .animation(config.tabAnimation, value: activeTab)
    }
}

#Preview {
    ContentView()
}
