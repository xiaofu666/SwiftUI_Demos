//
//  BoomerangCardsView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/18.
//

import SwiftUI

@available(iOS 15.0, *)
struct BoomerangCardsView: View {
    @State var cards: [CardModel] = []
    @State var isBlurEnabled: Bool = false
    @State var isRotationEnabled: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Enable Blue", isOn: $isBlurEnabled)
            
            Toggle("Rutn On Rotation", isOn: $isRotationEnabled)
            
            Spacer()
            
            BoomerangCard(isBlurEnabled: isBlurEnabled, isRotationEnabled: isRotationEnabled, cards: $cards)
                .frame(height: 220)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(15)
        .background {
            colorScheme == .dark ? Color.black : Color.white
        }
//        .preferredColorScheme(.dark)
        .onAppear(perform: setupCards)
    }
    
    func setupCards() {
        for index in 1...6 {
            cards.append(CardModel(imageName: "user\(index)"))
        }
        
        if var first = cards.first {
            first.id  = UUID().uuidString
            cards.append(first)
        }
    }
}

@available(iOS 15.0, *)
struct BoomerangCardsView_Previews: PreviewProvider {
    static var previews: some View {
        BoomerangCardsView()
    }
}

@available(iOS 15.0, *)
struct BoomerangCard: View {
    var isBlurEnabled: Bool = false
    var isRotationEnabled: Bool = false
    @Binding var cards: [CardModel]
    
    @State var offset: CGFloat = 0
    @State var currendIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                ForEach(cards.reversed()) { card in
                    let index = indexOf(card: card)
                    Image(card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .blur(radius: card.isRotaed && isBlurEnabled ? 6.5 : 0)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .scaleEffect(card.scale, anchor: card.isRotaed ? .center : .top)
                        .rotation3DEffect(.init(degrees: isRotationEnabled && card.isRotaed ? 360 : 0), axis: (x: 0, y: 0, z: 1))
                        .offset(y: -offsetFor(index: index))
                        .offset(y: card.extraOffset)
                        .scaleEffect(scaleFor(index: index), anchor: .top)
                        .zIndex(card.zIndex)
                        .offset(y: currendIndex == index ? offset : 0)
                }
            }
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: offset == .zero)
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged(onChange(value:))
                    .onEnded(onEnd(value:))
            )
        }
    }
    
    func onChange(value: DragGesture.Value) {
        offset = currendIndex == cards.count - 1 ? 0 : value.translation.height
    }
    
    func onEnd(value: DragGesture.Value) {
        var translation = value.translation.height
        translation = translation < 0 ? -translation : 0
        translation = currendIndex == cards.count - 1 ? 0 : translation
        if translation > 110 {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                cards[currendIndex].isRotaed = true
                cards[currendIndex].extraOffset = -350
                cards[currendIndex].scale = 0.7
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    cards[currendIndex].zIndex = -100
                    for index in cards.indices {
                        cards[index].extraOffset = 0
                    }
                    if currendIndex != cards.count - 1 {
                        currendIndex += 1
                    }
                    offset = .zero
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for index in cards.indices {
                    if index == currendIndex {
                        if cards.indices.contains(currendIndex - 1) {
                            cards[currendIndex - 1].zIndex = zIndexOf(card: cards[currendIndex - 1])
                        }
                    } else {
                        cards[index].isRotaed = false
                        withAnimation(.linear) {
                            cards[index].scale = 1
                        }
                    }
                }
                
                if currendIndex == cards.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        for index in cards.indices {
                            cards[index].zIndex = 0
                        }
                        
                        currendIndex = 0
                    }
                }
            }
        } else {
            offset = .zero
        }
    }
    
    func zIndexOf(card: CardModel) -> Double {
        let index = indexOf(card: card)
        let total = cards.count
        return currendIndex > index ? Double(index - total) : cards[index].zIndex
    }
    
    func scaleFor(index: Int) -> Double {
        let value = Double(index - currendIndex)
        if value > 0 {
            if value > 3 {
                return 0.8
            }
            return 1 - (value / 15)
        } else {
            if -value > 3 {
                return 0.8
            }
            return 1 + (value / 15)
        }
    }
    
    func offsetFor(index: Int) -> Double {
        let value = Double(index - currendIndex)
        if value > 0 {
            if value > 3 {
                return 30
            }
            return value * 10
        } else {
            if -value > 3 {
                return 30
            }
            return -value * 10
        }
    }
    
    func indexOf(card: CardModel) -> Int {
        return cards.firstIndex { cardModel in
            cardModel.id == card.id
        } ?? 0
    }
}
