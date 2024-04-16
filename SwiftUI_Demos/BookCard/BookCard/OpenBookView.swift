//
//  OpenBookView.swift
//  BookCard
//
//  Created by Lurich on 2024/4/9.
//

import SwiftUI

struct OpenBookView<Front: View, InsideLeft: View, InsideRight: View>: View, Animatable {
    var config: Config = .init()
    @ViewBuilder var front: (CGSize) -> Front
    @ViewBuilder var insideLeft: (CGSize) -> InsideLeft
    @ViewBuilder var insideRight: (CGSize) -> InsideRight
    
    var animatableData: CGFloat {
        get { return config.progress }
        set { config.progress = newValue }
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let progress = max(min(config.progress, 1.0), 0.0)
            let rotation = progress * -180
            let cornerRadius = config.cornerRadius
            let shadowColor = config.shadowColor
            
            ZStack {
                insideRight(size)
                    .frame(width: size.width, height: size.height)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: cornerRadius,
                            topTrailingRadius: cornerRadius,
                            style: .continuous
                        )
                    )
                    .shadow(color: shadowColor.opacity(0.1 * progress), radius: 5, x: 5, y: 5)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(config.dividerBackground.shadow(.inner(color: shadowColor.opacity(0.15), radius: 2)))
                            .frame(width: 6)
                            .offset(x: -3)
                            .clipped()
                    }
                
                front(size)
                    .frame(width: size.width, height: size.height)
                    .overlay {
                        if -rotation > 90 {
                            insideLeft(size)
                                .frame(width: size.width, height: size.height)
                                .scaleEffect(x: -1)
                                .transition(.identity)
                        }
                    }
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: cornerRadius,
                            topTrailingRadius: cornerRadius,
                            style: .continuous
                        )
                    )
                    .shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 5)
                    .rotation3DEffect(
                        .degrees(rotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.3
                    )
            }
            .offset(x: size.width / 2.0 * progress)
        }
        .frame(width: config.width, height: config.height)
    }
    
    struct Config {
        var width: CGFloat = 150
        var height: CGFloat = 200
        var progress: CGFloat = 0
        var cornerRadius: CGFloat = 10
        var dividerBackground: Color = .white
        var shadowColor: Color = .black
    }
}

#Preview {
    ContentView()
}
