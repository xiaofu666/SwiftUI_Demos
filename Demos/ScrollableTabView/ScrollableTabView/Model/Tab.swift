//
//  Tab.swift
//  ScrollableTabView
//
//  Created by Lurich on 2023/11/13.
//

import SwiftUI

/// Tab's
enum Tab: String,CaseIterable {
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .calls:
            return "phone"
        case .chats:
            return "bubble.left.and.bubble.right"
        case .settings:
            return "gear"
        }
    }
    
    var systemColor: Color {
        switch self {
        case .calls:
            return .red
        case .chats:
            return .green
        case .settings:
            return .purple
        }
    }
}
