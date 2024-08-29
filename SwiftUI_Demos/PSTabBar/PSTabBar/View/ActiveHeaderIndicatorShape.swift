//
//  ActiveHeaderIndicatorShape.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/29.
//

import SwiftUI

struct ActiveHeaderIndicatorShape: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        return Path { path in
            let midVal = rect.width - 50
            
            path.move(to: .init(x: 0, y: 0))
            
            let pt1 = CGPoint.init(x: 0, y: 0)
            let pt2 = CGPoint.init(x: 0, y: rect.height)
            let pt3 = CGPoint.init(x: rect.width - 70, y: rect.height)
            let pt4 = CGPoint.init(x: rect.width - 50, y: 0)
            
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 15)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 15)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 15)
            
            let to1 = CGPoint(x: midVal + 20, y: rect.height - 50)
            let control1 = CGPoint(x: midVal + 0, y: rect.height - 50)
            let control2 = CGPoint(x: midVal + 0, y: rect.height - 50)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
