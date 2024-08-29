//
//  HeaderTab.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/29.
//

import SwiftUI

enum HeaderTab: String {
    case chat = "message.badge.filled.fill"
    case friends = "person.2.fill"
    
    var title: String {
        switch self {
        case .chat:
            "Chat"
        case .friends:
            "Friends"
        }
    }
}
