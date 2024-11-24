//
//  ContentView.swift
//  iOS18MailAppTabbar
//
//  Created by Xiaofu666 on 2024/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false
    @State private var activeTab: TabModel = .primary
    // iOS 18
    @State private var scrollOffset: CGFloat = 0
    @State private var topOffset: CGFloat = 0
    @State private var startTopOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    CustomTabBar(activeTab: $activeTab)
                        .frame(height: isSearchActive ? 0 : nil, alignment: .top)
                        .opacity(isSearchActive ? 0 : 1)
                        .padding(.bottom, isSearchActive ? 0 : 10)
                        .background {
                            let progress = max(min((scrollOffset + startTopOffset - 110) / 15, 1.0), 0.0)
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .padding(.top, -topOffset)
                            .opacity(progress)
                        }
                        .offset(y: (scrollOffset + topOffset) > 0 ? (scrollOffset + topOffset) : 0)
                        .zIndex(10000)
                    
                    LazyVStack {
                        Text("Hello world!")
                    }
                    .padding(15)
                    .zIndex(0)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSearchActive)
            .onScrollGeometryChange(for: CGFloat.self, of: {
                $0.contentOffset.y
            }) { oldValue, newValue in
                scrollOffset = newValue
            }
            .onScrollGeometryChange(for: CGFloat.self, of: {
                $0.contentInsets.top
            }) { oldValue, newValue in
                if startTopOffset == .zero {
                    startTopOffset = newValue
                }
                topOffset = newValue
            }
            .navigationTitle("All Inboxes")
            .searchable(text: $searchText, isPresented: $isSearchActive, placement: .navigationBarDrawer(displayMode: .automatic))
            .background(.gray.opacity(0.1))
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        }
    }
}

struct CustomTabBar: View {
    @Binding var activeTab: TabModel
    
    var body: some View {
        GeometryReader { _ in
            HStack(spacing: 8) {
                HStack(spacing: activeTab == .allMails ? -15 : 8) {
                    ForEach(TabModel.allCases.filter({ $0 != .allMails }), id: \.rawValue) { tab in
                        ResizableTabButton(tab)
                    }
                }
                
                if activeTab == .allMails {
                    ResizableTabButton(.allMails)
                        .transition(.offset(x: 200))
                }
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    func ResizableTabButton(_ tab: TabModel) -> some View {
        HStack(spacing: 8) {
            Image(systemName: tab.symbolImage)
                .opacity(activeTab == tab ? 0 : 1)
                .overlay {
                    Image(systemName: tab.symbolImage)
                        .symbolVariant(tab == activeTab ? .fill : .none)
                        .opacity(activeTab == tab ? 1 : 0)
                }
            
            if tab == activeTab {
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(activeTab == tab ? .white : .gray)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: activeTab == tab ? .infinity : nil)
        .padding(.horizontal, 20)
        .background {
            Rectangle()
                .fill(activeTab == tab ? tab.color : .inActiveTab)
        }
        .clipShape(.rect(cornerRadius: 20))
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .padding(activeTab == .allMails && tab != .allMails ? -3 : 3)
        }
        .contentShape(.rect)
        .onTapGesture {
            guard tab != .allMails else { return }
            withAnimation(.bouncy) {
                if activeTab == tab {
                    activeTab = .allMails
                } else {
                    activeTab = tab
                }
            }
        }
    }
}

extension Color {
    static let inActiveTab: Color = Color("inActiveColor")
}

#Preview {
    ContentView()
}
