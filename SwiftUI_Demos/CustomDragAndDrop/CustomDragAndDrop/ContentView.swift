//
//  ContentView.swift
//  CustomDragAndDrop
//
//  Created by Xiaofu666 on 2024/9/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            
            Image(.bgImg)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 40, opaque: true)
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.25))
                }
                .ignoresSafeArea()
            
            Home(safeArea: safeArea)
        }
    }
}

#Preview {
    ContentView()
}
