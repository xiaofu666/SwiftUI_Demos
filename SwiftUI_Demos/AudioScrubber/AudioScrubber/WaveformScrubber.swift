//
//  WaveformScrubber.swift
//  AudioScrubber
//
//  Created by Xiaofu666 on 2025/3/26.
//

import SwiftUI
import AVKit

struct WaveformScrubber: View {
    var config: Config = .init()
    var url: URL
    @Binding var progress: CGFloat
    var info: (AudioInfo) -> () = { _ in }
    var onGestureActive: (Bool) -> () = { _ in }
    
    @State private var samples: [Float] = []
    @State private var downsizedSamples: [Float] = []
    @State private var viewSize: CGSize = .zero
    @State private var lastProgress: CGFloat = 0
    @GestureState private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            WaveformShape(samples: downsizedSamples, spacing: config.spacing, width: config.shapeWidth)
                .fill(config.inActiveTint)
            
            WaveformShape(samples: downsizedSamples, spacing: config.spacing, width: config.shapeWidth)
                .fill(config.activeTint)
                .mask {
                    Rectangle()
                        .scale(x: progress, anchor: .leading)
                }
        }
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
        .gesture(
            DragGesture()
                .updating($isActive) { _, out, _ in
                    out = true
                }
                .onChanged { value in
                    let progress = max(min((value.translation.width / viewSize.width) + lastProgress, 1), 0)
                    self.progress = progress
                }
                .onEnded { _ in
                    lastProgress = progress
                }
        )
        .onChange(of: progress) { oldValue, newValue in
            guard !isActive else { return }
            lastProgress = newValue
        }
        .onChange(of:isActive) { oldValue, newValue in
            onGestureActive(newValue)
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            if viewSize == .zero {
                lastProgress = progress
            }
            viewSize = newValue
            initializeAudioFile()
//            initializeAudioFile(newValue)
        }

    }
    
    struct Config {
        var spacing: Float = 2
        var shapeWidth: Float = 2
        var activeTint: Color = .black
        var inActiveTint: Color = .gray.opacity(0.7)
        /// OTHER CONFIGS..
    }
    
    struct AudioInfo {
        var duration: TimeInterval = 0
        /// OTHER AUDIO INFO....
    }

}
/// Custom WaveFrom Shape
fileprivate struct WaveformShape: Shape {
    var samples: [Float]
    var spacing: Float = 2
    var width: Float = 2
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            var x: CGFloat = 0
            for sample in samples {
                let height = max(CGFloat(sample) * rect.height, 1)
                path.addRect(
                    CGRect(
                        origin: .init(x: x + CGFloat(width), y: -height / 2),
                        size: .init(width: CGFloat(width), height: height)
                    )
                )
                x += CGFloat(spacing + width)
            }
        }
        .offsetBy(dx: 0, dy: rect.height / 2)
    }
}

extension WaveformScrubber {
    private func initializeAudioFile(_ size: CGSize? = nil) {
        guard samples.isEmpty else { return }
        Task.detached(priority: .high) {
            do {
                let audioFile = try AVAudioFile(forReading: url)
                let audioInfo = extractAudioInfo(audioFile)
                let samples = try extractAudioSamples(audioFile)
                print(audioInfo.duration, samples.count)
                var downSamplesTmp: [Float] = []
                if let size {
                    let downSampleCount = Int(Float(size.width) / (config.spacing + config.shapeWidth))
                    downSamplesTmp = downSampleAudioSamples(samples, downSampleCount)
                } else {
                    downSamplesTmp = downSampleAudioSamples(samples, samples.count / 1000)
                }
                print(downSamplesTmp.count)
                await MainActor.run { [downSamplesTmp] in
                    self.samples = samples
                    self.downsizedSamples = downSamplesTmp
                    self.info(audioInfo)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    nonisolated func extractAudioSamples(_ file: AVAudioFile) throws -> [Float] {
        let format = file.processingFormat
        let frameCount = UInt32(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return []
        }
        
        try file.read(into: buffer)
        
        if let channel = buffer.floatChannelData {
            let samples = Array(UnsafeBufferPointer(start: channel[0], count: Int(buffer.frameLength)))
            return samples
        }
        
        return []
    }
    
    nonisolated func downSampleAudioSamples(_ samples: [Float], _ count: Int) -> [Float] {
        let chunk = samples.count / count
        var downSamples: [Float] = []
        for index in 0..<count {
            let start = index * chunk
            let end = min((index + 1) * chunk, samples.count)
            let chunkSamples = samples[start..<end]
            let maxValue = chunkSamples.max() ?? 0
            downSamples.append(maxValue)
        }
        return downSamples
    }
    
    nonisolated func extractAudioInfo(_ file: AVAudioFile) -> AudioInfo {
        let format = file.processingFormat
        let sampleRate = format.sampleRate
        let duration = file.length / Int64(sampleRate)
        return .init(duration: TimeInterval(duration))
    }
}


#Preview {
    ContentView()
}
