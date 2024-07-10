//
//  SharedModel.swift
//  ZoomTransitions
//
//  Created by Xiaofu666 on 2024/7/10.
//

import SwiftUI
import AVKit

@Observable
class SharedModel {
    var videos: [Video] = files
    
    func generateThumbnail(_ video: Binding<Video>, size: CGSize) async {
        do {
            let asset = AVURLAsset(url: video.wrappedValue.fileURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.maximumSize = size
            generator.appliesPreferredTrackTransform = true
            let cgImage = try await generator.image(at: .zero).image
            guard let deviceColorBasedImage = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else { return }
            let thumbnail = UIImage(cgImage: deviceColorBasedImage)
            await MainActor.run {
                video.wrappedValue.thumbnail = thumbnail
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
