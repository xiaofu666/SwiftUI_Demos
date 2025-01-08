//
//  DownsizedImagesApp.swift
//  DownsizedImages
//
//  Created by Xiaofu666 on 2025/1/7.
//

import SwiftUI

@main
struct DownsizedImagesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Cache.self)
        }
    }
}
