//
//  WheelPicker.swift
//  HorizontalWheelPicker
//
//  Created by Lurich on 2024/3/18.
//

import SwiftUI

struct WheelPicker: View {
    var config: Config
    @Binding var value: CGFloat
    
    @State private var isLoaded: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let horizontalPadding = $0.size.width / 2.0
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    let totalSteps = config.steps * config.count
                    ForEach(0...totalSteps, id: \.self) { index in
                        let remainder = index % config.steps
                        
                        Divider()
                            .background(remainder == 0 ? Color.primary : Color.secondary)
                            .frame(width: 0, height: remainder == 0 ? 20 : 10, alignment: .center)
                            .frame(maxHeight: 20, alignment: .bottom)
                            .overlay(alignment: .bottom) {
                                if remainder == 0 && config.showText {
                                    Text("\(index * config.multiplier / config.steps)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .textScale(.secondary)
                                        .fixedSize()
                                        .offset(y: 20)
                                }
                            }
                    }
                }
                .frame(height: size.height)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                let position: Int? = isLoaded ? Int(value) * config.steps / config.multiplier : nil
                return position
            }, set: { newValue in
                if let newValue {
                    value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
                }
            }))
            .overlay(alignment: .center) {
                Rectangle()
                    .frame(width: 1, height: 40)
                    .padding(.bottom, 20)
            }
            .sensoryFeedback(trigger: value) { oldValue, newValue in
                return SensoryFeedback.impact(weight: .light, intensity: 0.5)
            }
            .safeAreaPadding(.horizontal, horizontalPadding)
            .onAppear() {
                if !isLoaded {
                    isLoaded = true
                }
            }
        }
    }
    
    struct Config: Equatable {
        var count: Int = 20
        var steps: Int = 10
        var spacing: CGFloat = 5
        var multiplier: Int = 10
        var showText: Bool = true
    }
}

#Preview {
    ContentView()
}
