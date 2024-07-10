//
//  VideoPlayerView.swift
//  ZoomTransitions
//
//  Created by Xiaofu666 on 2024/7/10.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var video: Video
    @State private var player: AVPlayer?
    
    var body: some View {
        CustomVideoPlayerView(player: player)
            .onAppear() {
                guard player == nil else { return }
                player = AVPlayer(url: video.fileURL)
            }
            .onDisappear() {
                player?.pause()
            }
            .onScrollVisibilityChange { isVisible in
                if isVisible {
                    player?.play()
                } else {
                    player?.pause()
                }
            }
            .onGeometryChange(for: Bool.self) { proxy in
                let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                let height = proxy.size.height * 0.97
                return abs(minY) > height
            } action: { newValue in
                if newValue {
                    player?.seek(to: .zero)
                    player?.pause()
                }
            }

    }
}

#Preview {
    ContentView()
}
