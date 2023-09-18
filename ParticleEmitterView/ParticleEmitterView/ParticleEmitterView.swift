//
//  ParticleEmitterView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct ParticleEmitterView: View {
    @State private var isLike: [Bool] = [false, false, false]
    var body: some View {
        HStack(spacing: 20) {
            CustomButton(systemImage: "suit.heart.fill", status: isLike[0], activeTint: .pink, inActiveTint: .gray) {
                isLike[0].toggle()
            }
            
            CustomButton(systemImage: "star.fill", status: isLike[1], activeTint: .yellow, inActiveTint: .gray) {
                isLike[1].toggle()
            }
            
            CustomButton(systemImage: "square.and.arrow.up.fill", status: isLike[2], activeTint: .blue, inActiveTint: .gray) {
                isLike[2].toggle()
            }
        }
        
    }
    
    @ViewBuilder
    func CustomButton(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(systemImage: systemImage, font: .title2, status: status, activeTint: activeTint, inActiveTint: inActiveTint)
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : .gray.opacity(0.6))
                }
        }
    }
}

@available(iOS 15.0, *)
struct ParticleEmitterView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleEmitterView()
    }
}

struct ParticleModel: Identifiable {
    var id: UUID = UUID()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
}

@available(iOS 15.0, *)
extension View {
    @ViewBuilder
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color) -> some View {
        self.modifier(ParticleModifier(systemImage: systemImage, font: font, status: status, activeTint: activeTint, inActiveTint: inActiveTint))
    }
}

@available(iOS 15.0, *)
fileprivate struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color
    
    @State private var particles: [ParticleModel] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    Group {
                        ForEach(particles) { particle in
                            Image(systemName: systemImage)
                                .foregroundColor(status ? activeTint : inActiveTint)
                                .scaleEffect(particle.scale)
                                .offset(x: particle.randomX, y: particle.randomY)
                                .opacity(particle.opacity)
                                .opacity(status ? 1 : 0)
                                .animation(.none, value: status)
                        }
                    }
                }
                .onAppear {
                    if particles.isEmpty {
                        for _ in 1...15 {
                            let particle = ParticleModel()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        for i in particles.indices {
                            particles[i].reset()
                        }
                    } else {
                        for i in particles.indices {
                            let total = CGFloat(particles.count)
                            let progress = CGFloat(i) / total
                            let maxX: CGFloat = progress > 0.5 ? 100 : -100
                            let maxY: CGFloat = 60
                            let randomX: CGFloat = (progress > 0.5 ? progress - 0.5 : progress) * maxX
                            let randomY: CGFloat = (progress > 0.5 ? progress - 0.5 : progress) * maxY + 35
                            let randomScale: CGFloat = .random(in: 0.35...1.0)
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                let extraRandomX: CGFloat = progress > 0.5 ? .random(in: 0...10) : .random(in: -10...0)
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                
                                particles[i].randomX = randomX + extraRandomX
                                particles[i].randomY = -randomY - extraRandomY
                            }
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[i].scale = randomScale
                            }
                            
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + (Double(i) * 0.005))) {
                                particles[i].scale = 0.001
                            }
                        }
                    }
                }
            }
    }
}
