//
//  IsometricView.swift
//  BoolAppAnimation1219
//
//  Created by Lurich on 2022/12/19.
//

import SwiftUI

struct CustomProjection: GeometryEffect {
    var value: CGFloat
    var animatableData: CGFloat {
        get {
            return value
        }
        set {
            value = newValue
        }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        var transform = CATransform3DIdentity
        transform.m11 = value == 0 ? 0.001 : value
        return .init(transform)
    }
}


@available(iOS 15.0, *)
struct IsomertricView<Content: View, Bottom: View, Side: View> : View {
    
    var content: Content
    var bottom: Bottom
    var side: Side
    
    var depth: CGFloat
    
    init(depth: CGFloat,@ViewBuilder content: @escaping() -> Content, @ViewBuilder bottom: @escaping() -> Bottom, @ViewBuilder side: @escaping() -> Side) {
        self.depth = depth
        self.content = content()
        self.bottom = bottom()
        self.side = side()
    }
    
    var body: some View {
        Color.clear
            .overlay {
                GeometryReader {
                    let size = $0.size
                    
                    ZStack {
                        content
                        DepthView(isBottom: true, size: size)
                        DepthView(isBottom: false, size: size)
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
    }
    
    
    @ViewBuilder
    func DepthView(isBottom:Bool = false, size: CGSize) -> some View {
        ZStack {
            if isBottom {
                bottom
                    .scaleEffect(y: depth, anchor: .bottom)
                    .frame(height: depth, alignment: .bottom)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(1, 0, 1, 1, 0, 0)))
                    .offset(y: depth)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                side
                    .scaleEffect(x: depth, anchor: .trailing)
                    .frame(width: depth, alignment: .trailing)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    .projectionEffect(.init(.init(1, 1, 0, 1, 0, 0)))
                    .offset(x: depth)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
 
