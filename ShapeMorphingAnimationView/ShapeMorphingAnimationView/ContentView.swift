//
//  ContentView.swift
//  ShapeMorphingAnimationView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            ShapeMorphingAnimationView(size: proxy.size, safeArea: proxy.safeAreaInsets)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
