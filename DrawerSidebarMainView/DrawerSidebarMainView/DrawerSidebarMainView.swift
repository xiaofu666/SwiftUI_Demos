//
//  MainView.swift
//  Custom_Side_Menu
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

struct DrawerSidebarMainView: View {
    
    // selected Tab...
    @State var selectedTab = "Home"

    @State var showMenu = false
    
    var body: some View {
       
        ZStack  {
            
            Color.blue
                .ignoresSafeArea()
            
            //Side Menu....
            ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : .init(), showsIndicators: false, content: {
                
                DrawerSidebarMenuView2(selectedTab: $selectedTab)
                
            })
            
            
            ZStack {
                
                // two background Cards...
                Color.white
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                    // shadow....
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -25 : 0)
                    .padding(.vertical, 30)
                
                Color.white
                    .opacity(0.4)
                    .cornerRadius(showMenu ? 15 : 0)
                    // shadow....
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical, 60)
                
                
                DrawerSidebarHomeView2(selectedTab: $selectedTab)
                    .cornerRadius(showMenu ? 15 : 0)
                    
            }
            // Scaling and moving the view
            .scaleEffect(showMenu ? 0.84 : 1)
            .offset(x: showMenu ?  UIScreen.main.bounds.width - 120 : 0)
            .ignoresSafeArea()
            .overlay(
            
                //Menu Button
                Button(action: {
                    
                    withAnimation(.spring()){
                        showMenu.toggle()
                    }
                    
                }, label: {
                    
                    // Animted Drawer Button...
                    VStack (spacing: 5){
                        
                        Capsule()
                            .fill(showMenu ? Color.white : Color.primary)
                            .frame(width: 30, height: 3)
                        //rotating...
                            .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                            .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)
                        
                        VStack (spacing:5) {
                            
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                            
                            //moving up when clicked
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                                .offset(y: showMenu ? -8 : 0)
                        }
                        .rotationEffect(.init(degrees: showMenu ? 50 : 0))
                    }
                    
                })
                .padding()
                
                ,alignment: .topLeading
            )
            
        }
    }
}

struct DrawerSidebarMainView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerSidebarMainView()
    }
}


