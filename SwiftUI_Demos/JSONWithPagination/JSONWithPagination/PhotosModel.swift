//
//  PhotosModel.swift
//  JSONWithPagination
//
//  Created by Lurich on 2024/3/22.
//

import SwiftUI

// https://picsum.photos

struct PhotosModel: Identifiable, Codable, Hashable {
    var id: String
    var author: String
    var url: String
    private var downloadURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case url
        case downloadURLString = "download_url"
    }
    
    var downloadURL: URL? {
        return URL(string: downloadURLString)
    }
    
    var imageURL: URL? {
        return URL(string: "https://picsum.photos/id/\(id)/256/256.jpg")
    }
}
