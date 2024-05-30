//
//  Tab.swift
//  TabViewOffset
//
//  Created by Lurich on 2024/5/30.
//

import SwiftUI

enum DummyTab: String, CaseIterable {
    case home = "Home"
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var color: Color {
        switch self {
        case .home:
            return .red
        case .chats:
            return .blue
        case .calls:
            return .green
        case .settings:
            return .purple
        }
    }
}
