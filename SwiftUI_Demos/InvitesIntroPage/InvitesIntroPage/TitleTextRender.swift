//
//  TitleTextRender.swift
//  InvitesIntroPage
//
//  Created by Xiaofu666 on 2025/2/18.
//

import SwiftUI

struct TitleTextRenderer: TextRenderer, Animatable {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let slices = layout.flatMap({ $0 }).flatMap({ $0 })
        for (index,slice) in slices.enumerated() {
            let sliceProgressIndex = CGFloat(slices.count) * progress
            let sliceProgress = max(min(sliceProgressIndex / CGFloat(index + 1), 1), 0)
            /// 如果希望每个切片从其原点开始，请为每个循环创建一个复制上下文，例如
            ///"var copy = context.”
            /// 但是，我希望上下文在每次循环后递增，所以我直接使用上下文而不复制！
            ctx.addFilter(.blur(radius:5 - (5 * sliceProgress)))
            ctx.opacity = sliceProgress
            ctx.translateBy(x: 0, y: 5 - (5 * sliceProgress))
            ctx.draw(slice, options: .disablesSubpixelQuantization)
        }
    }
}
