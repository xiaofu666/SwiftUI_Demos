//
//  InstagramPinchZoomApp.swift
//  InstagramPinchZoom
//
//  Created by Lurich on 2024/3/30.
//

import SwiftUI

@main
struct InstagramPinchZoomApp: App {
    var body: some Scene {
        WindowGroup {
            ZoomContainer {
                ContentView()
            }
        }
    }
}
