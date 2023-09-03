//
//  CardModel.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/1.
//

import SwiftUI

struct CardModel: Identifiable, Hashable, Equatable {
    var id: UUID = .init()
    var image: String
    var previousOffset: CGFloat = 0
}

extension [CardModel] {
    func indexOf(_ card: CardModel) -> Int {
        return self.firstIndex(of: card) ?? 0
    }
}
