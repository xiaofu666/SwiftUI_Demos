//
//  SwiftTransformerApp.swift
//  SwiftTransformer
//
//  Created by Lurich on 2024/4/22.
//

import SwiftUI

@main
struct SwiftTransformerApp: App {
    init() {
        ColorTransformer.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ColorModel.self)
        }
    }
}
