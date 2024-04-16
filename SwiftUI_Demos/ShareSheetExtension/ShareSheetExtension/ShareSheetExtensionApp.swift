//
//  ShareSheetExtensionApp.swift
//  ShareSheetExtension
//
//  Created by Lurich on 2024/1/28.
//

import SwiftUI
import SwiftData

@main
struct ShareSheetExtensionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ImageItem.self)
    }
}
