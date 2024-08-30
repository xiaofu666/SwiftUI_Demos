//
//  SwiftDataExportApp.swift
//  SwiftDataExport
//
//  Created by Xiaofu666 on 2024/8/30.
//

import SwiftUI

@main
struct SwiftDataExportApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Transaction.self)
        }
    }
}
