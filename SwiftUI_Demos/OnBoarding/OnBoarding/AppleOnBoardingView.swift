//
//  AppleOnBoardingView.swift
//  OnBoarding
//
//  Created by Xiaofu666 on 2025/8/16.
//

import SwiftUI

/// On Boarding Card
struct AppleOnBoardingCard: Identifiable {
    var id: String = UUID().uuidString
    var symbol: String
    var title: String
    var subTitle: String
}

/// On Boarding Card Result Builder
@resultBuilder
struct OnBoardingCardResultBuilder {
    static func buildBlock(_ components: AppleOnBoardingCard...) -> [AppleOnBoardingCard] {
        components.compactMap { $0 }
    }
}

struct AppleOnBoardingView<Icon: View, Footer: View>: View {
    var tint: Color
    var title: String
    var icon: Icon
    var cards: [AppleOnBoardingCard]
    var footer: Footer
    var onContinue: () -> ()
    
    init(
        tint: Color,
        title: String,
        icon: @escaping () -> Icon,
        @OnBoardingCardResultBuilder cards: @escaping () -> [AppleOnBoardingCard],
        footer: @escaping () -> Footer,
        onContinue: @escaping () -> Void
    ) {
        self.tint = tint
        self.title = title
        self.icon = icon()
        self.cards = cards()
        self.footer = footer()
        self.onContinue = onContinue
        
        self._animateCards = .init(initialValue: Array(repeating: false, count: self.cards.count))
    }
    
    /// View Properties
    @State private var animateIcon: Bool = false
    @State private var animateTitle: Bool = false
    @State private var animateCards: [Bool]
    @State private var animateFooter: Bool = false

    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    icon
                        .frame(maxWidth: .infinity)
                        .blurSlide(animateIcon)
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .blurSlide(animateTitle)
                    
                    CardsView()
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
            VStack(spacing: 0) {
                footer
                
                // Continue Button
                Button(action: onContinue) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                    #if os(macOS)
                        .padding(.vertical, 8)
                    #else
                        .padding(.vertical, 4)
                    #endif
                }
                .tint(tint)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .blurSlide(animateFooter)
        }
        .frame(maxWidth: 330)
        .interactiveDismissDisabled()
        .allowsHitTesting(animateFooter)
        .task {
            guard !animateIcon else { return }
            
            await delayedAnimation(0.35) {
                animateIcon = true
            }
            
            await delayedAnimation(0.2) {
                animateTitle = true
            }
            
            try? await Task.sleep(for: .seconds(0.2))
            
            for index in animateCards.indices {
                /// YOUR DELAY VALUE HERE
                let delay = Double(index) * 0.1
                await delayedAnimation(delay) {
                    animateCards[index] = true
                }
            }
            
            await delayedAnimation(0.2) {
                animateFooter = true
            }
        }
        .setUpOnBoarding()
    }
    
    @ViewBuilder
    func CardsView() -> some View {
        Group {
            // Index will be used later for animation Effects!
            ForEach(cards.indices, id: \.self) { index in
                let card = cards[index]
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: card.symbol)
                        .font(.title2)
                        .foregroundStyle(tint)
                        .symbolVariant(.fill)
                        .frame(width: 45)
                        .offset(y: 10)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(card.title)
                            .font(.title3)
                            .lineLimit(1)
                        
                        Text(card.subTitle)
                            .lineLimit(2)
                    }
                }
                .blurSlide(animateCards[index])
            }
        }
    }
    
    func delayedAnimation(_ delay: Double, action: @escaping () -> ()) async {
        try? await Task.sleep(for: .seconds(delay))
        
        withAnimation(.smooth) {
            action()
        }
    }
}

extension View {
    /// Custom Blur slide Effect
    @ViewBuilder
    func blurSlide(_ show: Bool) -> some View {
        self
            // Groups the view and adds blur to the grouped view rather than applying blur to each111node view!
            .compositingGroup()
            .blur(radius: show ? 0 : 10)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 100)
    }
    
    @ViewBuilder
    fileprivate func setUpOnBoarding() -> some View {
        #if os(macOS)
        self
            .padding(.horizontal, 20)
            .frame(height: 600)
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            if #available(iOS 18, *) {
                self
                    .presentationSizing(.fitted)
                    .padding(.horizontal, 25)
            } else {
                self
            }
        } else {
            self
        }
        #endif
    }
}

#Preview {
    ContentView()
}
