//
//  BottomBarView.swift
//  MapsBottomBar
//
//  Created by Xiaofu666 on 2025/6/29.
//

import SwiftUI

// Tab Enum
enum AppTab: String, CaseIterable {
    case people = "People"
    case devices = "Devices"
    case items = "Items"
    case me = "Me"
    
    var symbolImage: String {
        switch self {
        case .people:
            "person.2"
        case .devices:
            "macbook.and.iphone"
        case .items:
            "circle.grid.2x2"
        case .me:
            "location.slash"
        }
    }
}
    
struct BottomBarView: View {
    @Binding var selection: PresentationDetent
    
    @State private var activeTab: AppTab = .devices
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let bottomPadding = safeArea.bottom / 5
            
            VStack(spacing: 0) {
                TabView(selection: $activeTab) {
                    ForEach(AppTab.allCases, id: \.rawValue) { tab in
                        Tab.init(value: tab) {
                            IndividualTabView(tab)
                        }
                    }
                }
                .tabViewStyle(.tabBarOnly)
                .background(TabViewHelper())
                .compositingGroup()
                
                CustomTabBar()
                    .padding(.bottom, bottomPadding)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .interactiveDismissDisabled()
    }
    
    // Individual Tab View
    @ViewBuilder
    func IndividualTabView(_ tab: AppTab) -> some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Text(tab.rawValue)
                        .font(.largeTitle.bold())
                    
                    Spacer(minLength: 0)
                    
                    Button {
                    } label: {
                        Image(systemName: "plus" )
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                }
                .padding(.top, 15)
                .padding(.leading, 10)
                
                // your content
            }
            .padding(15)
            .toolbarVisibility(.hidden, for: .tabBar)
            .toolbarBackgroundVisibility(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                VStack(spacing: 6) {
                    Image(systemName: tab.symbolImage)
                        .font(.title3)
                        .symbolVariant(.fill)
                    
                    Text(tab.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(tab == activeTab ? .blue : .gray)
                .frame(maxWidth: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                }
            }
        }
        .padding([.horizontal, .bottom], 12)
        .padding(.top, 10)
    }
}

#Preview {
    ContentView()
}


fileprivate struct TabViewHelper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            guard let compostingGroup = view.superview?.superview else { return }
            guard let swiftUIWrapperUITabView = compostingGroup.subviews.last else { return }
            if let tabBarController = swiftUIWrapperUITabView.subviews.first?.next as? UITabBarController {
                // Clearing Backgrounds
                tabBarController.view.backgroundColor = .clear
                tabBarController.viewControllers?.forEach {
                    $0.view.backgroundColor = .clear
                }
                tabBarController.delegate = context.coordinator
                // 临时解决方案！
                tabBarController.tabBar.removeFromSuperview()
            }
        }

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate, UIViewControllerAnimatedTransitioning {
        func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
            return self
        }
        func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
            return .zero
        }
        func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
            guard let destinationView = transitionContext.view(forKey: .to) else { return }
            let containerView = transitionContext.containerView
            containerView.addSubview(destinationView)
            transitionContext.completeTransition(true)
        }
    }
}
