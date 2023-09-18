//
//  LiquidSwipe.swift
//  LiquidSwipeAnimationView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

//液体滑动动画
struct LiquidSwipe: Shape {
    var offset: CGSize
    
    //animation Path...
    var animatableData: CGSize.AnimatableData {
        get{ return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            
            //when user moves left...
            //increasing size both in top and bottom...
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            //First Constructing Rectangle Shape
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            //now constructing curve shape
            
            //from
            let  from = 120 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 120 ? 120 : from))
            
            var to = 220 + (offset.height) + (-offset.width)
            to = to < 220 ? 220 : to
            //mid between 80 -180..
            let mid: CGFloat = 120 + ((to - 120 ) / 2)
            
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 50, y: mid), control2: CGPoint(x: width - 50, y: mid))
            
            
        }
    }
}

