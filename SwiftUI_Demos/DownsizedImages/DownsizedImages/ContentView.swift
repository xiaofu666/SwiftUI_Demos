//
//  ContentView.swift
//  DownsizedImages
//
//  Created by Xiaofu666 on 2025/1/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical) {
            ForEach(1...5, id: \.self) { index in
                let id: String = "Profile \(index)"
                let size: CGSize = .init(width: 350, height: 150)
                
                DownsizedImageView(id: id, image: .init(named: id), size: size) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
    }
}

#Preview {
    ContentView()
}
