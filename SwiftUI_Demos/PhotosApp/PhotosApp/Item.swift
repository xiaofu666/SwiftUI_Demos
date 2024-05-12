//
//  Item.swift
//  PhotosApp
//
//  Created by Lurich on 2024/5/12.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var image: UIImage?
    var previewImage:UIImage?
    var appeared:Bool = false
}
var sampleItems: [Item] = [
    .init(title: "Fanny Hagan",                 image: UIImage(named: "Pic 1")),
    .init(title: "Han-Chieh Lee",               image: UIImage(named: "Pic 2")),
    .init(title: "xiaofu666",                   image: UIImage(named: "Pic 3")),
    .init(title: "Abril Altamirano",            image: UIImage(named: "Pic 4")),
    .init(title: "Gülsah Aydogan",              image: UIImage(named: "Pic 5")),
    .init(title: "Melike Sayar Melikesayar",    image: UIImage(named: "Pic 6")),
    .init(title: "Maahid Photos",               image: UIImage(named: "Pic 7")),
    .init(title: "Pelageia Zelenina",           image: UIImage(named: "Pic 8")),
    .init(title: "Ofir Eliav",                  image: UIImage(named: "Pic 9")),
    .init(title: "Melike Sayar Melikesayar",    image: UIImage(named: "Pic 10")),
    .init(title: "Lurich Sayar Hello World",    image: UIImage(named: "Pic 11")),
    .init(title: "Han-Chieh Lee",               image: UIImage(named: "Pic 12")),
    .init(title: "Chieh",                       image: UIImage(named: "Pic 13")),
    .init(title: "Abril Altamirano",            image: UIImage(named: "Pic 14")),
    .init(title: "Gülsah Aydogan",              image: UIImage(named: "Pic 15")),
    .init(title: "Melike Sayar Melikesayar",    image: UIImage(named: "Pic 16")),
    .init(title: "Maahid Photos",               image: UIImage(named: "Pic 17")),
    .init(title: "Pelageia Zelenina",           image: UIImage(named: "Pic 18")),
    .init(title: "Ofir Eliav",                  image: UIImage(named: "Pic 19")),
]
