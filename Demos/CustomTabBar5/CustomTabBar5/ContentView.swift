//
//  ContentView.swift
//  CustomTabBar5
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    
    @State var current = "Home"
    @Environment(\.dismiss) var dismiss
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
    
        ZStack (alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            
            TabView(selection: $current) {
                
                Text("Go Home")
                    .tag("Home")
                
                Text("Messages")
                    .tag("Messages")
                
                Text("Account")
                    .tag("Account")
            }
            
            HStack(spacing: 0) {
                
                TabBar5_TabButton(title: "Home", image: "house", selected: $current)
                
                Spacer()
                
                TabBar5_TabButton(title: "Messages", image: "message", selected: $current)
                
                Spacer()
                
                TabBar5_TabButton(title: "Account", image: "person", selected: $current)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color.black.opacity(0.9))
            .clipShape(Capsule())
            .padding(.horizontal, 25)
        })
    }
}

@available(iOS 15.0, *)
struct TabBar5_TabButton: View {
    
    var title : String
    var image : String
    
    @Binding var selected : String
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()) {selected = title}
        }, label: {
            
            HStack(spacing: 10) {
                
                Image(systemName: image)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                
                if selected == title {
                    
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.white.opacity(selected == title ? 0.08 : 0))
            .clipShape(Capsule())
        })
    }
}


#Preview {
    ContentView()
}
