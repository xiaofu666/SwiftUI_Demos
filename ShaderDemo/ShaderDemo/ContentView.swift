//
//  ContentView.swift
//  ShaderDemo
//
//  Created by Lurich on 2023/9/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 15, content: {
                    PixellateView()
                    
                    WavesView()
                    
                    GrayScaleView()
                })
            }
            .navigationTitle("Shader Demo")
        }
    }
}

#Preview {
    ContentView()
}
