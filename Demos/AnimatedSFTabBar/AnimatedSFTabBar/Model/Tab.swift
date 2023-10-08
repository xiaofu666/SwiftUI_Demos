//
//  Tab.swift
//  AnimatedSFTabBar
//
//  Created by Lurich on 2023/9/2.
//

import SwiftUI

/// Tab's
enum Tab: String, CaseIterable {
    case photos = "photo.stack"
    case chat = "bubble.left.and.text.bubble.right"
    case apps = "square.3.layers.3d"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person.2.crop.square.stack.fill"
    
    var title: String {
        switch self {
        case .photos:
            return "photos"
        case .chat:
            return "Chat"
        case.apps:
            return "Apps"
        case .notifications:
            return "Notifications"
        case .profile:
            return "Profile"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = UUID()
    var tab: Tab
    var isAnimating: Bool?
}
