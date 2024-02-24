//
//  PlayerConfig.swift
//  YoutobeMiniPlayer
//
//  Created by Lurich on 2024/2/24.
//

import SwiftUI

struct PlayerConfig: Equatable {
    var position: CGFloat = .zero
    var lastPosition: CGFloat = .zero
    var progress: CGFloat = .zero
    var selectedPlayerItem: PlayerItem?
    var showMiniPlayer: Bool = false
    
    mutating func resetPosition() {
        position = .zero
        lastPosition = .zero
        progress = .zero
    }
}
