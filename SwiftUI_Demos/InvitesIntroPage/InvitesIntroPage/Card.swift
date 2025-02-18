//
//  Card.swift
//  InvitesIntroPage
//
//  Created by Xiaofu666 on 2025/2/18.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
}

let cards: [Card] = [
    .init(image: "Profile 1"),
    .init(image: "Profile 2"),
    .init(image: "Profile 3"),
    .init(image: "Profile 4"),
]
