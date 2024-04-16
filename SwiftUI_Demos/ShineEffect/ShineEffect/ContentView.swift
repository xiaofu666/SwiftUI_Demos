//
//  ContentView.swift
//  ShineEffect
//
//  Created by Lurich on 2023/11/29.
//

import SwiftUI

struct ContentView: View {
    @State private var shineButton: Bool = false
    @State private var shine: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Shine Button", systemImage: "square.and.arrow.up.circle.fill") {
                    shineButton.toggle()
                }
                .buttonStyle(.borderedProminent)
                .shine(shineButton, duration: 1.0, clipShape: .capsule)
                
                Image(.pic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .shine(shine, duration: 0.8, clipShape: RoundedRectangle(cornerRadius: 15), x: 1.0, y: 1.0)
                    .contentShape(.rect)
                    .onTapGesture {
                        shine.toggle()
                    }
            }
            .navigationTitle("Shine Effect")
        }
    }
}

extension View {
    @ViewBuilder
    func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, x: CGFloat = 1.0, y: CGFloat = 1.0) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let moddedDuration = max(0.3, duration)
                    Rectangle()
                        .fill(.linearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.5),
                                .white.opacity(1),
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                        .scaleEffect(y: 8)
                        .keyframeAnimator(initialValue: 0.0, trigger: toggle, content: { content, progress in
                            content
                                .offset(x: -size.width + progress * size.width * 2)
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .rotationEffect(.init(degrees: 45))
                        .scaleEffect(x: x, y: y)
                }
            }
            .clipShape(clipShape)
    }
}

#Preview {
    ContentView()
}
