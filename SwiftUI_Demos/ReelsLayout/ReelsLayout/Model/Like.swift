//
//  Like.swift
//  ReelsLayout
//
//  Created by Lurich on 2023/11/14.
//

import SwiftUI


struct Like: Identifiable {
    var id: UUID = .init()
    var tappedRect: CGPoint = .zero
    var isAnimated: Bool = false
}
