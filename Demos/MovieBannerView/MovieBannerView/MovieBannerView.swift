//
//  MovieBannerView.swift
//  MovieBannerView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct MovieBannerView: View {
    
    // current index
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        ZStack {
            TabView(selection: $currentIndex) {
                
                ForEach(posts.indices, id: \.self) { index in
                    
                    GeometryReader { proxy in
                        
                        Image(posts[index].imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .cornerRadius(1)
                    }
                    .ignoresSafeArea()
                    .offset(y: -100)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)
            .overlay(
                
                LinearGradient(colors: [
                
                    Color.clear,
                    Color.black.opacity(0.2),
                    Color.white.opacity(0.4),
                    Color.white,
                    Color.white,
                    Color.white,
                ], startPoint: .top, endPoint: .bottom)
            )
            .ignoresSafeArea()
            
            //posts..
            SnapCarousel(trailingSpace: getScreenRect().height < 750 ? 100 : 150 ,index: $currentIndex, items: posts, isOffset: true) { post in
                
                CardView(post: post)
                
            }
            .offset(y: getScreenRect().height / 4)
        }
        
    }
    
    @ViewBuilder
    func CardView(post: Post) -> some View {
        
        VStack(spacing: 10) {
            
            GeometryReader { proxy in
                
                Image(post.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .cornerRadius(25)
            }
            .padding(15)
            .background(Color.white)
            .cornerRadius(25)
            .frame(height: getScreenRect().height / 2.5)
            .padding(.bottom, 15)
            
            Text(post.title)
                .font(.title2.bold())
            
            HStack(spacing: 3) {
                
                ForEach(1...5, id: \.self) { index in
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= post.starRating ? .yellow : .gray)
                }
                
                Text("(\(post.starRating).0)")
            }
            .font(.caption)
            
            Text(post.description)
                .font(.callout)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.top , 8)
                .padding(.horizontal)
        }
    }
    
}


struct MovieBannerView_Previews: PreviewProvider {
    static var previews: some View {
        MovieBannerView()
    }
}
