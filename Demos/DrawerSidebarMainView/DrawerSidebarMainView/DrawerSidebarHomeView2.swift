//
//  Home.swift
//  Custom_Side_Menu
//
//  Created by Lurich on 2021/6/9.
//

import SwiftUI

struct DrawerSidebarHomeView2: View {
    
    @Binding var selectedTab: String
    
    // Hiding Tab Bar
    init(selectedTab: Binding<String>) {
        
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
        
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomePage()
                .tag("Home")
            
            History()
                .tag("History")
            
            Notifications()
                .tag("Notifications")
            
            Settings()
                .tag("Settings")
            
            Help()
                .tag("Help")
            
            
        }
        
    }
}

struct DrawerSidebarHomeView2_Previews: PreviewProvider {
    static var previews: some View {
        DrawerSidebarMainView()
    }
}


struct HomePage: View  {
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading, spacing: 20, content: {
                
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 400)
                    .cornerRadius(20)
                
                VStack(alignment: .center, spacing: 5, content: {
                    
                    Text("Sanji")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                        
                })
                
            })
            .navigationTitle("Home")
        }
    }
}

struct History: View {
    
    var body: some View {
        
        NavigationView {
            
            Text("History")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("History")
            
        }
    }
}


struct Settings: View  {
    
    var body: some View {
        
        NavigationView {
            
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Settings")
            
        }
    }
}

struct Notifications: View  {
    
    var body: some View {
        
        NavigationView {
            
            Text("Notifications")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Notifications")
            
        }
    }
}



struct Help: View  {
    
    var body: some View {
        
        NavigationView {
            
            Text("Help")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Help")
            
        }
    }
}


