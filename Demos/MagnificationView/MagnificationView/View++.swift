//
//  View++.swift
//  MagnificationView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

extension View {
    @ViewBuilder
    func magnificationEffect(_ scale: CGFloat, _ rotation: CGFloat, _ size: CGFloat = 0, _ tint: Color = .white) -> some View {
        MagnificationEffect(scale: scale, rotation: rotation, size: size, tint: tint, content: {
            self
        })
    }
    
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}

struct MagnificationEffect<Content: View>: View {
    var scale: CGFloat
    var rotation: CGFloat
    var size: CGFloat
    var tint: Color
    
    var content: Content
    
    init(scale: CGFloat, rotation: CGFloat, size: CGFloat, tint: Color = .white,@ViewBuilder content: @escaping () -> Content) {
        self.scale = scale
        self.rotation = rotation
        self.size = size
        self.tint = tint
        self.content = content()
    }
    
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    
    var body: some View {
        content
            .reverseMask(content: {
                let newCircleSize = 150 + size
                Circle()
                    .frame(width: newCircleSize, height: newCircleSize)
                    .offset(offset)
            })
            .overlay {
                GeometryReader {
                    let newCircleSize = 150 + size
                    let size = $0.size
                    
                    content
                        .offset(x: -offset.width, y: -offset.height)
                        .frame(width: newCircleSize, height: newCircleSize)
                        .scaleEffect(1.1 + scale)
                        .clipShape(Circle())
                        .offset(offset)
                        .frame(width: size.width, height: size.height)
                    
                    Circle()
                        .fill(.clear)
                        .frame(width: newCircleSize, height: newCircleSize)
                        .overlay(content: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(1.4, anchor: .topLeading)
                                .offset(x: -10, y: -5)
                                .foregroundColor(tint)
                                .rotationEffect(.init(degrees: 360 * rotation))
                        })
                        .offset(offset)
                        .frame(width: size.width, height: size.height)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = CGSize(width: value.translation.width + lastStoredOffset.width, height: value.translation.height + lastStoredOffset.height)
                    })
                    .onEnded({ value in
                        lastStoredOffset = offset
                    })
            )
    }
}

