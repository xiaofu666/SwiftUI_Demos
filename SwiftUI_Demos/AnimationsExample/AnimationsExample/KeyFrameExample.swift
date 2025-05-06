//
//  KeyFrameExample.swift
//  CTabBar
//
//  Created by Xiaofu666 on 2025/5/6.
//

import SwiftUI

struct KeyFrameExample: View {
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 12) {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        MarqueeText(text: "Hello World, This is Marquee Effect using KeyFrames API!")

                        Text("By **Xiaofu666**")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(15)
                .background(.background, in: .rect(cornerRadius: 12))
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .background(.gray.opacity(0.15))
    }
}

struct MarqueeText: View {
    var text: String
    @State private var textSize: CGSize = .zero
    @State private var viewSize: CGSize = .zero
    @State private var isMarqueeEnabled: Bool = false
    
    var body: some View {
        ScrollView(.horizontal) {
            Text(text)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { newValue in
                    textSize = newValue
                    isMarqueeEnabled = textSize.width > viewSize.width
                }
                .modifiers { content in
                    if isMarqueeEnabled {
                        content
                            .keyframeAnimator(initialValue: 0.0, repeating: true) { [textSize, gap] content, progress in
                                let offset = textSize.width + gap
                                
                                content
                                    .overlay(alignment: .trailing) {
                                        content
                                            .offset(x: offset)
                                    }
                                    .offset(x: -offset * progress)
                            } keyframes:{ _ in
                                LinearKeyframe(0, duration: holdTime)
                                LinearKeyframe(1, duration: speed)
                            }
                    } else {
                        content
                    }
                }
        }
        .scrollDisabled(true)
        .scrollIndicators(.hidden)
        .onGeometryChange(for: CGSize.self) {
            $0.size
        } action: { newValue in
            viewSize = newValue
        }
    }
    
    // 自定义属性
    // 等待下一次迭代开始的时间
    var holdTime: CGFloat {
        return 2
    }
    
    // 字幕效果的速度
    var speed: CGFloat {
        return 6
    }
    
    // Gap between Texts
    var gap: CGFloat {
        return 25
    }
}

extension View {
    /// 基于条件的视图修改器
    @ViewBuilder
    func modifiers<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}

#Preview {
    KeyFrameExample()
}
