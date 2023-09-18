//
//  ContentView.swift
//  ResizableHeaderView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            ResizableHeaderDetailView(size: proxy.size, safeArea: proxy.safeAreaInsets)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
