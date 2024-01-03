//
//  ParallaxImageView.swift
//  ScrollParallax
//
//  Created by Lurich on 2023/12/28.
//

import SwiftUI

struct ParallaxImageView<Content: View>: View {
    var maximumMovement: CGFloat = 100
    var usesFullWidth: Bool = false
    @ViewBuilder var content: (CGSize) -> Content
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let minY = geometry.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = geometry.bounds(of: .scrollView)?.size.height ?? 0
            let maximumMovement = min(maximumMovement, size.height * 0.35)
            let stretchedSize: CGSize = CGSize(width: size.width, height: size.height + maximumMovement)
            
            let progress = minY / scrollViewHeight
            let cappedProgress = max(min(progress, 1.0), -1.0)
            let movementOffset = cappedProgress * -maximumMovement
            
            content(size)
                .offset(y: movementOffset)
                .frame(width: stretchedSize.width, height: stretchedSize.height)
                .frame(width: size.width, height: size.height)
                .clipped()
        })
        .containerRelativeFrame(usesFullWidth ? [.horizontal] : [])
    }
}

#Preview {
    ContentView()
}
