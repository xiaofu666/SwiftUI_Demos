//
//  Item.swift
//  StackedCards
//
//  Created by Lurich on 2024/3/6.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = .init()
    var color: Color
}

var items: [Item] = [
    .init(color: .red),
    .init(color: .orange),
    .init(color: .yellow),
    .init(color: .green),
    .init(color: .mint),
    .init(color: .teal),
    .init(color: .cyan),
    .init(color: .blue),
    .init(color: .indigo),
    .init(color: .purple),
    .init(color: .pink),
    .init(color: .brown),
    .init(color: .gray),
]


extension [Item] {
    func zIndex(_ item: Item) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            return CGFloat(count) - CGFloat(index)
        }
        return .zero
    }
}
