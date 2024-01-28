//
//  ImageItem.swift
//  ShareSheetExtension
//
//  Created by Lurich on 2024/1/28.
//

import Foundation
import SwiftData

@Model
class ImageItem {
    @Attribute(.externalStorage)
    var data: Data
    init(data: Data) {
        self.data = data
    }
}
