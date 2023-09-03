//
//  MaterialCarouselView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/1.
//

import SwiftUI

struct MaterialCarouselView: View {
    @State private var cards: [CardModel] = [
        .init(image: "user1"),
        .init(image: "user2"),
        .init(image: "user3"),
        .init(image: "user4"),
        .init(image: "user5"),
        .init(image: "user6")
    ]
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(cards) { card in
                            CardView(card)
                        }
                    }
                    .padding(.trailing, geometry.size.width - 180)
                    .scrollTargetLayout()
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .clipShape(.rect(cornerRadius: 25))
        })
        .padding(.horizontal, 15)
        .padding(.top, 30)
        .frame(height: 200)
        .navigationTitle("Carousel")
        
        Spacer()
    }
    
    @ViewBuilder
    func CardView(_ card: CardModel) -> some View {
        let spaceWidth: CGFloat = 130
        GeometryReader { proxy in
            let size = proxy.size
            let minX = proxy.frame(in: .scrollView).minX
            let reducingWidth = (minX / 190) * spaceWidth
            let cappedWidth = min(reducingWidth, spaceWidth)
            let frameWidth = size.width - (minX > 0 ? cappedWidth : -cappedWidth)
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .frame(width: frameWidth < 0 ? 0 : frameWidth)
                .clipShape(.rect(cornerRadius: 25))
                .offset(x: minX > 0 ? 0 : -cappedWidth)
                .offset(x: -card.previousOffset)
        }
        .frame(width: 180, height: 200)
        .offsetX { minX in
            let reducingWidth = (minX / 190) * spaceWidth
            let index = cards.indexOf(card)
            
            if cards.indices.contains(index + 1) {
                cards[index + 1].previousOffset = minX < 0 ? 0 : reducingWidth
            }
        }
    }
}

struct MaterialCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MaterialCarouselView()
        }
    }
}
