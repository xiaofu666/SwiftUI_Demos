//
//  ContentView.swift
//  MinimalTodo
//
//  Created by Lurich on 2024/2/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Todo List")
                .modelContainer(for: Todo.self)
        }
    }
}

#Preview {
    ContentView()
}
