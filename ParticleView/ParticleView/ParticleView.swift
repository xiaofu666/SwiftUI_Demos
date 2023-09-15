//
//  ContentView.swift
//  TimeLineLaunch0428
//
//  Created by Lurich on 2022/4/28.
//

import SwiftUI
import Combine

@available(iOS 15, *)
struct ParticleView: View {
    
    @StateObject var vm = ParticleViewModel()
    
    var body: some View {
        VStack {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let  timeLineData = timeline.date.timeIntervalSinceReferenceDate
                    vm.particleSystem.update(date: timeLineData)
                    
                    for particle in vm.particleSystem.particles {
                        
                        let xPos = particle.x * size.width
                        let yPos = particle.y * size.height
                        
                        var contextCopy = context
                        contextCopy.addFilter(.colorMultiply(Color(hue: particle.hue, saturation: 1, brightness: 1  )))
                        contextCopy.opacity = 1 - (timeLineData - particle.creationDate)
                        contextCopy.draw(vm.particleSystem.image, at: CGPoint(x: xPos, y: yPos))
                    }
                }
            }
            
            DribbleAnimatedView(showPopUp: .constant(true), rotateBall: .constant(true))
            
            WaveFrom(color: Color.blue, amplify: 100, isReversed: true)
        }
    }
}

@available(iOS 15, *)
struct ParticleView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleView()
    }
}

@available(iOS 15, *)
struct Particle: Hashable {
    let x: Double
    let y: Double
    let creationDate = Date.now.timeIntervalSinceReferenceDate
    let hue: Double
}

@available(iOS 15, *)
class ParticleSystem {
    
    let image = Image(systemName: "heart.circle")
    var particles = Set<Particle>()
    var center = UnitPoint.center
    var hue = 0.0
    
    func update(date: TimeInterval) {
        
        let deathDate = date - 1
        
        for particle in particles {
            
            if particle.creationDate < deathDate {
                
                particles.remove(particle)
            }
        }
        
        let newParticle = Particle(x: center.x, y: center.y, hue: hue)
        particles.insert(newParticle)
        hue += 0.1
        if hue > 1 {hue -= 1}
    }
}

@available(iOS 15, *)
class ParticleViewModel: ObservableObject {
    
    @Published var particleSystem = ParticleSystem()
    
    let timerPublisher = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    var cancellables = Set<AnyCancellable>()
    
    var p:[CGPoint] = []
    let a = 5.0
    let b = 7.0
    let c = 2.2
    
    init() {
        for i  in stride(from: 0.0, to: 60.0, by: 0.02) {
            var x = a * sin(4.0 * i + c)
            var y = b * sin(i)
            x = x *  19.0 + 200
            y = y * 19.0 + 400
            p.append(CGPoint(x: x, y: y))
        }
        
        timerPublisher
            .zip(p.publisher)
            .sink { [weak self] turple in
                self?.particleSystem.center.x = turple.1.x / UIScreen.main.bounds.width
                self?.particleSystem.center.y = turple.1.y / UIScreen.main.bounds.height
            }
            .store(in: &cancellables)
    }
}
