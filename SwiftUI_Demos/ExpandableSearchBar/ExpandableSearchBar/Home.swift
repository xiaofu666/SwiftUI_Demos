//
//  Home.swift
//  ExpandableSearchBar
//
//  Created by Lurich on 2024/4/28.
//

import SwiftUI

struct Home: View {
    @State private var searchText: String = ""
    @State private var activeTab: Tab = .all
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var animation
    @FocusState private var isSearching: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummyMessageView()
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigationBar()
            }
            .animation(.snappy(duration: 0.3), value: isSearching)
        }
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 190, for: .scrollIndicators)
        .scrollTargetBehavior(CustomScrollTargetBehavior())
    }
    
    @ViewBuilder
    func ExpandableNavigationBar(_ title: String = "Message") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? (1 + max(min((minY / scrollViewHeight), 1.0), 0.0) * 0.5) : 1
            let progress = isSearching ? 1 : max(min(-minY / 70, 1.0), 0.0)
            
            VStack(spacing: 10) {
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    
                    TextField("Search Conversations", text: $searchText)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button {
                            isSearching = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                }
                .foregroundStyle(.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - progress * 15)
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - progress * 25)
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.horizontal, -progress * 15)
                        .padding(.bottom, -progress * 65)
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (colorScheme == .dark ? Color.black : Color.white) : Color.primary)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background {
                                        if tab == activeTab {
                                            Capsule()
                                                .fill(.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        }
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
    }
    
    @ViewBuilder
    func DummyMessageView() -> some View {
        ForEach(0...20, id: \.self) { _ in
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 55)
                
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    
                    Rectangle()
                        .frame(height: 8)
                    
                    Rectangle()
                        .frame(width: 80, height: 8)
                }
            }
            .foregroundStyle(.gray.opacity(0.4))
            .padding(.horizontal, 5)
        }
    }
}

struct CustomScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    Home()
}
