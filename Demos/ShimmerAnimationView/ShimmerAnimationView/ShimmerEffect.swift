//
//  ShimmerEffect.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/2.
//

import SwiftUI

@available(iOS 15.0, *)
extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig = .init()) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}

@available(iOS 15.0, *)
fileprivate struct ShimmerEffectHelper: ViewModifier {
    var config: ShimmerConfig
    @State private var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            let extraOffset = size.height / 2.5
                            
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        .fill(.linearGradient(colors: [
                                            .white.opacity(0),
                                            config.highlight.opacity(config.highlightOpacity),
                                            .white.opacity(0)
                                        ], startPoint: .top, endPoint: .bottom))
                                }
                                .blur(radius: config.blur)
                                .rotationEffect(.init(degrees: -70))
                                .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                .offset(x: moveTo * size.width)
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

struct ShimmerConfig {
    var tint: Color = Color.white.opacity(0.5)
    var highlight: Color = Color.white
    var highlightOpacity: CGFloat = 1
    var blur: CGFloat = 0
    var speed: CGFloat = 2
}

@available(iOS 15.0, *)
struct ShimmerEffect_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
            .font(.title)
            .fontWeight(.black)
            .shimmer(.init(tint: .black.opacity(0.2), highlight: .black, blur: 5))
    }
}
