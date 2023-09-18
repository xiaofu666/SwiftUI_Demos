//
//  MovieViewModel.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 29/06/21.
//

import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movies = [Movie]()
    var page: Int = 1
    var totalPages: Int = 1
    var isFetchingData = false
    @Published var movie: Movie?
    
    func fetchDataIfNeeded(movie: Movie) {
        if movies.last == movie && page <= totalPages && !isFetchingData {
            page += 1
            fetchData()
        }
    }
    
    func fetchData() {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=e6dc8c20ea0d4c49874b8fa5173a1309&page=\(page)")
        
        isFetchingData = true
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            self.isFetchingData = false
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let discover = try JSONDecoder().decode(Discover.self, from: data)
                    self.totalPages = discover.total_pages
                    DispatchQueue.main.async {
                        self.movies += discover.results
                    }
                } catch (let error) {
                    print(error)
                    return
                }
            } else {
                print("error")
                return
            }
        }.resume()
    }
    
    func fetchMovie(movie: Movie) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=e6dc8c20ea0d4c49874b8fa5173a1309")
        
        isFetchingData = true
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            self.isFetchingData = false
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    DispatchQueue.main.async {
                        self.movie = movie
                    }
                } catch (let error) {
                    print(error)
                    return
                }
            } else {
                print("error")
                return
            }
        }.resume()
    }
}
