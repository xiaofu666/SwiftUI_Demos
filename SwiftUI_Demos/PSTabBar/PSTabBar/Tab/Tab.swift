//
//  Tab.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/28.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case play = "house.fill"
    case explore = "xmark.bin.fill"
    case store = "bell.fill"
    case library = "gamecontroller.fill"
    case search = "magnifyingglass"
    
    var title: String {
        switch self {
        case .play:
            "Play"
        case .explore:
            "Explore"
        case .store:
            "Store"
        case .library:
            "Library"
        case .search:
            "Search"
        }
    }
    
    var index: CGFloat {
        return CGFloat(Tab.allCases.firstIndex(of: self) ?? 0)
    }
    static var count: CGFloat {
        return CGFloat(Tab.allCases.count)
    }
}
