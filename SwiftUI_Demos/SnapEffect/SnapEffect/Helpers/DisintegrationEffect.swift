//
//  DisintegrationEffect.swift
//  SnapEffect
//
//  Created by Xiaofu666 on 2024/11/27.
//

import SwiftUI

extension View {
    @ViewBuilder
    func disintegrationEffect(isDeleted: Bool, completion: @escaping () -> ()) -> some View {
        self
            .modifier(DisintegrationEffectModifier(isDeleted: isDeleted, completion: completion))
    }
}

fileprivate struct DisintegrationEffectModifier: ViewModifier {
    var isDeleted: Bool
    var completion: () -> ()
    @State private var triggerSnapshot: Bool = false
    @State private var animateEffect: Bool = false
    @State private var particles: [SnapParticle] = []
    
    func body(content: Content) -> some View {
        content
            .opacity(particles.isEmpty ? 1 : 0)
            .snapshot(trigger: triggerSnapshot) { image in
                Task.detached(priority: .high) {
                    try? await Task.sleep(for: .seconds(0.2))
                    await createParticles(image)
                }
            }
            .overlay(alignment: .topLeading) {
                DisintegrationEffectView(particles: $particles, animateEffect: $animateEffect)
                    .opacity(0.3)
            }
            .onChange(of: isDeleted) { oldValue, newValue in
                if newValue && particles.isEmpty {
                    triggerSnapshot = true
                }
            }
    }
    
    private func createParticles(_ snapshot: UIImage) async {
        var tmpParticles: [SnapParticle] = []
        let size = snapshot.size
        let width = size.width
        let height = size.height
        let maxGridCount: Int = 1100
        
        var gridSize: Int = 1
        var rows = Int(width) / gridSize
        var columns = Int(height) / gridSize
        
        while (rows * columns) > maxGridCount {
            gridSize += 1
            rows = Int(width) / gridSize
            columns = Int(height) / gridSize
        }
        
        for row in 0...rows {
            for column in 0...columns {
                let positionX = column * gridSize
                let positionY = row * gridSize
                let cropRect = CGRect(x: positionX, y: positionY, width: gridSize, height: gridSize)
                let croppedImage = cropImage(snapshot, rect: cropRect)
                tmpParticles.append(
                    .init(
                        particleImage: croppedImage,
                        particleOffset: cropRect.origin
                    )
                )
            }
        }
        
        await MainActor.run { [tmpParticles] in
            self.particles = tmpParticles
            withAnimation(.easeInOut(duration: 1.5), completionCriteria: .logicallyComplete) {
                animateEffect = true
            } completion: {
                completion()
            }
        }
    }
    
    private func cropImage(_ snapShot: UIImage, rect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
        return renderer.image { ctx in
            ctx.cgContext.interpolationQuality = .low
            snapShot.draw(at: .init(x: -rect.origin.x, y: -rect.origin.y))
        }
    }
}

fileprivate struct SnapParticle: Identifiable {
    var id: String = UUID().uuidString
    var particleImage: UIImage
    var particleOffset: CGPoint
}

fileprivate struct DisintegrationEffectView: View {
    @Binding var particles: [SnapParticle]
    @Binding var animateEffect: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(particles) { particle in
                Image(uiImage: particle.particleImage)
                    .offset(x: particle.particleOffset.x, y: particle.particleOffset.y)
                    .offset(
                        x: animateEffect ? .random(in: (-60)...(-10)) : 0,
                        y: animateEffect ? .random(in: (-100)...(-10)) : 0
                    )
                    .opacity(animateEffect ? 0 : 1)
            }
        }
        .compositingGroup()
        .blur(radius: animateEffect ? 5 : 0)
    }
}

#Preview {
    ContentView()
}
