//
//  RoundedCorners.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 09/07/21.
//

import SwiftUI

struct RoundedCorners: Shape {
    var corners: UIRectCorner = .allCorners
    var radius: CGFloat = .infinity
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
