//
//  Item.swift
//  StackedCardsView
//
//  Created by Lurich on 2024/5/27.
//

import SwiftUI

struct Item: Identifiable{
    var id: UUID = .init()
    var logo: String
    var title: String
    var description: String = "This text is simply dummy text of the printing and typesetting industry."
}

var items: [Item] = [
    Item(logo: "", title: ""),
    Item(logo: "", title: ""),
    Item(logo: "", title: ""),
    Item(logo: "user0", title: "Amazon"),
    Item(logo: "user1", title: "Youtube"),
    Item(logo: "user2", title: "Dribbble"),
    Item(logo: "user3", title: "Apple"),
    Item(logo: "user4", title: "Patreon"),
    Item(logo: "user5", title: "Instagram"),
    Item(logo: "user0", title: "Photoshop"),
    Item(logo: "user1", title: "Figma"),
    Item(logo: "user2", title: "Wechat"),
    Item(logo: "user3", title: "QQ"),
    Item(logo: "user4", title: "Watch"),
    Item(logo: "user5", title: "Netflix"),
]
