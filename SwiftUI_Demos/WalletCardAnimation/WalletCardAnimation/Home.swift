//
//  Home.swift
//  WalletCardAnimation
//
//  Created by Xiaofu666 on 2024/12/9.
//

import SwiftUI

struct Home: View {
    let size: CGSize
    let safeArea: EdgeInsets
    @State private var showDetailView: Bool = false
    @State private var selectedCard: Card?
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                Text("My Wallet")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        Button {
                            
                        } label: {
                            Image(.pic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipShape(.circle)
                        }
                    }
                    .blur(radius: showDetailView ? 5 : 0)
                    .opacity(showDetailView ? 0 : 1)
                
                let mainOffset = CGFloat(cards.firstIndex(where: { $0.id == selectedCard?.id }) ?? 0) * -size.width
                LazyVStack(spacing: 10) {
                    ForEach(cards) { card in
                        let cardOffset: CGFloat = CGFloat(cards.firstIndex(where: { $0.id == card.id }) ?? 0) * size.width
                        CardView(card)
                            .frame(width: showDetailView ? size.width : nil)
                            .visualEffect { [showDetailView] content, proxy in
                                content
                                    .offset(x: showDetailView ? cardOffset : 0, y: showDetailView ? -proxy.frame(in: .scrollView).minY : 0)
                            }
                    }
                }
                .padding(.top, 25)
                .offset(x: showDetailView ? mainOffset : 0)
            }
            .safeAreaPadding(15)
            .safeAreaPadding(.top, safeArea.top)
            .overlay {
                if let selectedCard, showDetailView {
                    DetailView(selectedCard: selectedCard)
                        .padding(.top, expandedCardHeight)
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
    
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        ZStack {
            Rectangle()
                .fill(card.color.gradient)
            
            VStack(alignment: .leading, spacing: 15) {
                if !showDetailView {
                    VisaImageView(card.visaGeometryID, height: 20)
                        .font(.largeTitle.bold())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.number)
                        .font(.caption)
                        .foregroundStyle(.white.secondary)
                    
                    Text("$9999.99")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: showDetailView ? .center : .leading)
                .overlay {
                    ZStack {
                        if showDetailView {
                            VisaImageView(card.visaGeometryID, height: 10)
                                .font(.body.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 40)
                        }
                        
                        if let selectedCard, selectedCard.id == card.id, showDetailView {
                            Button {
                                withAnimation(.smooth(duration: 0.5)) {
                                    self.selectedCard = nil
                                    showDetailView = false
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .contentShape(.rect)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.asymmetric(insertion: .opacity, removal: .identity))
                        }
                    }
                }
                .padding(.top, showDetailView ? safeArea.top - 10 : 0)
                
                HStack {
                    Text("Expires: \(card.expires)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("LURICH")
                        .font(.callout)
                    
                }
                .foregroundStyle(.white.secondary)
            }
            .padding(showDetailView ? 15 : 25)
        }
        .frame(height: showDetailView ? expandedCardHeight : nil)
        .frame(height: 200, alignment: .top)
        .clipShape(.rect(cornerRadius: showDetailView ? 0 : 25))
        .onTapGesture {
            guard !showDetailView else { return }
            withAnimation(.smooth(duration: 0.5)) {
                selectedCard = card
                showDetailView = true
            }
        }
        .scrollDisabled(showDetailView)
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func VisaImageView(_ id: String, height: CGFloat) -> some View {
        Text("VISA")
            .foregroundStyle(.white)
            .matchedGeometryEffect(id: id, in: animation)
            .frame(height: height)
    }
    
    var expandedCardHeight: CGFloat {
        safeArea.top + 130
    }
}

struct DetailView: View {
    var selectedCard: Card
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12) {
                ForEach(1...20, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(selectedCard.color.opacity(0.5).gradient)
                        .frame(height: 45)
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    ContentView()
}
