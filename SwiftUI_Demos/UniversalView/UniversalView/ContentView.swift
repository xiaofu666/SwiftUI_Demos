//
//  ContentView.swift
//  UniversalView
//
//  Created by Xiaofu666 on 2024/10/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var show: Bool = false
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Floating Video Player") {
                    show.toggle()
                }
                .universalOverlay(show: $show) {
                    FloatingVideoPlayerView(show: $show)
                }
                
                Button("Show Dummy Sheet") {
                    showSheet.toggle()
                }
            }
            .navigationTitle("Universal Overlay")
            .sheet(isPresented: $showSheet) {
                Text("Hello From Sheets!")
            }
        }
    }
}

fileprivate struct FloatingVideoPlayerView: View {
    @Binding var show: Bool
    @State private var player: AVPlayer?
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let height: CGFloat = 285
            
            Group {
                if let player {
                    VideoPlayer(player: player)
                        .background(.black)
                        .clipShape(.rect(cornerRadius: 25))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                }
            }
            .frame(height: height)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translation = value.translation + lastOffset
                        offset = translation
                    })
                    .onEnded({ value in
                        withAnimation(.bouncy) {
                            offset.width = 0
                            
                            if offset.height < 0 {
                                offset.height = 0
                            }
                            if offset.height > (size.height - height) {
                                offset.height = size.height - height
                            }
                        }
                        lastOffset = offset
                    })
            )
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.horizontal, 15)
        .transition(.blurReplace)
        .onAppear() {
            if let videoURL {
                player = AVPlayer(url: videoURL)
                player?.play()
            }
        }
        .onDisappear() {
            if let player {
                player.pause()
            }
        }
    }
    
    private var videoURL: URL? {
        if let bundle = Bundle.main.path(forResource: "SampleVideo", ofType: "MP4") {
            return .init(filePath: bundle)
        }
        return nil
    }
}

extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
