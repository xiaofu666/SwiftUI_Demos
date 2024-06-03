//
//  HomeView.swift
//  VerticalCarousel
//
//  Created by Lurich on 2024/6/3.
//

import SwiftUI

struct HomeView: View {
    @State private var position: CardPosition = .left
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        CardView(card)
                            .frame(width: 220, height: 150)
                            .visualEffect { content, geometryProxy in
                                content
                                    .offset(x: position == .left ? 150 : -150)
                                    .rotationEffect(
                                        .init(degrees: cardRotation(geometryProxy)),
                                        anchor: position == .left ? .leading : .trailing
                                    )
                                    .offset(x: position == .left ? -100 : 100, y: -geometryProxy.frame(in: .scrollView(axis: .vertical)).minY)
                            }
                            .frame(maxWidth: .infinity, alignment: position == .left ? .leading : .trailing)
                    }
                }
                .scrollTargetLayout()

            }
            .safeAreaPadding(.vertical, size.height * 0.5 - 75)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .background() {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: size.height, height: size.height)
                    .offset(x: size.height * (position == .left ? -0.5 : 0.5))
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .overlay(alignment: .bottom) {
            Picker(selection: $position) {
                ForEach(CardPosition.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            } label: {
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 25)
        }
    }
    
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(card.color.gradient)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("VISA")
                    .font(.title3)
                    .fontWeight(.medium)
                    .italic()
                    .foregroundStyle(.white)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 0) {
                    ForEach(1...3, id: \.self) { _ in
                        Text("****")
                        Spacer(minLength: 0)
                    }
                    Text(card.number)
                        .offset(y: -2)
                }
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.bottom, 10)
                
                HStack {
                    Text(card.name)
                    
                    Spacer(minLength: 0)
                    
                    Text(card.date)
                }
                .font(.caption.bold())
                .fontWeight(.regular)
                .foregroundStyle(.white)
            }
            .padding(25)
        }
    }
    
    func cardRotation(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = proxy.size.height
        let progress = minY / height
        let angleForEachCard: CGFloat = position == .left ? 50 : -50
        let cardCount: CGFloat = 3
        let cardProgress = progress < 0 ? (min(max(progress, -cardCount), 0.0)) : (max(min(progress, cardCount), 0.0))
        return cardProgress * angleForEachCard
    }
    
    enum CardPosition: String, CaseIterable {
        case left = "left"
        case right = "right"
    }
}

#Preview {
    ContentView()
}
