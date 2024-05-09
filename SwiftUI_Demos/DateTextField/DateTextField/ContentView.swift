//
//  ContentView.swift
//  DateTextField
//
//  Created by Lurich on 2024/5/8.
//

import SwiftUI

struct ContentView: View {
    @State private var date: Date = .now
    
    var body: some View {
        NavigationStack {
            DateTextField(date: $date) { date in
                return date.formatted()
            }
            .frame(width: 150)
            .navigationTitle("Date Picker TextField")
        }
    }
}

#Preview {
    ContentView()
}
