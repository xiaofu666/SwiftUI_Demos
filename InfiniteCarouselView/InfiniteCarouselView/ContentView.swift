//
//  ContentView.swift
//  InfiniteCarouselView
//
//  Created by Lurich on 2023/9/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                InfiniteCarouselView()
                
                ViewLoop()
            }
            .padding()
            .navigationTitle("轮播图")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
