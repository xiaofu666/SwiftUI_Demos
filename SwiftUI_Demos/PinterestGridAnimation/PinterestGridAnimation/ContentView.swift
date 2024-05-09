//
//  ContentView.swift
//  PinterestGridAnimation
//
//  Created by Lurich on 2024/5/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
