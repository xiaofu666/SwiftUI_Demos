//
//  HeartView.swift
//  HeartAnimation
//
//  Created by Lurich on 2023/9/24.
//

import SwiftUI

struct HeartView: View {
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    @State private var heartBeat: Int = 85
    
    var body: some View {
        VStack {
            ZStack {
                if showPulses {
                    TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeLine in
                        // 方法2
//                        addView1(timeLine)
                        // 方法2
                        addView2(timeLine)
                    }
                }
                
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.red.gradient)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .bottomLeading, content: {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    
                    HStack(alignment: .bottom, spacing: 6) {
                        TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeLine in
                            Text("\(heartBeat)")
                                .font(.system(size: 45).bold())
                                .contentTransition(.numericText(value: Double(heartBeat)))
                                .foregroundStyle(.white)
                                .onChange(of: timeLine.date) { oldValue, newValue in
                                    if beatAnimation {
                                        withAnimation(.bouncy) {
                                            heartBeat = .random(in: 80...130)
                                        }
                                    }
                                }
                        }
                        
                        Text("BPM")
                            .font(.callout.bold())
                            .foregroundStyle(.red.gradient)
                    }
                    
                    Text("88 BPM, 10m ago")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .padding(30)
            })
            .background(.bar, in: .rect(cornerRadius: 30))
            
            Toggle("Beat Animation", isOn: $beatAnimation)
                .padding(15)
                .frame(maxWidth: 350)
                .background(.bar, in: .rect(cornerRadius: 15))
                .padding(.top, 20)
                .onChange(of: beatAnimation) { oldValue, newValue in
                    if pulsedHearts.isEmpty {
                        showPulses = true
                    }
                    if newValue && pulsedHearts.isEmpty {
                        addPulsedHeart()
                    }
                }
                .disabled(!beatAnimation && !pulsedHearts.isEmpty)
        }
    }
    
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulsedHearts.append(pulsedHeart)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedHearts.removeAll(where: { $0.id == pulsedHeart.id })
            if pulsedHearts.isEmpty {
                showPulses = false
            }
        }
    }
    
    @ViewBuilder
    func addView1(_ timeLine: TimelineViewDefaultContext) -> some View {
        Canvas { context, size in
            for heart in pulsedHearts {
                if let resolvedView = context.resolveSymbol(id: heart.id) {
                    let centerX = size.width / 2
                    let centerY = size.height / 2
                    context.draw(resolvedView, at: CGPoint(x: centerX, y: centerY))
                }
            }
        } symbols: {
            ForEach(pulsedHearts) { heart in
                PulseHeartView()
                    .id(heart.id)
            }
        }
        .onChange(of: timeLine.date) { oldValue, newValue in
            if beatAnimation {
                addPulsedHeart()
            }
        }
    }
    
    @ViewBuilder
    func addView2(_ timeLine: TimelineViewDefaultContext) -> some View {
        ZStack {
            ForEach(pulsedHearts) { heart in
                PulseHeartView()
            }
        }
        .onChange(of: timeLine.date) { oldValue, newValue in
            if beatAnimation {
                addPulsedHeart()
            }
        }
    }
}

#Preview {
    ContentView()
}
