//
//  Carousel3D.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/11.
//

import SwiftUI

struct Carousel3D: View {
    @State var cards: [CardModel] = []
    var body: some View {
        VStack {
            ShowView(cardSize: CGSize(width: 150, height: 220), items: cards, id: \.id, content: { card in
                CardView(card: card)
            })
            .padding(.bottom, 100)
            
            HStack{
                Button {
                    if cards.count != 6 {
                        cards.append(.init(imageName: "user\(cards.count + 1)"))
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                
                Button {
                    cards.removeLast()
                } label: {
                    Label("Delete", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
            }
        }
        .onAppear() {
            for index in 1...6 {
                cards.append(.init(imageName: "user\(index)"))
            }
        }
    }
}

struct Carousel3D_Previews: PreviewProvider {
    static var previews: some View {
        Carousel3D()
    }
}
