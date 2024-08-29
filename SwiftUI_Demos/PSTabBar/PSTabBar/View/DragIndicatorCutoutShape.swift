//
//  DragIndicatorCutoutShape.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/29.
//

import SwiftUI

struct DragIndicatorCutoutShape: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    nonisolated func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .init(x: 0, y: 0))
            path.addLine(to: .init(x: 0, y: rect.height))
            
            let height = 6 - (6 * progress)
            
            path.addLine(to: .init(x: (rect.width / 2) - 40, y: rect.height))
            path.addLine(to:.init(x: (rect.width / 2) - 32, y: rect.height - height))
            path.addLine(to: .init(x:(rect.width / 2) + 32, y: rect.height - height))
            path.addLine(to: .init(x: (rect.width / 2) + 40, y: rect.height))
            
            path.addLine(to: .init(x: rect.width, y: rect.height))
            path.addLine(to: .init(x: rect.width, y: 0))
        }
    }
}
