//
//  ContentView.swift
//  CustomTabBar1
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
    @State var currentTab: Tab = .Home
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        HStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                TabView(selection: $currentTab) {
                    Text("Home")
                        .applyBG()
                        .tag(Tab.Home)
                    
                    Text("Search")
                        .applyBG()
                        .tag(Tab.Search)
                    
                    Text("Notifications")
                        .applyBG()
                        .tag(Tab.Notifications)
                    
                    Text("Account")
                        .applyBG()
                        .tag(Tab.Account)
                }
//                Divider()
                //自定义tabBar
                CustomTabBar1View(currentTab: $currentTab)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

@available(iOS 15.0, *)
extension View {
    func applyBG() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color("BG")
                    .ignoresSafeArea()
            }
            
    }
}

@available(iOS 15.0, *)
struct CustomTabBar1View: View {
    
    @Binding var currentTab: Tab
    @State var yOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id:\.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            currentTab = tab
                            yOffset = -60
                        }
                        withAnimation(.easeInOut(duration: 0.1).delay(0.05)) {
                            yOffset = 0
                        }
                    } label: {
                        Image(systemName: tab.rawValue)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .frame(maxWidth:.infinity)
                            .foregroundColor(currentTab == tab ? .purple : .gray)
                            .scaleEffect(currentTab == tab && yOffset != 0 ? 1.5 : 1)
                    }
                }
            }
            .background(alignment: .leading, content: {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 50, height: 50)
                    .offset(x: 20, y: yOffset)
                    .offset(x: indicatorOffset(width: width))
            })
        }
        .frame(height: 30)
        .padding(.bottom, 10)
        .padding([.horizontal, .top])
        .background(.white)
    }
    
    func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        let buttonWidth = width / CGFloat(Tab.allCases.count)
        return index * buttonWidth
    }
    
    func getIndex() -> Int {
        switch currentTab {
            case .Home:
                return 0
            case .Search:
                return 1
            case .Notifications:
                return 2
            case .Account:
                return 3
        }
    }
}



#Preview {
    ContentView()
}
