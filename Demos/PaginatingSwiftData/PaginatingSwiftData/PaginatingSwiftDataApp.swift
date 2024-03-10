//
//  PaginatingSwiftDataApp.swift
//  PaginatingSwiftData
//
//  Created by Lurich on 2024/3/8.
//

import SwiftUI

@main
struct PaginatingSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Country.self)
    }
}
