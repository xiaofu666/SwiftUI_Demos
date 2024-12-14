//
//  FlipTransitionStyle.swift
//  FlipTransition
//
//  Created by Lurich on 2024/4/17.
//

import SwiftUI

struct FlipTransition: ViewModifier, Animatable {
    var progress: CGFloat = 0
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
            .rotation3DEffect(
                .init(degrees: progress * 180),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                perspective: 0.6
            )
    }
}

extension AnyTransition {
    static let flip: AnyTransition = .modifier(
        active: FlipTransition(progress: 1.0),
        identity: FlipTransition()
    )
    static let reverseFlip: AnyTransition = .modifier(
        active: FlipTransition(progress: -1.0),
        identity: FlipTransition()
    )
}
