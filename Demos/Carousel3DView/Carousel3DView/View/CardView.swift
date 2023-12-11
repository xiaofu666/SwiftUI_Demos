//
//  CardView.swift
//  Carousel3DView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct CardView: View {
    var card: CardModel
    
    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 220)
                .onTapGesture {
                    print("click")
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
