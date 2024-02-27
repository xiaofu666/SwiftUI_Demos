//
//  MiniPlayerView.swift
//  YoutubeMiniPlayer
//
//  Created by Lurich on 2024/2/24.
//

import SwiftUI

struct MiniPlayerView: View {
    var size: CGSize
    @Binding var config: PlayerConfig
    var close: () -> ()
    let miniPlayerHeight: CGFloat = 50
    let playerHeight: CGFloat = 200
    var body: some View {
        VStack(spacing: 0) {
            let progress = config.progress > 0.7 ? (config.progress - 0.7) / 0.3 : 0
//            let progress = config.progress
            
            ZStack {
                GeometryReader {
                    let size = $0.size
                    let width = size.width - 120
                    let height = size.height
                    VideoPlayerView()
                        .frame(width: 120 + width * (1-progress), height: height)
                }
                .zIndex(1)
                PlayerMinifiedContent()
                    .padding(.leading, 130)
                    .padding(.trailing, 15)
                    .foregroundStyle(.primary)
                    .opacity(progress)
            }
            .frame(minHeight: miniPlayerHeight, maxHeight: playerHeight)
            .zIndex(1)
            
            ScrollView(.vertical) {
                if let playerItem = config.selectedPlayerItem {
                    PlayerExpandedContent(playerItem)
                }
            }
            .opacity(1.0 - (config.progress * 1.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.background)
        .clipped()
        .contentShape(.rect)
        .offset(y: config.progress * -tabHeight)
        .frame(height: size.height - config.position, alignment: .top)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let start = value.startLocation.y
                    guard start < playerHeight || start > (size.height - (miniPlayerHeight + tabHeight)) else { return }
                    let height = config.lastPosition + value.translation.height
                    config.position = min(height, size.height - miniPlayerHeight)
                    generateProgress()
                }
                .onEnded { value in
                    let start = value.startLocation.y
                    guard start < playerHeight || start > (size.height - (miniPlayerHeight + tabHeight)) else { return }
                    let velocity = value.velocity.height * 5
                    withAnimation(.smooth(duration: 0.3)) {
                        if (velocity + config.position) > (size.height * 0.65) {
                            config.position = size.height - miniPlayerHeight
                            config.lastPosition = config.position
                            config.progress = 1
                        } else {
                            config.resetPosition()
                        }
                    }
                }
                .simultaneously(with: TapGesture().onEnded({ _ in
                    withAnimation(.smooth(duration: 0.3)) {
                        config.resetPosition()
                    }
                }))
        )
        .transition(.offset(y: config.progress == 1 ? tabHeight : size.height))
        .onChange(of: config.selectedPlayerItem, initial: false) { oldValue, newValue in
            withAnimation(.smooth(duration: 0.3)) {
                config.resetPosition()
            }
        }
    }
    
    @ViewBuilder
    func VideoPlayerView() -> some View {
        GeometryReader {
            let size = $0.size
            Rectangle()
                .fill(.black)
            if let playerItem = config.selectedPlayerItem {
                Image(playerItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                
            }
        }
    }
    
    @ViewBuilder
    func PlayerMinifiedContent() -> some View {
        if let playerItem = config.selectedPlayerItem {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(playerItem.title)
                        .font(.callout)
                        .lineLimit(1)
                    Text(playerItem.author)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxHeight: .infinity)
                .frame(maxHeight: 50)
                
                Spacer(minLength: 0)
                
                Button(action: {}, label: {
                    Image(systemName: "pause.fill")
                        .font(.title2)
                        .frame(width: 35, height: 35)
                        .contentShape(.rect)
                })
                
                Button(action: close, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .frame(width: 35, height: 35)
                        .contentShape(.rect)
                })
            }
        }
    }
    
    @ViewBuilder
    func PlayerExpandedContent(_ item: PlayerItem) -> some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Text(item.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(item.description)
                .font(.callout)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .padding(.top, 10)
    }
    
    func generateProgress() {
        let progress = max(min(config.position / (size.height - miniPlayerHeight), 1.0), 0.0)
        config.progress = progress
    }
}

#Preview {
    ContentView()
}
