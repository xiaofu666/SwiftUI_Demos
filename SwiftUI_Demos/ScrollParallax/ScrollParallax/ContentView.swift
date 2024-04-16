//
//  ContentView.swift
//  ScrollParallax
//
//  Created by Lurich on 2023/12/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Parallax Scroll")
        }
    }
}

#Preview {
    ContentView()
}
