//
//  ContentView.swift
//  CustomTabBar6
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    @State private var activeTab: Tab6 = .home
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                Text("Home")
                    .tag(Tab6.home)
                
                Text("Services")
                    .tag(Tab6.services)
                
                Text("Partners")
                    .tag(Tab6.partners)
                
                Text("Activity")
                    .tag(Tab6.activity)
            }
            
            CustomTabBar()
        }
    }
    
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .gray, _ inactiveTint: Color = .blue) -> some View {
        HStack(alignment:.bottom, spacing: 0) {
            ForEach(Tab6.allCases, id: \.rawValue) {
                Tab6Item(tint: tint, inactiveTint: inactiveTint, tab: $0, animation: animation, activeTab: $activeTab, tabPosition: $tabShapePosition)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            CustomTabBar6Shape(midpoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
                .shadow(color: inactiveTint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

@available(iOS 16.0, *)
private struct Tab6Item: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab6
    var animation: Namespace.ID
    @Binding var activeTab: Tab6
    @Binding var tabPosition: CGPoint
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : tint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(inactiveTint.gradient)
                            .matchedGeometryEffect(id: "ACTIVE_TAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.callout)
                .foregroundColor(activeTab == tab ? inactiveTint : tint)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .getGlobalRect(true, completion: { rect in
            if activeTab == tab {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    tabPosition.x = rect.midX
                }
            }
        })
        .onTapGesture {
            activeTab = tab
        }
    }
}

/// App Tab's
private enum Tab6: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case partners = "Partners"
    case activity = "Activity"
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .services:
            return "envelope.open.badge.clock"
        case .partners:
            return "hand.raised"
        case .activity:
            return "bell"
        }
    }
    var index: Int {
        return Tab6.allCases.firstIndex(of: self) ?? 0
    }
}

private struct CustomTabBar6Shape: Shape {
    var midpoint: CGFloat
    var animatableData: CGFloat {
        get { midpoint }
        set { midpoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addPath(Rectangle().path(in: rect))
            
            path.move(to: CGPoint(x: midpoint - 60, y: 0))
            
            let to1 = CGPoint(x: midpoint, y: -25)
            let control1 = CGPoint(x: midpoint - 25, y: 0)
            let control2 = CGPoint(x: midpoint - 25, y: -25)
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: midpoint + 60, y: 0)
            let control3 = CGPoint(x: midpoint + 25, y: -25)
            let control4 = CGPoint(x: midpoint + 25, y: 0)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
extension View {
    @ViewBuilder
    func getGlobalRect(_ addObserver: Bool = false, completion:@escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
            if addObserver {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: completion)
                }
            }
        }
    }
}
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
}
