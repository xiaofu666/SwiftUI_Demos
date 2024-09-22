//
//  Chip.swift
//  ChipsUI
//
//  Created by Xiaofu666 on 2024/9/22.
//

import SwiftUI

struct Chip: Identifiable {
    var id: String = UUID().uuidString
    var name: String
}

var mockChips: [Chip] = [
    .init(name: "Apple"),
    .init(name: "Google"),
    .init(name: "Microsoft"),
    .init(name: "Amazon"),
    .init(name: "Facebook"),
    .init(name: "Twitter"),
    .init(name: "Netflix"),
    .init(name: "Youtube"),
    .init(name: "Instagram"),
    .init(name: "Snapchat"),
    .init(name: "Pinterest"),
    .init(name: "Reddit"),
    .init(name: "TikTok"),
    .init(name: "Uber"),
    .init(name: "Spotify")
]


