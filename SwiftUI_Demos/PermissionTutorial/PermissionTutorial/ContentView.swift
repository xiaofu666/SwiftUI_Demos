//
//  ContentView.swift
//  PermissionTutorial
//
//  Created by Xiaofu666 on 2025/8/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Permission Sheet")
        }
        .permissionSheet([.camera, .microphone, .photoLibrary, .location])
    }
}

#Preview {
    ContentView()
}
