//
//  ThemeViewApp.swift
//  ThemeView
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

@main
struct ThemeViewApp: App {
    
    @StateObject var dataSource = DataSource()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataSource)
        }
    }
}
