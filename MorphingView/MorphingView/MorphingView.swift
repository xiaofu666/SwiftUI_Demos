//
//  MorphingView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/5/15.
//

import SwiftUI

@available(iOS 16.0, *)
struct MorphingView: View {
    @State var currentImage: CustomCanvasShape = .cloud
    @State var pickerImage: CustomCanvasShape = .cloud
    @State private var turnOffImageMorph: Bool = false
    @State private var blurRadius: CGFloat = 0
    @State private var animateMorph: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .overlay(content: {
                        Rectangle()
                            .fill(.white)
                            .opacity(turnOffImageMorph ? 1 : 0)
                    })
                    .mask {
                        Canvas { context, size in
                            context.addFilter(.alphaThreshold(min: 0.3))
                            context.addFilter(.blur(radius: blurRadius >= 20 ? 20 - (blurRadius - 20) : 0))
                            
                            context.drawLayer { context2 in
                                if let resolvedImage = context.resolveSymbol(id: 1) {
                                    context2.draw(resolvedImage, at: CGPoint(x: size.width / 2.0, y: size.height / 2.0), anchor: .center)
                                }
                            }
                        } symbols: {
                            ResolvedImage(currentImage: $currentImage)
                                .tag(1)
                        }
                        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
                            if animateMorph {
                                if blurRadius <= 40 {
                                    blurRadius += 0.5
                                    if blurRadius.rounded() == 20 {
                                        currentImage = pickerImage
                                    }
                                }
                                if blurRadius == 40 {
                                    animateMorph = false
                                    blurRadius = 0
                                }
                            }
                        }
                    }
            }
            .frame(height: 400)
            
            Picker("", selection: $pickerImage) {
                ForEach(CustomCanvasShape.allCases, id:\.rawValue) { shape in
                    Image(systemName: shape.rawValue)
                        .tag(shape)
                }
            }
            .pickerStyle(.segmented)
            .overlay(content: {
                Rectangle()
                    .fill(.primary)
                    .opacity(animateMorph ? 0.05 : 0)
            })
            .padding(15)
            .onChange(of: pickerImage) { newValue in
                animateMorph = true
            }
            
            Toggle("Turn Of Image Morph", isOn: $turnOffImageMorph)
                .fontWeight(.semibold)
                .padding(.horizontal, 15)
                .padding(.top, 10)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(.dark)
    }
}

struct ResolvedImage: View {
    @Binding var currentImage: CustomCanvasShape
    var body: some View {
        Image(systemName: currentImage.rawValue)
            .font(.system(size: 200))
            .animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8), value: currentImage)
            .frame(width: 300, height: 300)
    }
}

@available(iOS 16.0, *)
struct MorphingView_Previews: PreviewProvider {
    static var previews: some View {
        MorphingView()
    }
}

enum CustomCanvasShape: String, CaseIterable {
    case cloud = "cloud.rain.fill"
    case bubble = "bubble.left.and.bubble.right.fill"
    case map = "map.fill"
    case square = "square.fill.on.square.fill"
    case bell = "bell.and.waves.left.and.right.fill"
    case circle = "square.fill.on.circle.fill"
}
