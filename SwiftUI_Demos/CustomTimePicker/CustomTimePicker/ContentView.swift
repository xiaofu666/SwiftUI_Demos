//
//  ContentView.swift
//  CustomTimePicker
//
//  Created by Lurich on 2024/6/29.
//

import SwiftUI

struct ContentView: View {
    @State private var hour: Int = 10
    @State private var minutes: Int = 20
    @State private var seconds: Int = 30
    
    var body: some View {
        NavigationStack {
            VStack {
                TimePicker(style: .init(.ultraThinMaterial), hour: $hour, minutes: $minutes, seconds: $seconds)
                    .padding(10)
                    .background() {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                    }
            }
            .navigationTitle("Custom Time Picker")
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.5))
        }
    }
}

#Preview {
    ContentView()
}
