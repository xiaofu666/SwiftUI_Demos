//
//  ContentView.swift
//  CustomTabBar2
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notifications = "bell.fill"
    case Account = "person.fill"
}

@available(iOS 15.0, *)
struct ContentView: View {
    //Current Tabb...
    @State var currentTab : Tab = .Home
    
    //Matched geometry effect...
    @Namespace var animation
    
    //current tab xvalue...
    @State var currentXValue: CGFloat = 0
        
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        
        TabView(selection: $currentTab) {
            
            Text("Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Home)
            
            Text("Search")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Search)
            
            Text("Notifications")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Notifications)
            
            Text("Account")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("BG").ignoresSafeArea())
                .tag(Tab.Account)
        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                }
            }
            .padding(.vertical)
            //preview wont show sagearea...
            .padding(.bottom, getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
            .background(
                BlurEffect(style: .systemUltraThinMaterialDark)
                    .clipShape(BottomCurveShape(currentXValue: currentXValue))
            )
            , alignment: .bottom
        )
        .ignoresSafeArea(.container, edges: .bottom)
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
        .onDisappear {
            UITabBar.appearance().isHidden = false
        }
        //always dark
        .preferredColorScheme(.dark)
    }
    
    //tabbutton...
    @ViewBuilder
    func TabButton(tab: Tab) -> some View {
        //sine we need xaxis value for curve
        GeometryReader {proxy in
            Button {
                withAnimation(.spring()) {
                    currentTab = tab
                    currentXValue = proxy.frame(in: .global).midX
                }
            } label: {
                //moving button up for  current tab...
                Image(systemName: tab.rawValue)
                //since we need perfect value for curve..
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack {
                            if currentTab == tab {
                                BlurEffect(style: .systemChromeMaterialDark)
                                    .clipShape(Circle())
                                    .matchedGeometryEffect(id: "CustomTabBar2", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            //setting intial curve position
            .onAppear{
                if tab == .Home && currentXValue == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        currentXValue = proxy.frame(in: .global).midX
                    }
                }
            }
        }
        .frame(height: 30)
        //maxsize...

    }
    
}

struct BlurEffect: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
    
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}


func getSafeArea() -> UIEdgeInsets {
    let safeArea = getWindow().safeAreaInsets
    return safeArea
}

//MARK: ROOT View Controller
func getWindow() -> UIWindow {
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return .init()
    }
    guard let window = screen.windows.first else {
        return .init()
    }
    return window
}

// tab bar curve.... v
struct BottomCurveShape: Shape {
    var currentXValue: CGFloat
    //animation path...
    var animatableData: CGFloat {
        get{currentXValue}
        set{currentXValue = newValue}
    }
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            //mid will be current xvalue
            let mid = currentXValue
            path.move(to: CGPoint(x: mid - 50, y: 0))
            
            let to1 = CGPoint(x: mid, y: 35)
            let control1 = CGPoint(x: mid - 25, y: 0)
            let control2 = CGPoint(x: mid - 25, y: 35)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: mid + 50, y: 0)
            let control3 = CGPoint(x: mid + 25, y: 35)
            let control4 = CGPoint(x: mid + 25, y: 0)
            
            path.addCurve(to: to2, control1: control3, control2: control4)
            
        }
    }
}


#Preview {
    ContentView()
}
