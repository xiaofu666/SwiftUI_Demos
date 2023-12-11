//
//  ContentView.swift
//  CustomTabBar4
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

//MARK: Tab
@available(iOS 15.0, *)
struct ContentView : View {
    
    @State var selectedTab : Tab = .Home
    @State var expand = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            TabView(selection: $selectedTab,
                    content:  {
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
                        
                    })
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea(.all, edges: .bottom)
            
            HStack(spacing: 0) {
                Spacer()
                
                HStack {
                    if !self.expand {
                        Button(action: {
                            self.expand.toggle()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                        })
                    } else {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                selectedTab = tab
                            }, label: {
                                Image(systemName: tab.rawValue)
                                    .renderingMode(.template)
                                    .foregroundColor(selectedTab == tab ? Color.blue : Color.gray)
                                    .padding()
                                
                            })
                            if tab != Tab.Account {
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 5)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
                .padding(.horizontal)
                .padding(.bottom, getSafeArea().bottom == 0 ? 20 : 0)
                .onLongPressGesture {
                    self.expand.toggle()
                }
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6), value: expand)
            }
            
            //无视tab升高
        })
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.black.opacity(0.05).ignoresSafeArea(.all))
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

#Preview {
    ContentView()
}
