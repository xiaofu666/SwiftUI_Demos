//
//  ContentView.swift
//  TwitterProfileScrollingView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            TwitterProfileScrollingView(size: proxy.size)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
