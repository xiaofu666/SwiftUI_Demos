//
//  ParallaxCarouselView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/8/15.
//

import SwiftUI

struct ParallaxCarouselView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15, content: {
                HStack(spacing: 12, content: {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundStyle(.blue)
                    })
                    
                    HStack(spacing: 12, content: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        
                        TextField("Search", text: $searchText)
                    })
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: .capsule)
                })
                
                Text("Where do you want to \ntravel?")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    ScrollView(.horizontal) {
                        HStack(spacing: 5, content: {
                            ForEach(tripCards) { card in
                                GeometryReader(content: { proxy in
                                    let cardSize = proxy.size
                                    let minX = proxy.frame(in: .scrollView).minX - 30.0
//                                    let minX = min((proxy.frame(in: .scrollView).minX - 30) * 1.4, proxy.size.width * 1.4)
                                    
                                    Image(card.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x: -minX)
                                        // 放大式
//                                        .scaleEffect(1.25)
                                        // 宽度变长式
//                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay(content: {
                                            OverlayView(card)
                                        })
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                })
                                .frame(width: size.width - 60, height: size.height - 50)
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view.scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        })
                        .padding(.horizontal, 30)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                })
                .frame(height: 500)
                .padding(.horizontal, -15)
                .padding(.top, 10)
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func OverlayView(_ card: TripCard) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black,
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
    }
}

#Preview {
    ParallaxCarouselView()
}

// Trip Card Model
struct TripCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}
var tripCards: [TripCard] = [
    .init(title: "London",   subTitle: "England",        image: "user1"),
    .init(title: "New York", subTitle: "USA",            image: "user2"),
    .init(title: "Prague",   subTitle: "Czech Republic", image: "user3")
]
