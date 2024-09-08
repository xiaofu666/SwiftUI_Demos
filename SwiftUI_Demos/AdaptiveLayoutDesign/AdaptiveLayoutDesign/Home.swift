//
//  Home.swift
//  AdaptiveLayoutDesign
//
//  Created by Xiaofu666 on 2024/9/8.
//

import SwiftUI

enum TabState: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case notifications = "Notifications"
    case profile = "profile"
    
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .notifications: "bell"
        case .profile: "person.crop.circle"
        }
    }
}

struct Home: View {
    @State private var activeTab: TabState = .home
    // 手势拖动的固定三件套
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
    @State private var progress: CGFloat = .zero
    @State private var navigationPath: NavigationPath = .init()
    
    var body: some View {
        AdaptiveView { size, isLandscape in
            let sideViewWidth: CGFloat = isLandscape ? 200 : 250
            let layout = isLandscape ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(ZStackLayout(alignment: .leading))
            
            NavigationStack(path: $navigationPath) {
                layout {
                    SideBarView(path: $navigationPath) {
                        toggleSideBar()
                    }
                    .frame(width: sideViewWidth)
                    .offset(x: isLandscape ? 0 : -sideViewWidth)
                    .offset(x: isLandscape ? 0 : offset)
                    
                    TabView(selection: $activeTab) {
                        Tab(TabState.home.rawValue, systemImage: TabState.home.symbolImage, value: .home) {
                            Text(TabState.home.rawValue)
                        }
                        Tab(TabState.search.rawValue, systemImage: TabState.search.symbolImage, value: .search) {
                            Text(TabState.search.rawValue)
                        }
                        Tab(TabState.notifications.rawValue, systemImage: TabState.notifications.symbolImage, value: .notifications) {
                            Text(TabState.notifications.rawValue)
                        }
                        Tab(TabState.profile.rawValue, systemImage: TabState.profile.symbolImage, value: .profile) {
                            Text(TabState.profile.rawValue)
                        }
                    }
                    .tabViewStyle(.tabBarOnly)
                    .overlay {
                        Rectangle()
                            .fill(Color.primary.opacity(0.25))
                            .ignoresSafeArea()
                            .opacity(isLandscape ? 0 : progress)
                    }
                    .offset(x: isLandscape ? 0 : offset)
                }
                .gesture(
                    CustomPanGesture(isEnabled: !isLandscape) { gesture in
                        let state = gesture.state
                        let translationX = gesture.translation(in: gesture.view).x + lastOffset
                        let velocityX = gesture.velocity(in: gesture.view).x / 3
                        
                        if state == .began || state == .changed {
                            offset = max(min(translationX, sideViewWidth), 0.0)
                            progress = max(min(offset / sideViewWidth, 1.0), 0.0)
                        } else {
                            withAnimation(.snappy(duration: 0.25)) {
                                if (velocityX + translationX) > sideViewWidth * 0.5 {
                                    offset = sideViewWidth
                                    progress = 1
                                } else {
                                    offset = 0
                                    progress = 0
                                }
                            } completion: {
                                lastOffset = offset
                            }
                        }
                    }
                )
                .navigationDestination(for: String.self) { value in
                    Text("Hello, This is Detail \(value) View")
                        .navigationTitle(value)
                }
            }
        }
        
    }
    
    func toggleSideBar() {
        withAnimation(.snappy(duration: 0.25)) {
            offset = 0
            lastOffset = 0
            progress = 0
        }
    }
}

struct SideBarView: View {
    @Binding var path: NavigationPath
    var toggleSideBar: () -> ()
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let isSidesHavingValues = safeArea.leading != 0 || safeArea.trailing != 0
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 6) {
                    Image(.pic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                    
                    Text("Xiaofu666")
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text("@Lurich")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        Text("21")
                            .fontWeight(.semibold)
                        
                        Text("Followers")
                            .foregroundStyle(.secondary)
                        
                        Text("8")
                            .fontWeight(.semibold)
                            .padding(.leading, 5)
                        
                        Text("Following")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption)
                    .lineLimit(1)
                    .padding(.top, 5)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(SideBarAction.allCases, id: \.rawValue) { action in
                            SideBarActionButton(action) {
                                toggleSideBar()
                                path.append(action.rawValue)
                            }
                        }
                    }
                    .padding(.top, 25)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, isSidesHavingValues ? 5 : 15)
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .background {
                Rectangle()
                    .fill(.background)
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(Color.primary.opacity(0.25))
                            .frame(width: 1.0)
                    }
                    .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    func SideBarActionButton(_ value: SideBarAction, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: value.symbolImage)
                    .font(.title3)
                    .frame(width: 30)
                
                Text(value.rawValue)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
            }
            .foregroundStyle(.primary)
            .padding(.vertical, 10)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

enum SideBarAction: String, CaseIterable {
    case communities = "Communities"
    case bookmarks="Bookmarks"
    case lists = "Lists"
    case messages = "Messages"
    case monetization = "Monetization"
    case settings = "settings"
    var symbolImage: String {
        switch self {
        case .communities: "person.2"
        case .bookmarks: "bookmark"
        case .lists: "list.bullet.clipboard"
        case .messages: "message.badge.waveform"
        case .monetization: "banknote"
        case .settings: "gearshape"
        }
    }
}

struct CustomPanGesture: UIGestureRecognizerRepresentable {
    var isEnabled: Bool
    var handle: (UIPanGestureRecognizer) -> ()
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = isEnabled
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }
}

struct AdaptiveView<Content: View>: View {
    var showsSideBarOniPadPortrait: Bool = true
    @ViewBuilder var content: (CGSize, Bool) -> Content
    @Environment(\.horizontalSizeClass) private var hClass
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let isLandscape = size.width > size.height || (hClass == .regular && showsSideBarOniPadPortrait)
            content(size, isLandscape)
        }
    }
}

#Preview {
    Home()
}
