//
//  ContentView.swift
//  YoutubeHomeView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let size = proxy.size
            YoutubeHomeView(safeArea: safeArea, size: size)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
