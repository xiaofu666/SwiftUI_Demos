//
//  ContentView.swift
//  3DMorphingDotSphere
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct Dot: Identifiable {
    let id = UUID()
    let randomX: Double
    let randomY: Double
    let randomZ: Double
}

struct ContentView: View {
    @State private var morphAmount: Double = 100
    @State private var dots: [Dot] = []
    private let dotCount = 800
    private var colors: [Color] = [.blue, .green, .purple, .pink, .orange]
    private var fadeDuration: Double = 5.5
    private var waitDuration: Double = 5.0
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                // Animation will go here
                let centerX = geometry.size.width / 2
                let centerY = geometry.size.height / 2
                
                TimelineView(.animation) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let tMorph = morphAmount / 100.0
                    let rotation = time * 0.5
                    
                    let totalCycle = fadeDuration + waitDuration
                    let timeInCycle = time.truncatingRemainder(dividingBy: totalCycle)
                    
                    let baseColorIndex = Int(floor(time / totalCycle)) % colors.count
                    let nextColorIndex = (baseColorIndex + 1) % colors.count
                    
                    let count = dots.count
                    
                    let positions = (0..<count).map { i -> (scaledX: Double, scaledY: Double, scaledZ: Double) in
                        let goldenAngle = Double.pi * (3 - sqrt(5))
                        let y = 1 - (Double(i) / Double(count - 1)) * 2
                        let radiusAtY = sqrt(1 - y * y)
                        let theta = goldenAngle * Double(i)
                        
                        let sphereX = radiusAtY * cos(theta)
                        let sphereZ = radiusAtY * sin(theta)
                        
                        let x = interpolate(from: dots[i].randomX, to: sphereX, t: tMorph)
                        let yPos = interpolate(from: dots[i].randomY, to: y, t: tMorph)
                        let z = interpolate(from: dots[i].randomZ, to: sphereZ, t: tMorph)
                        
                        let chaosScale = interpolate(from: 250.0, to: 100.0, t: tMorph)
                        return (x * chaosScale, yPos * chaosScale, z * chaosScale)
                    }
                    
                    let minY = positions.map { $0.scaledY }.min() ?? 0
                    let maxY = positions.map { $0.scaledY }.max() ?? 1
                    
                    ZStack {
                        ForEach(0..<count, id: \.self) { i in
                            let pos = positions[i]
                            let rotatedX = pos.scaledX * cos(rotation) - pos.scaledZ * sin(rotation)
                            let rotatedZ = pos.scaledX * sin(rotation) + pos.scaledZ * cos(rotation)
                            
                            let perspective = 300.0 / (300.0 + rotatedZ)
                            let screenX = rotatedX * perspective
                            let screenY = pos.scaledY * perspective
                            let size = max(1.0, 3 * perspective)
                            
                            let normalizedY = (pos.scaledY - minY) / (maxY - minY)
                            let delay = normalizedY * fadeDuration
                            
                            let progress = max(0.0, min(1.0, (timeInCycle - delay) / fadeDuration))
                            let color = blend(color1: colors[baseColorIndex], color2: colors[nextColorIndex], t: progress)
                            
                            Circle()
                                .fill(color)
                                .frame(width: size, height: size)
                                .position(x: centerX + screenX, y: centerY + screenY)
                                .opacity(0.85)
                        }
                    }
                }
            }
            
            Slider(value: $morphAmount, in: 0...100)
                .padding(.horizontal, 20)
                .accentColor(.white)
                .padding(.bottom, 40)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            if dots.count != dotCount {
                dots = (0..<dotCount).map { _ in generateRandomDot() }
            }
        }
    }
    
    func interpolate(from: Double, to: Double, t: Double) -> Double {
        from * (1 - t) + to * t
    }
    
    func generateRandomDot() -> Dot {
        let u = Double.random(in: 0...1)
        let v = Double.random(in: 0...1)
        let theta = u * 2 * .pi
        let phi = acos(2 * v - 1)
        let r = pow(Double.random(in: 0...1), 1.0 / 3.0)
        
        let x = r * sin(phi) * cos(theta)
        let y = r * sin(phi) * sin(theta)
        let z = r * cos(phi)
        return Dot(randomX: x, randomY: y, randomZ: z)
    }
    
    func blend(color1: Color, color2: Color, t: Double) -> Color {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        UIColor(color1).getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        UIColor(color2).getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return Color(
            red:    Double(r1 * (1 - t) + r2 * t),
            green:  Double(g1 * (1 - t) + g2 * t),
            blue:   Double(b1 * (1 - t) + b2 * t))
    }
}

#Preview {
    ContentView()
}
