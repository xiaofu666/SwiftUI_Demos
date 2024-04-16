//
//  Intro.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/26.
//

import SwiftUI

/// Intro Model
struct Intro: Identifiable {
    var id: UUID = .init()
    var text: String
    var textColor: Color
    var circleColor: Color
    var bgColor: Color
    var circleOffset: CGFloat = 0
    var textOffset: CGFloat = 0
}

var sampleIntros: [Intro] = [
    .init(text: "Let's Create"      , textColor: .color4, circleColor: .color4, bgColor: .color1),
    .init(text: "Let's Brain Storm" , textColor: .color1, circleColor: .color1, bgColor: .color2),
    .init(text: "Let's Explore"     , textColor: .color2, circleColor: .color2, bgColor: .color3),
    .init(text: "Let's Invent"      , textColor: .color3, circleColor: .color3, bgColor: .color4),
    .init(text: "Let's Create"      , textColor: .color4, circleColor: .color4, bgColor: .color1)
]
