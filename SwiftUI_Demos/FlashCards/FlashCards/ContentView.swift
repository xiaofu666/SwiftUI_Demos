//
//  ContentView.swift
//  FlashCards
//
//  Created by Xiaofu666 on 2025/2/7.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var dragProperties: DragProperties = .init()
    
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Flash Cards")
                .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .overlay(alignment: .topLeading) {
            if let previewImage = dragProperties.previewImage, dragProperties.show {
                Image(uiImage: previewImage)
                    .opacity(0.8)
                    .offset(
                        x:dragProperties.initialViewLocation.x,
                        y: dragProperties.initialViewLocation.y
                    )
                    .offset(dragProperties.offset)
                    .ignoresSafeArea()
            }
        }
        .environmentObject(dragProperties)
    }
}

#Preview {
    ContentView()
}
