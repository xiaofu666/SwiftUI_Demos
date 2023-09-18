//
//  DetailsView.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 09/07/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct DetailsView: View {
    var movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.presentationMode) var presentation
    @State var yOffset: CGFloat = 30
    @State var opacity: Double = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ZStack(alignment: .top) {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        
                    }
                    
                    HStack {
                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .clipShape(Circle())
                                .foregroundColor(Color.primary)
                        })
                        
                        Spacer()
                    }
                    .padding()
                    .padding(.top, UIApplication.shared.keyWindow?.safeAreaInsets.top)
                }
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(movie.title)
                        .font(.largeTitle)
                    
                    RatingView(rating: movie.vote_average)
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    ForEach(viewModel.movie?.genres ?? Array.init(repeating: Genre(id: 0, name: "Loading..."), count: 3)) { genre in
                        Text(genre.name)
                            .redacted(reason: viewModel.movie != nil ? .init() : .placeholder)
                        
                        if viewModel.movie?.genres?.last != genre {
                            Circle()
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    Spacer()
                }
                
                Text(movie.overview ?? "")
                
                Button(action: {}, label: {
                    HStack {
                        Image(systemName: "play.fill")
                        
                        Text("Play Trailer")
                    }
                    .foregroundColor(Color.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.primary, lineWidth: 1))
                    .padding(.top)
                })
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            }
            .padding()
            .background(RoundedCorners(corners: [.topLeft, .topRight], radius: 30).fill(Color.white).shadow(radius: 5))
            .offset(y: yOffset)
            .opacity(opacity)
            .animation(.spring(), value: opacity)
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation {
                        yOffset = 0
                        opacity = 1
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            viewModel.fetchMovie(movie: movie)
        }
    }
}

/*
 {
 adult = 0;
 "backdrop_path" = "/620hnMVLu6RSZW6a5rwO8gqpt0t.jpg";
 "belongs_to_collection" = "<null>";
 budget = 0;
 genres =     (
 {
 id = 16;
 name = Animation;
 },
 {
 id = 35;
 name = Comedy;
 },
 {
 id = 10751;
 name = Family;
 },
 {
 id = 14;
 name = Fantasy;
 }
 );
 homepage = "https://www.disneyplus.com/movies/luca/7K1HyQ6Hl16P";
 id = 508943;
 "imdb_id" = tt12801262;
 "original_language" = en;
 "original_title" = Luca;
 overview = "Luca and his best friend Alberto experience an unforgettable summer on the Italian Riviera. But all the fun is threatened by a deeply-held secret: they are sea monsters from another world just below the water\U2019s surface.";
 popularity = "4176.6";
 "poster_path" = "/jTswp6KyDYKtvC52GbHagrZbGvD.jpg";
 "production_companies" =     (
 {
 id = 2;
 "logo_path" = "/wdrCwmRnLFJhEoH8GSfymY85KHT.png";
 name = "Walt Disney Pictures";
 "origin_country" = US;
 },
 {
 id = 3;
 "logo_path" = "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png";
 name = Pixar;
 "origin_country" = US;
 }
 );
 "production_countries" =     (
 {
 "iso_3166_1" = US;
 name = "United States of America";
 }
 );
 "release_date" = "2021-06-17";
 revenue = 11600000;
 runtime = 95;
 "spoken_languages" =     (
 {
 "english_name" = English;
 "iso_639_1" = en;
 name = English;
 },
 {
 "english_name" = Italian;
 "iso_639_1" = it;
 name = Italiano;
 }
 );
 status = Released;
 tagline = "";
 title = Luca;
 video = 0;
 "vote_average" = "8.1";
 "vote_count" = 2357;
 }
 */

@available(iOS 15.0, *)
struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(movie: Movie(id: 508943, title: "Luca", overview: "Luca and his best friend Alberto experience an unforgettable summer on the Italian Riviera. But all the fun is threatened by a deeply-held secret: they are sea monsters from another world just below the waters surface.", poster_path: "/jTswp6KyDYKtvC52GbHagrZbGvD.jpg", vote_average: 0.3, genres: nil), viewModel: MovieViewModel())
    }
}
