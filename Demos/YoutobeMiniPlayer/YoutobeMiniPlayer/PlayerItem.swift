//
//  PlayerItem.swift
//  YoutobeMiniPlayer
//
//  Created by Lurich on 2024/2/24.
//

import SwiftUI

/// player Item Model
let dummyDescription: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."

struct PlayerItem: Identifiable, Equatable {
    let id: UUID = .init()
    var title: String
    var author: String
    var image: String
    var description: String = dummyDescription
}
var items: [PlayerItem]=[
    .init(
    title: "Apple Vision Pro - Unboxing,Review and demos!",
    author: "xiaofu",
    image: "user1"
    ),
    .init(
    title: "Hero Effect - SwiftUI",
    author: "666",
    image:"user2"
    ),
    .init(
    title: "What Apple Vision Pro is really like.",
    author: "lurich",
    image: "user3"
    ),
    .init(
    title: "Draggable Map Pin",
    author: "666",
    image:"user4"
    ),
    .init(
    title: "Maps Bottom Sheet",
    author: "github",
    image:"user5"
    )
]
