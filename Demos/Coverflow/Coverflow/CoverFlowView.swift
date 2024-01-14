//
//  CoverFlowView.swift
//  Coverflow
//
//  Created by Lurich on 2024/1/14.
//

import SwiftUI

struct CoverFlowView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    var itemWidth: CGFloat
    var enableReflection: Bool = false
    var spacing: CGFloat = 0
    var rotation: Double
    var items: Item
    var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflection)
                            .visualEffect { content, geometryProxy in
                                content
                                    .rotation3DEffect(.init(degrees: rotation(geometryProxy)), axis: (x: 0, y: 1, z: 0), anchor: .center)
                            }
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    }
                }
                .padding(.horizontal, (size.width - itemWidth) / 2.0)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
    
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        let progress = midX / scrollViewWidth
        let cappedProgress = max(min(progress, 1.0), 0.0)
        let cappedRotation = max(min(rotation, 90), 0)
        let degree = cappedProgress * (rotation * 2)
        return cappedRotation - degree
    }
}

struct CoverFlowItem: Identifiable {
    let id: UUID = .init()
    var color: Color
}

fileprivate extension View {
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader {
                        let size = $0.size
                        
                        self
                            .scaleEffect(y: -1)
                            .mask {
                                Rectangle()
                                    .fill(
                                        .linearGradient(
                                            colors: [
                                                .white,
                                                .white.opacity(0.7),
                                                .white.opacity(0.5),
                                                .white.opacity(0.3),
                                                .white.opacity(0.1),
                                                .white.opacity(0)
                                            ] + Array(repeating: Color.clear, count: 5),
                                            startPoint: .top,
                                            endPoint: .bottom)
                                    )
                            }
                            .offset(y: size.height + 5)
                            .opacity(0.5)
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
