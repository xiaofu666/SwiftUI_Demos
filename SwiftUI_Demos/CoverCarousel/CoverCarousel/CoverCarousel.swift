//
//  CoverCarousel.swift
//  CoverCarousel
//
//  Created by Xiaofu666 on 2024/7/24.
//

import SwiftUI

struct CoverCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    var config: Config
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(data) { item in
                        ItemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, max((size.width - config.cardWidth), 0) / 2.0)
            .scrollPosition(id: $selection)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        }
    }
    
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (config.cardWidth + config.spacing)
            let minimumCardWidth = config.minimumCardWidth
            let diffWidth = config.cardWidth - minimumCardWidth
            let reducingWidth = progress * diffWidth
            let cappedWidth = min(reducingWidth, diffWidth)
            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
            
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            content(item)
                .frame(width: size.width, height: size.height)
                .frame(width: resizedFrameWidth)
                .opacity(config.hasOpacity ? (1 - opacityValue) : 1)
                .scaleEffect(config.hasScale ? (1 - scaleValue) : 1)
                .mask {
                    let hasScale = config.hasScale
                    let scaleHeight = max((1 - scaleValue) * size.height, 0)
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: hasScale ? scaleHeight : size.height)
                }
                .offset(x: -reducingWidth)
                .offset(x: max(min(progress, 1.0), 0.0) * diffWidth)
        }
        .frame(width: config.cardWidth)
    }
}

struct Config {
    var hasOpacity: Bool = false
    var opacityValue: CGFloat = 0.4
    var hasScale: Bool = false
    var scaleValue: CGFloat = 0.2
    
    var cardWidth: CGFloat = 200
    var spacing: CGFloat = 10
    var cornerRadius: CGFloat = 15
    var minimumCardWidth: CGFloat = 40
}

#Preview {
    ContentView()
}
