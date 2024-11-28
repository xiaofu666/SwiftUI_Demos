//
//  ContentView.swift
//  CustomNavigationPopItems
//
//  Created by Xiaofu666 on 2024/11/28.
//

import SwiftUI

@Observable
class NavigationHelper: NSObject, UIGestureRecognizerDelegate {
    var path: NavigationPath = .init()
    var popProgress: CGFloat = 1
    
    private var isAdded: Bool = false
    private var navController: UINavigationController?
    
    func addPopGestureLister(_ controller: UINavigationController) {
        guard !isAdded else { return }
        controller.interactivePopGestureRecognizer?.addTarget(self, action: #selector(didInteractivePopGestureChange))
        navController = controller
        controller.interactivePopGestureRecognizer?.delegate = self
        isAdded = true
    }
    
    @objc
    func didInteractivePopGestureChange() {
        if let completionProgress = navController?.transitionCoordinator?.percentComplete, let state = navController?.interactivePopGestureRecognizer?.state, navController?.viewControllers.count == 1 {
            popProgress = completionProgress
            
            if state == .ended || state == .cancelled {
                if completionProgress > 0.5 {
                    popProgress = 1
                } else {
                    popProgress = 0
                }
            }
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navController?.viewControllers.count ?? 0 > 1
    }
}

struct ContentView: View {
    var navigationHelper: NavigationHelper = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            @Bindable var bindableHelper = navigationHelper
            NavigationStack(path: $bindableHelper.path) {
                List {
                    Button {
                        navigationHelper.path.append("Xiaofu666")
                    } label: {
                        Text("Push Detail for Xiaofu666")
                    }
                }
                .navigationTitle("Home")
                .navigationDestination(for: String.self) { item in
                    List {
                        Button {
                            navigationHelper.path.append("Detail")
                        } label: {
                            Text("Push Detail for Xiaofu666")
                        }
                    }
                    .navigationTitle(item)
                }
            }
            .viewExtractor {
                if let navController = $0.next as? UINavigationController {
                    navigationHelper.addPopGestureLister(navController)
                }
            }
            
            CustomBottomBar()
        }
        .environment(navigationHelper)
    }
}

struct CustomBottomBar: View {
    @Environment(NavigationHelper.self) private var navigationHelper
    @State private var selectedTab: TabModel = .home
    
    var body: some View {
        HStack(spacing: 0) {
            let blur = (1 - navigationHelper.popProgress) * 3
            let scale = (1 - navigationHelper.popProgress) * 0.1
            
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    if tab == .newPost {
                        
                    } else {
                        selectedTab = tab
                    }
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(selectedTab == tab || tab == .newPost ? .primary : .secondary)
                        .blur(radius: tab != .newPost ? blur : 0)
                        .scaleEffect(tab == .newPost ? 1.5 : 1 - scale)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .opacity(tab == .newPost ? 1 : navigationHelper.popProgress)
                .overlay {
                    ZStack {
                        if tab == .home {
                            Button {
                                
                            } label: {
                                Image(systemName: "exclamationmark.bubble")
                                    .font(.title3)
                                    .foregroundStyle(.primary)
                            }
                        }
                        if tab == .settings {
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .opacity(1 - navigationHelper.popProgress)
                }
            }
        }
        .onChange(of: navigationHelper.path) { oldValue, newValue in
            guard newValue.isEmpty || oldValue.isEmpty else { return }
            if newValue.count > oldValue.count {
                navigationHelper.popProgress = 0.0
            } else {
                navigationHelper.popProgress = 1.0
            }
        }
        .animation(.easeInOut(duration: 0.25), value: navigationHelper.popProgress)
    }
}
enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case newPost = "square.and.pencil.circle.fill"
    case notifications = "bell.fill"
    case settings = "gearshape.fill"
}


#Preview {
    ContentView()
}
