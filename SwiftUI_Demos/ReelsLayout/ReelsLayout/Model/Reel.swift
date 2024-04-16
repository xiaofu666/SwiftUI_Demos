//
//  Reel.swift
//  ReelsLayout
//
//  Created by Lurich on 2023/11/14.
//

import SwiftUI

struct Reel: Identifiable {
    var id: UUID = .init()
    var videoID: String
    var authorName: String
    var isLiked: Bool = false
}
var reelsData: [Reel] = [
    .init(videoID: "Reel1", authorName: "少妇"),
    .init(videoID: "Reel2", authorName: "丫头"),
    .init(videoID: "Reel3", authorName: "美女")
]
