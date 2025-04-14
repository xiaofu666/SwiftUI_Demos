//
//  SkeletonView.swift
//  Skeleton
//
//  Created by Xiaofu666 on 2025/4/14.
//

import SwiftUI

struct SkeletonView<S: Shape>: View {
    private var shape: S
    private var color: Color
    init(_ shape: S, color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    @State private var isAnimating: Bool = false
    
    var body: some View {
        shape
            .fill(color)
            /// 骨架效应
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    /// 将模糊半径限制为30+
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    /// 移动偏移
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter

                    
                    Rectangle()
                        .fill(.gray)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                        /// 从左到右移动
                        .offset(x: isAnimating ? maxX : minX)
                }
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear {
                guard !isAnimating else { return }
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .onDisappear {
                /// 停止动画
                isAnimating = false
            }
            .transaction {
                if $0.animation != animation {
                    $0.animation = .none
                }
            }
    }
    /// Customizable Properties
    var rotation: Double {
        return 5
    }
    var animation: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
}

#Preview {
    SkeletonView(.circle)
        .frame(width: 100, height: 100)
}
