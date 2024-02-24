//
//  Tab.swift
//  YoutobeMiniPlayer
//
//  Created by Lurich on 2024/2/24.
//

import SwiftUI

enum Tab: String,CaseIterable {
    case home = "Home"
    case shorts = "Shorts"
    case subscriptions = "Subscriptions"
    case you = "You"
    
    var symbol: String {
        switch self {
        case .home:
            "house.fill"
        case .shorts:
            "video.badge.waveform.fill"
        case .subscriptions:
            "play.square.stack.fill"
        case .you:
            "person.circle.fill"
        }
    }
}
