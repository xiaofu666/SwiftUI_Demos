//
//  Card.swift
//  WalletCardAnimation
//
//  Created by Xiaofu666 on 2024/12/9.
//

import SwiftUI

struct Card: Identifiable {
    var id: String = UUID().uuidString
    var number: String
    var expires: String
    var color: Color
    
    var visaGeometryID: String {
        "VISA_\(id)"
    }
}

var cards: [Card] = [
    .init(number: "**** **** **** 1234", expires: "02/27", color: .blue),
    .init(number: "**** **** **** 5678", expires: "06/24", color: .indigo),
    .init(number: "**** **** **** 1357", expires: "09/17", color: .pink),
    .init(number: "**** **** **** 2468", expires: "12/21", color: .black),
]
