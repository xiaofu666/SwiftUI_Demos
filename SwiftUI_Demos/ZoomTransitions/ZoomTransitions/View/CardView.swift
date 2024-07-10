//
//  CardView.swift
//  ZoomTransitions
//
//  Created by Xiaofu666 on 2024/7/10.
//

import SwiftUI

struct CardView: View {
    var screenSize: CGSize
    @Binding var video: Video
    @Environment(SharedModel.self) private var sharedModel
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            if let thumbnail = video.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.fill)
                    .frame(width: size.width, height: size.height)
                    .task(priority: .high) {
                        await sharedModel.generateThumbnail($video, size: screenSize)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
