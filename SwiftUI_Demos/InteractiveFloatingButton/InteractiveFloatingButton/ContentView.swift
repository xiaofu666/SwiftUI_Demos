//
//  ContentView.swift
//  InteractiveFloatingButton
//
//  Created by Lurich on 2024/4/8.
//

import SwiftUI

struct ContentView: View {
    @State private var colors: [Color] = [
        .red, .blue, .green, .yellow, .cyan, .brown, .purple, .indigo, .mint, .pink
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(color.gradient)
                            .frame(height: 200)
                    }
                }
                .padding()
            }
            .navigationTitle("Floating Button")
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingButton {
                FloatingAction(symbol: "tray.full.fill") {
                    print("Tray")
                }
                FloatingAction(symbol: "lasso.badge.sparkles") {
                    print("Spark")
                }
                FloatingAction(symbol: "square.and.arrow.up.fill") {
                    print("Share")
                }
            } label: { isExpanded in
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .scaleEffect(1.1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black, in: .circle)
                    .scaleEffect(isExpanded ? 0.9 : 1)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
