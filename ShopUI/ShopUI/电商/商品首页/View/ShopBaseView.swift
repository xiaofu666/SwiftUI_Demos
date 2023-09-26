//
//  BaseView.swift
//  ShoeUI0903
//
//  Created by Lurich on 2021/9/3.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Home = "house.fill"
    case Search = "magnifyingglass"
    case Notifications = "bell.fill"
    case Account = "person.fill"
}

@available(iOS 15.0, *)
struct ShopBaseView: View {
    
    @StateObject var baseData = baseViewModel()
    @State var present = false
    //hiding tab bar...
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $baseData.currentTab) {
            ShopUIHome()
                .environmentObject(baseData)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.04))
                .tag(Tab.Home)
            
            Text("Search")
                .tag(Tab.Search)
            
            Text("Notifications")
                .tag(Tab.Notifications)
            
            Text("Account")
                .tag(Tab.Account)
        }
        .fullScreenCover(isPresented: $present) {
            CartView(isPresent: $present)
        }
        .overlay(
        
            //custom Tab Bar...
            HStack(spacing: 0) {
            
                TabButton(Tab: .Home)
        
                TabButton(Tab: .Search)
                .offset(x: -10)
            
                Button {
                    present.toggle()
                } label: {
                    
                    Image(systemName: "cart.circle")
                        .resizable()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.white)
                        .padding(18)
                        .offset(x: -1)
                        .background(Color("Pink"))
                        .clipShape(Circle())
                    //shadow
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
                }
                .offset(y: -30)

                TabButton(Tab: .Notifications)
                .offset(x: 10)
            
                TabButton(Tab: .Account)
            
            }
                .background(
                    Color.white
                        .clipShape(CustomCurveShape())
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
                        .ignoresSafeArea(.container, edges: .bottom)
                )
            //hiding tab bar when detail opens..
                .offset(y: baseData.showDetail ? 200 : 0)
                
            
            
            ,alignment: .bottom
        )
        
    }
    
    @ViewBuilder
    func TabButton(Tab: Tab) -> some View {
        
        Button {
            
            withAnimation {
                
                baseData.currentTab = Tab
            }
        } label: {
            
            Image(systemName: Tab.rawValue)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(baseData.currentTab == Tab ? Color("Pink") : Color.gray.opacity(0.5))
                .frame(maxWidth: .infinity)
        }

    }
    
}

@available(iOS 15.0, *)
struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        ShopBaseView()
    }
}
