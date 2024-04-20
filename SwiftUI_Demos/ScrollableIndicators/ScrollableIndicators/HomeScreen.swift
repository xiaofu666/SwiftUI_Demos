//
//  HomeScreen.swift
//  ScrollableIndicators
//
//  Created by Lurich on 2024/4/20.
//

import SwiftUI

struct HomeScreen: View {
    @State private var tabs:[TabModel] = [
        .init(id: TabModel.Tab.research),
        .init(id: TabModel.Tab.deployment),
        .init(id: TabModel.Tab.analytics),
        .init(id: TabModel.Tab.audience),
        .init(id: TabModel.Tab.privacy)
    ]
    @State private var activeTab: TabModel.Tab = .research
    @State private var tabBarScrollState: TabModel.Tab?
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var progress: CGFloat = .zero
    
    var body: some View {
        VStack {
            HeaderView()
            CustomTabBar()
            TabContentView()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            
            Spacer(minLength: 0)
            
            Button("", systemImage: "plus.circle") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            Button("", systemImage: "bell") {
                
            }
            .font(.title2)
            .tint(.primary)
            
            Button {
                
            } label: {
                Image(.user)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(.circle)
            }
        }
        .padding(15)
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    } label: {
                        Text(tab.id.rawValue)
                            .font(.body)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ? Color.primary : Color.secondary)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in }), anchor: .center)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
        }
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                
                let inputRange = tabs.indices.compactMap { CGFloat($0) }
                let outputRange = tabs.compactMap { $0.size.width }
                let outputPositionRange = tabs.compactMap { $0.minX }
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func TabContentView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(tabs) { tab in
                        Text(tab.id.rawValue)
                            .font(.title)
                            .frame(width: size.width, height: size.height)
                            .contentShape(.rect)
                    }
                }
                .scrollTargetLayout()
                .rect { rect in
                    progress = -rect.minX / size.width
                }
            }
            .scrollPosition(id: $mainViewScrollState)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .onChange(of: mainViewScrollState) { oldValue, newValue in
                if let newValue {
                    withAnimation(.snappy) {
                        tabBarScrollState = newValue
                        activeTab = newValue
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
