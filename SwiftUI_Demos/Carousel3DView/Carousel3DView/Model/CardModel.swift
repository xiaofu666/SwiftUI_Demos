//
//  CardModel.swift
//  Carousel3DView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct CardModel: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var imageName: String
    
    var isRotaed: Bool = false
    var extraOffset: CGFloat = 0
    var scale: CGFloat = 1.0
    var zIndex: Double = 0
}
