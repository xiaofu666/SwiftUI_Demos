//
//  ContentView.swift
//  ScrollInteraction
//
//  Created by Xiaofu666 on 2024/10/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var link: String
}


