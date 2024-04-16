//
//  Post.swift
//  ImageViewer
//
//  Created by Lurich on 2023/12/12.
//

import SwiftUI

struct Post: Identifiable {
    var id: UUID = .init()
    var name: String
    var content: String
    var pics: [PicItem]
    var scrollPosition: UUID?
}

var samplePosts: [Post] = [
    .init(name: "Swift", content: "UI", pics: pics1),
    .init(name: "Apple", content: "Company", pics: pics2),
    .init(name: "Developer", content: "Hello world", pics: pics3),
]

private var pics1: [PicItem] = (1...6).compactMap { index -> PicItem? in
    return .init(image: "user\(index)")
}
private var pics2: [PicItem] = (1...6).shuffled().compactMap { index -> PicItem? in
    return .init(image: "user\(index)")
}
private var pics3: [PicItem] = (1...6).reversed().compactMap { index -> PicItem? in
    return .init(image: "user\(index)")
}
