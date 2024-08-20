//
//  ContentView.swift
//  FloatingTabBar
//
//  Created by Xiaofu666 on 2024/8/20.
//

import SwiftUI


struct ContentView: View {
    @State private var activeTab: TabModel = .home
    @State private var isTabBarHide: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        Tab.init(value: TabModel.home) {
                            HomeView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        Tab.init(value: TabModel.search) {
                            Text(TabModel.search.title)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        Tab.init(value: TabModel.notifications) {
                            Text(TabModel.notifications.title)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        Tab.init(value: TabModel.settings) {
                            Text(TabModel.settings.title)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                } else {
                    TabView(selection: $activeTab) {
                        HomeView()
                            .tag(TabModel.home)
                            .background {
                                if !isTabBarHide {
                                    HideTabBar {
                                        isTabBarHide = true
                                    }
                                }
                            }
                        
                        Text(TabModel.search.title)
                            .tag(TabModel.search)
                        
                        Text(TabModel.notifications.title)
                            .tag(TabModel.notifications)
                        
                        Text(TabModel.settings.title)
                            .tag(TabModel.settings)
                    }
                }
            }
            
            CustomTabBar(activeTab: $activeTab)
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(1...50, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.primary.opacity(0.1))
                            .frame(height: 50)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Floating Tab Bar")
            .background(.background)
            .safeAreaPadding(.bottom, 60)
        }
    }
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                tabController.tabBar.isHidden = true
                result()
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: { $0.next }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        return nil
    }
}


#Preview {
    ContentView()
}
