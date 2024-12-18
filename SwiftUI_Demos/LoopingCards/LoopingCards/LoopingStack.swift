//
//  LoopingStack.swift
//  LoopingCards
//
//  Created by Xiaofu666 on 2024/12/18.
//

import SwiftUI

struct LoopingStack<Content: View>: View {
    var visibleCardsCount: Int = 2
    var maxTranslationWidth: CGFloat?
    @ViewBuilder var content: Content
    @State private var rotation: Int = 0
    
    var body: some View {
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count
            
            ZStack {
                ForEach(collection) { view in
                    let index = collection.index(view)
                    let zIndex = Double(count - index)
                    
                    LoopingStackCardView(
                        index: index,
                        count: count,
                        visibleCardsCount: visibleCardsCount,
                        maxTranslationWidth: maxTranslationWidth,
                        rotation: $rotation
                    ) {
                        view
                    }
                    .zIndex(zIndex)
                }
            }
        }
    }
}

extension SubviewsCollection {
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        guard !self.isEmpty else { return [] }
        let moveIndex = by % count
        let rotatedElements = Array(self[moveIndex...]) + Array(self[0..<moveIndex])
        return rotatedElements
    }
}
extension [SubviewsCollection.Element] {
    func index(_ item: SubviewsCollection.Element) -> Int {
        firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

struct LoopingStackCardView<Content: View>: View {
    var index: Int
    var count: Int
    var visibleCardsCount: Int
    var maxTranslationWidth: CGFloat?
    @Binding var rotation: Int
    @ViewBuilder var content: Content
    @State private var offset: CGFloat = .zero
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        let extraOffset = max(min(CGFloat(index) * 20, CGFloat(visibleCardsCount) * 20), 0.0)
        let scale = 1 - max(min(CGFloat(index) * 0.07, CGFloat(visibleCardsCount) * 0.07), 0.0)
        let rotationDegree: CGFloat = -30
        let rotation = max(min(-offset / viewSize.width, 1.0), 0.0) * rotationDegree
        
        content
            .onGeometryChange(for: CGSize.self, of: { proxy in
                proxy.size
            }, action: { newValue in
                viewSize = newValue
            })
            .offset(x: extraOffset)
            .scaleEffect(scale)
            .animation(.smooth(duration: 0.25), value: index)
            .offset(x: offset)
            .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let xOffset = -max(-value.translation.width, 0)
                        if let maxTranslationWidth {
                            let progress = -max(min(-xOffset / maxTranslationWidth, 1.0), 0.0) * viewSize.width
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                    }
                    .onEnded { value in
                        let xVelocity = max(-value.velocity.width / 5, 0)
                        if (-offset + xVelocity) > (viewSize.width * 0.65) {
                            pushToNextCard()
                        } else {
                            withAnimation(.smooth(duration: 0)) {
                                offset = .zero
                            }
                        }
                    },
                isEnabled: index == 0 && count > 1
            )
    }
    
    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.25).logicallyComplete(after: 0.15), completionCriteria: .logicallyComplete) {
            offset = -viewSize.width
        } completion: {
            rotation += 1
            withAnimation(.smooth(duration: 0.25)) {
                offset = 0
            }
        }

    }
}

#Preview {
    ContentView()
}
