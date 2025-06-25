//
//  OrderLatteApp.swift
//  OrderLatte
//
//  Created by Xiaofu666 on 2025/6/25.
//

import SwiftUI
import AppIntents

@main
struct OrderLatteApp: App {
    init() {
        AppDependencyManager.shared.add { LatteOrderManager() }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
