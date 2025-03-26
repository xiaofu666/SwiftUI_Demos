//
//  ContentView.swift
//  AudioScrubber
//
//  Created by Xiaofu666 on 2025/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            List {
                if let audioURL {
                    Section("Audio.mp3") {
                        let config = WaveformScrubber.Config(
                            spacing: 2,
                            shapeWidth: 2,
                            activeTint: .black,
                            inActiveTint: .gray.opacity(0.5)
                        )
                        WaveformScrubber(config: config, url: audioURL, progress: $progress) { info in
                            print(info.duration)
                        } onGestureActive: { state in
                            
                        }
                        .frame(height: 60)
                    }
                }
            }
            .navigationTitle("Waveform Scrubber")
        }
    }
    
    var audioURL: URL? {
        Bundle.main.url(forResource: "Audio", withExtension: "mp3")
    }
}

#Preview {
    ContentView()
}
