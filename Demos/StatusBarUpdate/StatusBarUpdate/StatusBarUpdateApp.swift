//
//  StatusBarUpdateApp.swift
//  StatusBarUpdate
//
//  Created by Lurich on 2023/10/8.
//

import SwiftUI

@main
struct StatusBarUpdateApp: App {
    var body: some Scene {
        WindowGroup {
            StatusBarView {
                ContentView()
            }
        }
    }
}
