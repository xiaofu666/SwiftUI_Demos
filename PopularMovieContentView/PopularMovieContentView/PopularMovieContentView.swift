//
//  ContentView.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 29/06/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct PopularMovieContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        
        ZStack {
            if viewModel.movies.count > 0 {
                MoviesListView(movies: viewModel.movies, viewModel: viewModel)
            } else {
                LoadingView()
            }
        }
        .navigationTitle("Popular Movies")
        .onAppear {
            viewModel.fetchData()
        }
    }
}

@available(iOS 15.0, *)
struct MovieView: View {
    var movie: Movie
    
    var body: some View {
        HStack(spacing: 15) {
            SFImageView(URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"))
                .frame(width: 120)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(movie.overview ?? "")
                    .lineLimit(4)
                    .foregroundColor(.gray)
                
                Spacer()
                
                RatingView(rating: movie.vote_average)
            }
        }
    }
}

struct RatingView: View {
    var rating: Float
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(.orange)
            
            Text(String(format: "%.1f", rating))
                .fontWeight(.medium)
        }
    }
}

@available(iOS 15.0, *)
struct MoviesListView: View {
    var movies: [Movie]
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                NavigationLink(
                    destination: DetailsView(movie: movie, viewModel: viewModel),
                    label: {
                        MovieView(movie: movie)
                            .padding(.vertical)
                            .onAppear {
                                viewModel.fetchDataIfNeeded(movie: movie)
                            }
                    })
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct LoadingView: View {
    var body: some View {
        Text("Fetching data...")
            .foregroundColor(.gray)
    }
}

@available(iOS 15.0, *)
struct PopularMovieContentView_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovieContentView()
    }
}
