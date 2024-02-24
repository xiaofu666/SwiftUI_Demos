//
//  ContentView.swift
//  YoutobeMiniPlayer
//
//  Created by Lurich on 2024/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: Tab = .home
    @State private var config: PlayerConfig = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                HomeTabView()
                    .setUpTab(Tab.home)
                Text(Tab.shorts.rawValue)
                    .setUpTab(Tab.shorts)
                Text(Tab.subscriptions.rawValue)
                    .setUpTab(Tab.subscriptions)
                Text(Tab.you.rawValue)
                    .setUpTab(Tab.you)
            }
            .padding(.bottom, tabHeight)
            
            GeometryReader(content: { geometry in
                let size = geometry.size
                if config.showMiniPlayer {
                    MiniPlayerView(size: size, config: $config) {
                        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
                            config.showMiniPlayer = false
                        } completion: {
                            config.resetPosition()
                            config.selectedPlayerItem = nil
                        }

                    }
                }
            })
            
            CustomTab()
                .offset(y: config.showMiniPlayer ? (1-config.progress) * tabHeight : 0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    func HomeTabView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15, content: {
                    ForEach(items) { item in
                        PlayerItemCardView(item) {
                            config.selectedPlayerItem = item
                            withAnimation(.easeInOut(duration: 0.3)) {
                                config.showMiniPlayer = true
                            }
                        }
                    }
                })
                .padding(15)
            }
            .navigationTitle("YouTube")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.background, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    func PlayerItemCardView(_ item: PlayerItem, onTap: @escaping () -> ()) -> some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipShape(.rect(cornerRadius: 15))
                .contentShape(.rect)
                .onTapGesture(perform: onTap)
            
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundStyle(.primary)
                
                VStack(alignment: .leading, spacing: 6, content: {
                    Text(item.title)
                        .font(.callout)
                    
                    HStack(spacing: 6, content: {
                        Text(item.author)
                        
                        Text("· 2 Days Ago")
                    })
                    .font(.caption)
                    .foregroundStyle(.secondary)
                })
            }
        })
    }
    
    @ViewBuilder
    func CustomTab() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbol)
                        .font(.title3)
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? .primary : .secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                }
            }
        }
        .frame(height: 49)
        .overlay(alignment: .top, content: {
            Divider()
        })
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: tabHeight)
        .background(.background)
    }
}

#Preview {
    ContentView()
}

extension View {
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    var tabHeight: CGFloat {
        return 49 + safeArea.bottom
    }
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
