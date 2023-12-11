//
//  CustomVideoView.swift
//  ReelsLayout
//
//  Created by Lurich on 2023/11/14.
//

import SwiftUI
import AVKit

struct CustomVideoView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        /**
        AVLayerVideoGravityResizeAspect
        保持纵横比；适合图层边界。
         
        AVLayerVideoGravityResizeAspectFill
        保持纵横比；填充层边界。
         
        AVLayerVideoGravityResize
        拉伸以填充层边界。
         */
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
