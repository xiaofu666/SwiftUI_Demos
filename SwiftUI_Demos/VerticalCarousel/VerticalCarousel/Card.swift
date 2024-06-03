//
//  Card.swift
//  VerticalCarousel
//
//  Created by Lurich on 2024/6/3.
//

import SwiftUI

struct Card: Identifiable {
    var id: UUID = .init()
    var number: String
    var name: String = "xiaofu"
    var date: String = "12/24"
    var color: Color
}

var cards: [Card] = [
    .init(number:"1234", color: .purple),
    .init(number:"5678", color: .red),
    .init(number:"0987", color: .blue),
    .init(number:"0756", color: .orange),
    .init(number:"3679", color: .black),
    .init(number:"4702", color: .brown),
    .init(number:"7691", color: .cyan)
]
