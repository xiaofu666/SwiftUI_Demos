//
//  Item.swift
//  Custom_Header
//
//  Created by Xiaofu666 on 2024/8/17.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = .init()
    var title: String
    var image: UIImage?
}

var sampleItems: [Item] = [
    .init(title: "Profile 0", image: UIImage(named: "Profile 0")),
    .init(title: "Profile 1", image: UIImage(named: "Profile 1")),
    .init(title: "Profile 2", image: UIImage(named: "Profile 2")),
    .init(title: "Profile 3", image: UIImage(named: "Profile 3")),
    .init(title: "Profile 4", image: UIImage(named: "Profile 4")),
    .init(title: "Profile 5", image: UIImage(named: "Profile 5")),
    .init(title: "Profile 6", image: UIImage(named: "Profile 6")),
    .init(title: "Profile 7", image: UIImage(named: "Profile 7")),
    .init(title: "Profile 8", image: UIImage(named: "Profile 8")),
]
