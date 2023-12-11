//
//  ScrollViewOffsetModifier.swift
//  MatchedCarousel
//
//  Created by Lurich on 2021/6/23.
//

import SwiftUI

struct ScrollViewOffsetModifier: ViewModifier {
    
    var anchorPoint: AnchorType = .top
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay(
                
                GeometryReader { proxy -> Color in
                    
                    let frame = proxy.frame(in: .global)
                    
                    DispatchQueue.main.async {
                        
                        //based on anchor point getting offset...
                        switch anchorPoint {
                        case .top:
                            offset = frame.minY
                        case .bottom:
                            offset = frame.maxY
                        case .leading:
                            offset = frame.minX
                        case .trailing:
                            offset = frame.maxX
                        }
                    }
                    return Color.clear
                }
                
            )
    }
}

// custom modifer For ScrollView or tab view...

//enum for custom anchor
enum AnchorType {
    case top
    case bottom
    case leading
    case trailing
}
