//
//  BallAnimationView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/13.
//

import SwiftUI

@available(iOS 15.0, *)
struct BallAnimationView: View {
    @State private var drawOffset: CGSize = .zero
    @State private var startAnimation: Bool = false
    
    @State private var type: String = "Single"
    var body: some View {
        VStack {
            Text("Metaball Animation")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
            
            Picker(selection: $type) {
                Text("Metaball")
                    .tag("Single")
                
                Text("Clubbed")
                    .tag("Clubbed")
            } label: {
                
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 15)
            
            if type == "Single" {
                SingleMetaBall()
            } else {
                ClubbedView()
            }
        }
    }
    
    @ViewBuilder
    func ClubbedView() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom))
            .mask {
                TimelineView(AnimationTimelineSchedule(minimumInterval: 3.5, paused: false)) { _ in
                    Canvas { content, size in
                        content.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
                        
                        content.addFilter(.blur(radius: 30))
                        
                        content.drawLayer { ctx in
                            for index in 1...15 {
                                if let resolvedView = content.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                }
                            }
                        }
                    } symbols: {
                        ForEach(1...15, id: \.self) { index in
                            let offset = startAnimation ? CGSize(width: .random(in: -180...180), height: .random(in: -240...240)) : .zero
                            ClubbedRoundedRectangle(offset: offset)
                                .tag(index)
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                startAnimation.toggle()
            }
    }
    
    @ViewBuilder
    func ClubbedRoundedRectangle(offset: CGSize) -> some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
            .frame(width: 130, height: 130)
            .offset(offset)
            .animation(.easeInOut(duration: 4), value: offset)
    }
    
    @ViewBuilder
    func SingleMetaBall() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom))
            .mask {
                Canvas { content, size in
                    content.addFilter(.alphaThreshold(min: 0.5, color: .red))
                    
                    content.addFilter(.blur(radius: 35))
                    
                    content.drawLayer { ctx in
                        for index in [1, 2] {
                            if let resolvedView = content.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    }
                } symbols: {
                    Ball()
                        .tag(1)
                    
                    Ball(offset: drawOffset)
                        .tag(2)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        drawOffset = value.translation
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            drawOffset = .zero
                        }
                    })
            )
    }
    
    @ViewBuilder
    func Ball(offset: CGSize = .zero) -> some View {
        Circle()
            .fill(.white)
            .frame(width: 150, height: 150)
            .offset(offset)
    }
}

@available(iOS 15.0, *)
struct BallAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        BallAnimationView()
    }
}
