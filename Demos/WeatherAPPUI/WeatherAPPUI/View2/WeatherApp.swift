//
//  WeatherApp.swift
//  WeatherAPPUI
//
//  Created by Lurich on 2024/3/7.
//

import SwiftUI

struct WeatherApp: View {
    @State private var weather: WeatherState = .rainy
    let now = Date.now
    
    var body: some View {
        ScrollView(.vertical) {
            pannel
            
            Spacer(minLength: 1000)
            
            Text("效果真棒")
        }
        .frame(maxHeight: .infinity)
        .background() {
            background
        }
    }
    
    var background: some View {
        TimelineView(.periodic(from: now , by: 0.001)){ timeline in
            switch weather {
            case .sunny:
                Rectangle()
                    .overlay (
                        Image(.logo2)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
            case .rainy:
                Rectangle()
                    .foregroundStyle(
                        ShaderLibrary.heartfelt(
                            .boundingRect,
                            .float(timeline.date.timeIntervalSince(now)),
                            .image(
                                Image(.logo2)
                                    .resizable()
                            )
                        )
                    )
            case .snowy:
                Rectangle()
                    .foregroundStyle(
                        ShaderLibrary.snowScreen(
                            .boundingRect,
                            .float(timeline.date.timeIntervalSince(now)),
                            .image(
                                Image(.logo2)
                                    .resizable()
                            )
                        )
                    )
            }
        }
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
    }

    
    var pannel: some View {
        VStack {
            VStack(spacing: 20){
                Text("北京市")
                    .font(.title2)
                Text("8°")
                    .font(.largeTitle)
                Text(weather.labelText)
            }
            Divider( )
            Picker("", selection: $weather) {
                ForEach(WeatherState.allCases,id:\.self) { w in
                    Text(w.labelText).tag(w)
                }
            }
            .pickerStyle(.segmented)
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth:.infinity)
        .background {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundStyle(.ultraThinMaterial)
        }
        .padding( )
    }
}

enum WeatherState: String, CaseIterable {
    case sunny
    case rainy
    case snowy
    var labelText: String {
        switch self {
        case .sunny:
            return "晴朗"
        case .rainy:
            return "下雨"
        case .snowy:
            return "下雪"
        }
    }
}

#Preview {
    WeatherApp()
}
