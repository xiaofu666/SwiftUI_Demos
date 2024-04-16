//
//  Card.swift
//  CardScroll
//
//  Created by Lurich on 2023/11/4.
//

import SwiftUI

/// Card Model and Sample Cards
struct Card: Identifiable {
    var id: UUID = .init()
    var bgColor: Color
    var balance: String
}
var cards: [Card] = [
    Card(bgColor: .red,     balance: "$125,000"),
    Card(bgColor: .blue,    balance: "$25,000"),
    Card(bgColor: .orange,  balance: "$25,000"),
    Card(bgColor: .purple,  balance: "$5,000")
]
