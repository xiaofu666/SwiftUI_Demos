//
//  ShaderDemo.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/26.
//

import SwiftUI

struct PixellateView: View {
    @State private var pixellate: CGFloat = 1.0
    var body: some View {
        VStack {
            Image(.xcode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .distortionEffect(.init(function: .init(library: .default, name: "pixellate"), arguments: [.float(pixellate)]), maxSampleOffset: .zero)
            
            Slider(value: $pixellate, in: 1...30)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Pixellate")
    }
}

struct WavesView: View {
    @State private var speed: CGFloat = 6
    @State private var amplitude: CGFloat = 10
    @State private var frequency: CGFloat = 25
    let startDate: Date = .init()
    
    var body: some View {
        VStack {
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                
                Image(.xcode)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .distortionEffect(.init(function: .init(library: .default, name: "wave"), arguments: [
                        .float(time),
                        .float(speed),
                        .float(frequency),
                        .float(amplitude)
                    ]), maxSampleOffset: .zero)
            }
            
            Section("Speed") {
                Slider(value: $speed, in: 1...15)
            }
            Section("Frequemcy") {
                Slider(value: $frequency, in: 1...50)
            }
            Section("Amplitude") {
                Slider(value: $amplitude, in: 1...35)
            }
            
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                
                Text("Hello World!")
                    .font(.largeTitle)
                    .frame(height: 100)
                    .distortionEffect(.init(function: .init(library: .default, name: "wave"), arguments: [
                        .float(time),
                        .float(speed),
                        .float(frequency),
                        .float(amplitude)
                    ]), maxSampleOffset: .init(width: .zero, height: 100))
            }
        }
        .padding()
        .navigationTitle("Wave")
    }
}

struct GrayScaleView: View {
    @State private var enableLayerEffect: Bool = false
    var body: some View {
        VStack {
            Image(.xcode)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .layerEffect(.init(function: .init(library: .default, name: "grayscale"), arguments: []), maxSampleOffset: .zero, isEnabled: enableLayerEffect)
            
            Toggle("Enable Grayscale Layer Effect", isOn: $enableLayerEffect)
            
            Spacer()
        }
        .padding()
        .navigationTitle("GrayScale")
    }
}

#Preview {
    GrayScaleView()
}
