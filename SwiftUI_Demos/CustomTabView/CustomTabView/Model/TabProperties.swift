//
//  TabProperties.swift
//  CustomTabView
//
//  Created by Lurich on 2024/7/4.
//

import SwiftUI

@Observable
class TabProperties {
    var activeTab: Int = 0
    var editMode: Bool = false
    var tabs: [TabModel] = {
        if let order = UserDefaults.standard.object(forKey: "CustomTabOrder") as? [Int] {
            return defaultOrderTabs.sorted { firstModel, secondModel in
                let firstIndex = order.firstIndex(of: firstModel.id) ?? 0
                let secondIndex = order.firstIndex(of: secondModel.id) ?? 0
                return firstIndex < secondIndex
            }
        } else {
            return defaultOrderTabs
        }
    }()
    var initialTabLocation: CGRect = .zero
    var movingTab: Int?
    var moveOffset: CGSize = .zero
    var moveLocation: CGPoint = .zero
    var haptics: Bool = false
}
