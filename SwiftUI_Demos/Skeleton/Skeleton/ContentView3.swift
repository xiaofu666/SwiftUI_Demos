//
//  ContentView3.swift
//  Skeleton
//
//  Created by Xiaofu666 on 2025/4/14.
//

import SwiftUI

struct ContentView3: View {
    @State private var card: Card?
    var body: some View {
        VStack {
            if let card {
                CardView(card: card)
            } else {
                CardView(card: .mock)
                    .skeleton(isRedacted: true)
            }
            
            Spacer(minLength: 0)
        }
        .onTapGesture {
            withAnimation(.smooth) {
                card = .cardData
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

/// Card View
struct CardView: View {
    var card: Card
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 400)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(card.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .padding(.trailing, 30)
                
                Text(card.description)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .lineLimit(3)
            }
            .padding([.horizontal, .top], 15)
            .padding(.bottom, 25)
        }
        .background(.background)
        .clipShape(.rect(cornerRadius:15))
        .shadow(color:.black.opacity(0.1), radius: 10)
    }
}

#Preview {
    ContentView3()
}
