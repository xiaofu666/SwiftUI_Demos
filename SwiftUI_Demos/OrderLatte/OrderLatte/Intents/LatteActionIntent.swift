//
//  LatteActionIntent.swift
//  OrderLatte
//
//  Created by Xiaofu666 on 2025/6/25.
//

import SwiftUI
import AppIntents

struct LatteActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Latte Order Update"
    static var isDiscoverable: Bool = false
    
    init() {
    }
    
    init(isUpdatingPercentage: Bool, isIncremental: Bool) {
        self.isUpdatingPercentage = isUpdatingPercentage
        self.isIncremental = isIncremental
    }
    
    @Parameter var isUpdatingPercentage: Bool
    @Parameter var isIncremental: Bool
    
    @Dependency var manager: LatteOrderManager
    
    func perform() async throws -> some IntentResult {
        if isUpdatingPercentage {
        /// Update Milk Percentage
            if isIncremental {
                manager.milkPercentage = min(manager.milkPercentage + 10, 100)
            } else {
                manager.milkPercentage = max(manager.milkPercentage - 10, 0)
            }
        } else {
            /// Update Latte Count
            if isIncremental {
                manager.count = min(manager.count + 1, 10)
            } else {
                manager.count = max(manager.count - 1, 1)
            }
        }
        return .result()
    }
}
