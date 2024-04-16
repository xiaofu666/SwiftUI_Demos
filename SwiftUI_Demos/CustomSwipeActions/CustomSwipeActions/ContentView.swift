//
//  ContentView.swift
//  CustomSwipeActions
//
//  Created by Lurich on 2023/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    ContentView()
}
