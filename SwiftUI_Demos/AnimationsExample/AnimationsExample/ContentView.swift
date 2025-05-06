//
//  ContentView.swift
//  AnimationsExample
//
//  Created by Xiaofu666 on 2025/5/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("KeyFrames") {
                    KeyFrameExample()
                }
                NavigationLink("Phase Animator") {
                    PhaseAnimatorExample()
                }
            }
            .navigationTitle("Animation's")
        }
    }
}

#Preview {
    ContentView()
}
