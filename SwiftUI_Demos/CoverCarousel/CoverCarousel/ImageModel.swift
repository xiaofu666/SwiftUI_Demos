//
//  ImageModel.swift
//  CoverCarousel
//
//  Created by Xiaofu666 on 2024/7/24.
//

import SwiftUI

struct ImageModel:Identifiable{
    var id: UUID = .init()
    var image: String
}

var images: [ImageModel] = (1...8).compactMap({ ImageModel(image: "Profile \($0)")})
