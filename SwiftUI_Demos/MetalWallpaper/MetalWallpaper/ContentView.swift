//
//  ContentView.swift
//  MetalWallpaper
//
//  Created by Lurich on 2024/7/19.
//

import SwiftUI

enum MetalStyle: String ,CaseIterable {
    case grain = "Grain"
    case leather = "Leather"
    case rain = "Rain"
    case snow = "Snow"
    
    func shape(_ elapsedTime: TimeInterval) -> AnyShapeStyle {
        switch self {
        case .grain:
            return .grainGradient(time: elapsedTime)
        case .leather:
            return .leather(lightColor: .white, time: elapsedTime)
        case .rain:
            return .rain(image: (Image(.test).resizable()), time: elapsedTime)
        case .snow:
            return .snow(image: (Image(.test).resizable()), time: elapsedTime)
        }
    }
}

struct ContentView: View {
    @State private var startTime = Date.now
    @State private var style: MetalStyle = .grain
    var body: some View {
        VStack(spacing: 30) {
            TimelineView(.animation) { timeline in
                let elapsedTime = startTime.distance(to: Date.now)
                VStack {
                    Text(style.rawValue)
                        .font(.title)
                        .fontWeight(.ultraLight)
                        .foregroundColor(.white)
                }
                .frame(width: 350, height: 350)
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(style.shape(elapsedTime))
                }
            }
            
            Picker("", selection: $style) {
                ForEach(MetalStyle.allCases, id: \.rawValue) { style in
                    Text(style.rawValue)
                        .tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(20)
    }
}

#Preview {
    ContentView()
}
