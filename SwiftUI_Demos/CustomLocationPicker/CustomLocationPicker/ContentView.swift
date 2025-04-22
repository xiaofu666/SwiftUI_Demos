//
//  ContentView.swift
//  CustomLocationPicker
//
//  Created by Xiaofu666 on 2025/4/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Pick a Location") {
                    showPicker.toggle()
                }
                .locationPicker(isPresented: $showPicker) { coordinates in
                    if let coordinates {
                        print(coordinates)
                    }
                }
            }
            .navigationTitle("Custom Location Picker")
        }
    }
}

#Preview {
    ContentView()
}
