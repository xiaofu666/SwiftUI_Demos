//
//  ContentView.swift
//  ListHeaderAnimationView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ListHeaderAnimationView()
                .tag("1")
                .tabItem {
                    Label("示例 1", systemImage: "person.crop.artframe")
                }
            
            ListHeaderAnimationView2()
                .tag("2")
                .tabItem {
                    Label("示例 2", systemImage: "photo.artframe")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
