//
//  ContentView.swift
//  ReelsLayout
//
//  Created by Lurich on 2023/11/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea()
                .environment(\.colorScheme, .dark)
        }
    }
}

#Preview {
    ContentView()
}
