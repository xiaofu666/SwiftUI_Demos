//
//  PagingIndicator.swift
//  AnimatedPageIndicator
//
//  Created by Lurich on 2024/1/3.
//

import SwiftUI

struct PagingIndicator: View {
    var activeTint: Color = .primary
    var inActiveTint: Color = .primary.opacity(0.15)
    var opacityEffect: Bool = false
    var clipEdges: Bool = false
    var circleWidth: CGFloat = 8
    var activeCapsuleWidth: CGFloat = 18
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            if let scrollWidth = $0.bounds(of: .scrollView(axis: .horizontal))?.width, scrollWidth > 0 {
                let totalPages = Int(size.width / scrollWidth)
                let minX = $0.frame(in: .scrollView).minX
                let freeProgress = -minX / scrollWidth
                let clippedProgress = max(min(freeProgress, CGFloat(totalPages - 1)), 0.0)
                let progress = clipEdges ? clippedProgress : freeProgress
                let activeIndex = Int(progress)
                let nextIndex = Int(progress.rounded(.awayFromZero))
                let indicatorProgress = progress - CGFloat(activeIndex)
                let nextPageWidth = indicatorProgress * activeCapsuleWidth
                let currentPageWidth = activeCapsuleWidth - nextPageWidth
                
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(inActiveTint)
                            .frame(width: circleWidth + (activeIndex == index ? currentPageWidth : (nextIndex == index ? nextPageWidth : 0)), height: circleWidth)
                            .overlay {
                                ZStack {
                                    Capsule()
                                        .fill(inActiveTint)
                                    
                                    Capsule()
                                        .fill(activeTint)
                                        .opacity(opacityEffect ? (activeIndex == index ? (1 - indicatorProgress) : (nextIndex == index ? indicatorProgress : 0)) : 1)
                                }
                            }
                    }
                }
                .frame(width: scrollWidth)
                .offset(x: -minX)
            }
        }
        .frame(height: circleWidth * 3)
    }
}

#Preview {
    ContentView()
}
