//
//  Book.swift
//  AppleBooks
//
//  Created by Xiaofu666 on 2025/3/1.
//

import SwiftUI

struct Book: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var author: String
    var rating: String
    var thumbnail: String
    var color: Color
}

let books: [Book] = [
    .init(
        title: "The Lexington Letter",
        author: "Anonymous",
        rating: "4.8 (32) • Crime & Thrillers",
        thumbnail: "Profile 0",
        color: .book1
    ),
    .init(
        title: "The You You Are",
        author: "Dr. Ricken Lazlo Hale, PhD",
        rating: "4.5 (6) • Health & Wellness",
        thumbnail: "Profile 1",
        color: .book2
    )
]

let dummyText: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry'sstandard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Ithas survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularisedin the 196gs with the release of letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software likeAldus PageMaker including versions of Lorem Ipsum."
