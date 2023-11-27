//
//  ContentView.swift
//  InfiniteView
//
//  Created by Lurich on 2023/11/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Looping ScrollView")
        }
    }
}

#Preview {
    ContentView()
}
