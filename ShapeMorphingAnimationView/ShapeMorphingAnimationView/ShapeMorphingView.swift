//
//  ShapeMorphingView.swift
//  ShapeMorphingAnimationView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct ShapeMorphingView: View {
    var systemImage: String
    var fontSize: CGFloat
    var color: Color = .white
    var duration: CGFloat = 0.5
    
    @State private var newImage: String = ""
    @State private var radius: CGFloat = 0
    @State private var animatedRadiusValue: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, color: color))
                context.addFilter(.blur(radius: animatedRadiusValue))
                context.drawLayer { context2 in
                    if let resolvedImageView = context.resolveSymbol(id: 0) {
                        context2.draw(resolvedImageView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
            } symbols: {
                ImageView(size: size)
                    .tag(0)
                    .id(0)
            }
        }
        .onAppear() {
            if newImage.isEmpty {
                newImage = systemImage
            }
        }
        .onChange(of: systemImage) { newValue in
            if newValue.count > 0 {
                newImage = newValue
            }
            withAnimation(.linear(duration: duration).speed(2)) {
                radius = 12
            }
        }
        .animationProgress(endValue: radius) { value in
            animatedRadiusValue = value
            
            if value >= 6 {
                withAnimation(.linear(duration: duration).speed(2)) {
                    radius = 0
                }
            }
        }
    }
    
    @ViewBuilder
    func ImageView(size: CGSize) -> some View {
        if !newImage.isEmpty {
            Image(systemName: newImage)
                .font(.system(size: fontSize))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: newImage)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.9), value: fontSize)
                .frame(width: size.width, height: size.height)
        }
    }
}

struct ShapeMorphingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    @ViewBuilder
    func animationProgress<Value: VectorArithmetic>(endValue: Value, progress: @escaping (Value) -> ()) -> some View {
        self.modifier(AnimationProgress(endValue: endValue, onChange: progress))
    }
}
struct AnimationProgress<Value: VectorArithmetic>: ViewModifier, Animatable {
    var animatableData: Value {
        didSet {
            sendProgress()
        }
    }
    var endValue: Value
    var onChange: (Value) -> ()
    
    init(endValue: Value, onChange: @escaping (Value) -> Void) {
        self.animatableData = endValue
        self.endValue = endValue
        self.onChange = onChange
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    func sendProgress() {
        DispatchQueue.main.async {
            onChange(animatableData)
        }
    }
}

