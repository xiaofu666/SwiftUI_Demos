//
//  ContentView.swift
//  StackedCardsView
//
//  Created by Lurich on 2024/5/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image(.wallpaper)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            
            Home()
        }
    }
}

#Preview {
    ContentView()
}
