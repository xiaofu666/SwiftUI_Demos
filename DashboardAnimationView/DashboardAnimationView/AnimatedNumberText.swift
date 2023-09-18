//
//  AnimatedText.swift
//  InstrumentPanel0412
//
//  Created by Lurich on 2022/4/12.
//

import SwiftUI

struct AnimatedNumberText: Animatable, View {
    
    var value: CGFloat
    
    var font: Font
    var floatingPoint:Int = 2
    var isCurrency: Bool = false
    var additionlString: String = ""
    
    var animatableData: CGFloat {
        
        get{value}
        set{value = newValue}
    }
    
    var body: some View {
        Text("\(isCurrency ? "$" : "")\(String(format: "%.\(floatingPoint)f", value))" + additionlString)
            .font(font)
    }
}


