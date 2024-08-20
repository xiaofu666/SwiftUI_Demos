//
//  MorphingSymbolView.swift
//  Walkthrough+Morphing
//
//  Created by Xiaofu666 on 2024/7/29.
//

import SwiftUI

struct MorphingSymbolView: View {
    var symbol: String
    var config: Config
    
    @State private var trigger: Bool = false
    @State private var displaySymbol: String?
    @State private var nextSymbol: String?
    
    var body: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.4, color: config.foregroundColor))
            
            if let resolveImage = context.resolveSymbol(id: 1) {
                context.draw(resolveImage, at: .init(x: size.width / 2, y: size.height / 2))
            }
        } symbols: {
            ImageView()
                .tag(1)
        }
        .frame(width: config.frame.width, height: config.frame.height)
        .onChange(of: symbol) { oldValue, newValue in
            trigger.toggle()
            nextSymbol = newValue
        }
        .task {
            guard displaySymbol == nil else { return }
            displaySymbol = symbol
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        KeyframeAnimator(initialValue: CGFloat.zero, trigger: trigger) { radius in
            Image(systemName: displaySymbol ?? symbol)
                .font(config.font)
                .blur(radius: radius)
                .frame(width: config.frame.width, height: config.frame.height)
                .onChange(of: radius) { oldValue, newValue in
                    if newValue.rounded() == config.radius {
                        withAnimation(config.symbolAnimation) {
                            displaySymbol = nextSymbol
                        }
                    }
                }
        } keyframes: { _ in
            CubicKeyframe(config.radius, duration: config.keyFrameDuration)
            CubicKeyframe(0, duration: config.keyFrameDuration)
        }

    }
}

struct Config {
    var font: Font
    var frame: CGSize
    var radius: CGFloat
    var foregroundColor: Color
    var keyFrameDuration: CGFloat
    var symbolAnimation: Animation
    
    init(font: Font, frame: CGSize, radius: CGFloat, foregroundColor: Color, keyFrameDuration: CGFloat = 0.4, symbolAnimation: Animation = .snappy(duration: 0.5)) {
        self.font = font
        self.frame = frame
        self.radius = radius
        self.foregroundColor = foregroundColor
        self.keyFrameDuration = keyFrameDuration
        self.symbolAnimation = symbolAnimation
    }
}

#Preview {
    MorphingSymbolView(symbol: "gearshape.fill", config: .init(font: .system(size: 100), frame: .init(width: 100, height: 100), radius: 20, foregroundColor: .black))
}
