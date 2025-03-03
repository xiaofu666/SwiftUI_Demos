//
//  AppShortcutsApp.swift
//  AppShortcuts
//
//  Created by Xiaofu666 on 2025/3/3.
//

import SwiftUI

@main
struct AppShortcutsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Memory.self)
        }
    }
}
