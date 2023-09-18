//
//  ClipCornerShape.swift
//  AppStoreDetailAnimationView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct ClipCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
