//
//  ContentView.swift
//  ExpandableSlider
//
//  Created by Xiaofu666 on 2024/11/10.
//

import SwiftUI

struct ContentView: View {
    @State private var volume: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomSlider(value: $volume, in: 0...100) {
                    HStack {
                        Image(systemName: "speaker.wave.3.fill", variableValue: volume / 100)
                        
                        Spacer(minLength: 0)
                        
                        Text(String(format: "%.1f", volume) + "%")
                            .font(.callout)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(15)
            }
            .navigationTitle("Expandable Slider")
        }
    }
}

#Preview {
    ContentView()
}
