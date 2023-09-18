//
//  Discover.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 29/06/21.
//

import SwiftUI

struct Discover: Decodable {
    let results: [Movie]
    let total_pages: Int
}

struct Movie: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String
    let vote_average: Float
    let genres: [Genre]?
}

struct Genre: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
}
