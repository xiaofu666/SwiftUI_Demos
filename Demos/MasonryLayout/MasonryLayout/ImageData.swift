//
//  ImageData.swift
//  Masonary
//
//  Created by Lurich on 2024/3/10.
//

import SwiftUI

struct ImageData: Decodable, Hashable {
    var url: String
    var name: String
    
    static var sample: [ImageData] {
        guard let filePath = Bundle.main.path(forResource: "images", ofType: "json") else { return [] }
        let dataURL = URL(filePath: filePath)
        do {
            let data = try Data(contentsOf: dataURL)
            let images: [ImageData] = try JSONDecoder().decode([ImageData].self, from: data)
            return images
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
