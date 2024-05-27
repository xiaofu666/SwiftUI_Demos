//
//  Home.swift
//  StackedCardsView
//
//  Created by Lurich on 2024/5/27.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            StackedCards(
                items: items,
                stackedDisplayCount: 3,
                opacityDisplayCount: 2,
                spacing: 8,
                itemHeight: 70
            ) { item in
                CardView(item)
            }
            
            BottomActionsBar()
        }
        .padding(20)
    }
    
    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        if item.logo.isEmpty {
            RoundedRectangle(cornerRadius: 20)
                .fill(.clear)
        } else {
            HStack(spacing: 12) {
                Image(item.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
                
                VStack(alignment: .leading, spacing: 4, content: {
                    Text(item.title)
                        .font(.callout)
                        .fontWeight(.bold)
                    
                    Text(item.description)
                        .font(.caption)
                        .lineLimit(1)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .frame(maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
        }
    }
    
    @ViewBuilder
    func BottomActionsBar() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "flashlight.off.fill")
                    .font(.title3)
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .buttonBorderShape(.circle)
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "camera.fill")
                    .font(.title3)
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.2))
            .buttonBorderShape(.circle)
        }
    }
}

#Preview {
    ContentView()
}
