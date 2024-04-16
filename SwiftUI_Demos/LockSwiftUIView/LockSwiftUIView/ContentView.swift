//
//  ContentView.swift
//  LockSwiftUIView
//
//  Created by Lurich on 2023/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LockView(lockType: .both, lockPin: "0320", isEnabled: true) {
            VStack {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
