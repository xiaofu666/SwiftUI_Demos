//
//  StackedCards.swift
//  StackedCardsView
//
//  Created by Lurich on 2024/5/27.
//

import SwiftUI

struct StackedCards<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    var items: Data
    var stackedDisplayCount: Int = 2
    var opacityDisplayCount: Int = 2
    var spacing: CGFloat = 5
    var itemHeight: CGFloat
    @ViewBuilder var content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let topPadding: CGFloat = size.height - itemHeight - 40
            
            ScrollView(.vertical) {
                VStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(height: itemHeight)
                            .visualEffect { content, geometryProxy in
                                content
                                    .opacity(opacity(geometryProxy))
                                    .scaleEffect(scale(geometryProxy), anchor: .bottom)
                                    .offset(y: offset(geometryProxy))
                            }
                            .zIndex(zIndex(item))
                    }
                }
                .scrollTargetLayout()
                .overlay(alignment: .top) {
                    HeaderView(topPadding)
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.top, topPadding)
            .safeAreaPadding(.bottom, 40)
            .scrollClipDisabled()
        }
    }
    
    @ViewBuilder
    func HeaderView(_ topPadding: CGFloat) -> some View {
        VStack {
            Text(Date.now.formatted(date: .complete, time: .omitted))
                .font(.title3.bold())
            
            Text("23:02")
                .font(.system(size: 100, weight: .bold, design: .rounded))
        }
        .foregroundStyle(.white)
        .visualEffect { content, geometryProxy in
            content
                .offset(y: headerOffset(geometryProxy, topPadding))
        }
    }
    
    func headerOffset(_ proxy: GeometryProxy, _ topPadding: CGFloat) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let viewSize = proxy.size.height - itemHeight * CGFloat(stackedDisplayCount) - 40
        return -minY > (topPadding - viewSize) ? -viewSize : -minY - topPadding
    }
    
    func zIndex(_ item: Data.Element) -> Double {
        if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
            return Double(items.count) - Double(index)
        }
        return 0
    }
    
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxOffset = CGFloat(stackedDisplayCount) * offsetForEachItem
        let offset = max(min(progress * offsetForEachItem, maxOffset), 0.0)
        return minY < 0 ? 0 : -minY + offset
    }
    
    var offsetForEachItem: CGFloat {
        return 25
    }
    
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxScale = CGFloat(stackedDisplayCount) * scaleForEachItem
        let scale = max(min(progress * scaleForEachItem, maxScale), 0.0)
        return 1 - scale
    }
    
    var scaleForEachItem: CGFloat {
        return 0.08
    }
    
    func opacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxOpacity = CGFloat(opacityDisplayCount + 1) * opacityForEachItem
        let opacity = max(min(progress * opacityForEachItem, maxOpacity), 0.0)
        return progress < CGFloat(opacityDisplayCount + 1) ? 1 - opacity : 0
    }
    
    var opacityForEachItem: CGFloat {
        return 1 / CGFloat(opacityDisplayCount + 1)
    }
}

#Preview {
    ContentView()
}
