//
//  ContentView.swift
//  ExpandableSearchBar
//
//  Created by Lurich on 2024/4/28.
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
