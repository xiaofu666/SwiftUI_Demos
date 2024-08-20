//
//  Tab.swift
//  FloatingTabBar
//
//  Created by Xiaofu666 on 2024/8/20.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house"
    case search = "magnifyingglass"
    case notifications = "bell"
    case settings = "gearshape"
    
    var title: String {
        switch self {
        case .home:
            "Home"
        case .search:
            "Search"
        case .notifications:
            "Norifications"
        case .settings:
            "Settings"
        }
    }
}
