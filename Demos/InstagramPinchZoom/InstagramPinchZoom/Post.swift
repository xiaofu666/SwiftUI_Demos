//
//  Post.swift
//  InstagramPinchZoom
//
//  Created by Lurich on 2024/3/30.
//

import SwiftUI

struct Post: Identifiable {
    var id: UUID = .init()
    var author: String
    var title: String
    var image: String
    var url: String
}

var posts: [Post] = [
    .init(
        author: "iJustine",
        title: "First look at the M3 MacBook Air 👀",
        image: "user1",
        url: "https://youtu.be/uhXbQVViIcs"
    ),
    .init(
        author: "iJustine",
        title: "Apple Vision Pro - Unboxing, Review and demos!",
        image: "user2",
        url: "https://youtu.be/CaWt6-xe29k"
    ),
    .init(
        author: "Joseba Garcia Moya",
        title: "Rabbit on Grass",
        image: "user3",
        url: "https://www.pexels.com/photo/rabbit-on-grass-19126536/"
    ),
    .init(
        author: "Toa Heftiba Sinca",
        title: "Photograph of a Wall With Grafitti",
        image: "user4",
        url: "https://www.pexels.com/photo/selective-photograph-of-a-wall-with-grafitti-1194420/"
    ),
]
