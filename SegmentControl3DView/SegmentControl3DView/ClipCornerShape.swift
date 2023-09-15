//
//  ClipCornerShape.swift
//  SegmentControl3DView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

//指定方向加圆角 [topLeft, topRight, bottomLeft, bottomRight] 或 allCorners
///example :  ClipCornerShape(corners: [.topRight, .bottomRight], radius: 10)
struct ClipCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
