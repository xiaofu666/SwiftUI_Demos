//
//  ContentView.swift
//  CustomToasts
//
//  Created by Lurich on 2023/12/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Toast") {
                Toast.shared.present(
                    title: "Hello World",
                    symbol: "globe",
                    tint: .red,
                    isUserInteractionEnabled: true,
                    timing: .long
                )
            }
        }
        .padding()
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
