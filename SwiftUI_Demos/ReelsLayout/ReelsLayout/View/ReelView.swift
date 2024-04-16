//
//  ReelView.swift
//  ReelsLayout
//
//  Created by Lurich on 2023/11/14.
//

import SwiftUI
import AVKit

struct ReelView: View {
    @Binding var reel: Reel
    @Binding var likedCounter: [Like]
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var player: AVPlayer?
    @State private var looper: AVPlayerLooper?
    
    var body: some View {
        GeometryReader { proxy in
            let rect = proxy.frame(in: .scrollView(axis: .vertical))
            
            CustomVideoView(player: $player)
                .preference(key: OffsetKey.self, value: rect)
                .onPreferenceChange(OffsetKey.self, perform: { value in
                    playOrPause(value)
                })
                .overlay(alignment: .bottom, content: {
                    ReelDetailView()
                })
                .onTapGesture(count: 2, perform: { position in
                    let id = UUID()
                    likedCounter.append(.init(id: id, tappedRect: position, isAnimated: false))
                    withAnimation(.snappy(duration: 1.2), completionCriteria: .logicallyComplete) {
                        if let index = likedCounter.firstIndex(where: { $0.id == id }) {
                            likedCounter[index].isAnimated = true
                        }
                    } completion: {
                        likedCounter.removeAll(where: { $0.id == id })
                    }
                    reel.isLiked = true
                })
                .onAppear() {
                    guard player == nil else { return }
                    guard let bundleID = Bundle.main.path(forResource: reel.videoID, ofType: "MP4") else { return }
                    let videoURL = URL(filePath: bundleID)
                    let playerItem = AVPlayerItem(url: videoURL)
                    let queue = AVQueuePlayer(playerItem: playerItem)
                    looper = AVPlayerLooper(player: queue, templateItem: playerItem)
                    player = queue
                }
                .onDisappear() {
                    player = nil
                }
        }
    }
    
    func playOrPause(_ rect: CGRect) {
        if -rect.minY < size.height * 0.5 && rect.minY < size.height * 0.5 {
            player?.play()
        } else {
            player?.pause()
        }
        
        if rect.minY >= size.height || -rect.minY >= size.height {
            player?.seek(to: .zero)
        }
    }
    
    @ViewBuilder
    func ReelDetailView() -> some View {
        HStack(alignment: .bottom, spacing: 10, content: {
            VStack(alignment: .leading, spacing: 8, content: {
                HStack(spacing: 10, content: {
                    Image(systemName: "person.circle.fill")
                        .font(.largeTitle)
                    
                    Text(reel.authorName)
                        .font(.callout)
                        .lineLimit(1)
                })
                .foregroundStyle(.white)
                
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .clipped()
            })
            
            Spacer(minLength: 0)
            
            VStack(spacing: 35, content: {
                Button("", systemImage: reel.isLiked ? "suit.heart.fill" : "suit.heart") {
                    reel.isLiked.toggle()
                }
                .symbolEffect(.bounce, value: reel.isLiked)
                .foregroundStyle(reel.isLiked ? .red : .white)
                
                Button("", systemImage: "message", action: { })
                
                Button("", systemImage: "paperplane", action: { })
                
                Button("", systemImage: "ellipsis", action: { })
            })
            .font(.title2)
            .foregroundStyle(.white)
        })
        .padding(.leading, 15)
        .padding(.trailing, 10)
        .padding(.bottom, safeArea.bottom + 15)
    }
}

#Preview {
    ContentView()
}
