//
//  ImageModel.swift
//  BackdropCarousel
//
//  Created by Xiaofu666 on 2025/1/8.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    var image: String
}

let images: [ImageModel] = (0...8).map({ .init(altText: "Test Image \($0)", image: "Profile \($0)") })
