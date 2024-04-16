//
//  HomeView.swift
//  DrawerSidebarHomeView
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Home = "house"
    case Search = "heart.circle"
    case Notifications = "paperclip.circle"
    case Account = "person.circle"
}

@available(iOS 15.0, *)
struct HomeView: View {
    @State var currentTab: Tab = .Home
    @Environment(\.dismiss) var dismiss
    
    //针对抽屉菜单
    @State var showMenu: Bool = false
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @GestureState  var gestureOffset: CGFloat = 0
    let sideBarWidth = UIScreen.main.bounds.width - 90
    
    var body: some View {
        
        HStack(spacing: 0) {
            DrawerSidebarMenuView(showMenu: $showMenu)
            
            VStack(spacing: 0) {
                TabView(selection: $currentTab) {
                    DrawerSidebarHomeView(showMenu: $showMenu)
                        .applyBG()
                        .tag(Tab.Home)
                        .tabItem {
                            Label("Home", systemImage: Tab.Home.rawValue)
                        }
                    
                    Text("Search")
                        .applyBG()
                        .tag(Tab.Search)
                        .tabItem {
                            Label("Search", systemImage: Tab.Search.rawValue)
                        }
                    
                    Text("Notifications")
                        .applyBG()
                        .tag(Tab.Notifications)
                        .tabItem {
                            Label("Notifications", systemImage: Tab.Notifications.rawValue)
                        }
                    
                    Text("Account")
                        .applyBG()
                        .tag(Tab.Account)
                        .tabItem {
                            Label("Account", systemImage: Tab.Account.rawValue)
                        }
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            //bg when menu is showing
            .overlay(
                Rectangle()
                    .fill(
                        Color.primary
                            .opacity(Double((offset / sideBarWidth) / 5))
                            
                    )
                    .ignoresSafeArea(.container, edges: .vertical)
                    .onTapGesture {
                        withAnimation{
                            showMenu.toggle()
                        }
                    }
            )
        }
        .frame(width: UIScreen.main.bounds.width + sideBarWidth)
        .offset(x: -sideBarWidth / 2)
        .offset(x: offset > 0 ? offset : 0)
        // gesture
        .gesture(
            DragGesture()
                .updating($gestureOffset, body: { value, out, _ in
            
                out = value.translation.width
            })
                .onEnded(onEnd(value:))
        )
        .animation(.easeOut, value: offset == 0)
        .onChange(of: showMenu) { newValue in
            
            if showMenu && offset == 0 {
                
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth {
                 
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset) { newValue in
            onChange()
        }
    }
    func onChange() {
        offset = (gestureOffset != 0) ?  (gestureOffset + lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset: offset) : offset
    }
    
    func onEnd(value: DragGesture.Value) {
        let translation = value.translation.width
        
        withAnimation{
            // checking
            
            if translation > 0 {
                
                if translation > (sideBarWidth / 2) {
                    // showing menu...
                    offset  = sideBarWidth
                    showMenu = true
                }
                else {
                    
                    if offset == sideBarWidth {
                        
                        return
                    }
                    
                    offset  = 0
                    showMenu = false
                }
                
            }
            else  {
                
                if -translation < (sideBarWidth / 2) {
                    
                    if offset == 0 || !showMenu {
                        
                        return
                    }
                    
                    offset  = sideBarWidth
                    showMenu = true
                }
                else {
                    
                    offset  = 0
                    showMenu = false
                }
            }
            
        }
        
        // storing last offset...
        lastStoredOffset = offset
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
