//
//  ContentView.swift
//  Coverflow
//
//  Created by Lurich on 2024/1/14.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [CoverFlowItem] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple].compactMap { color in
        return .init(color: color)
    }
    @State private var spacing: CGFloat = 0
    @State private var rotation: Double = .zero
    @State private var enableReflection: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 0)
                
                CoverFlowView(
                    itemWidth: 280,
                    enableReflection: enableReflection,
                    spacing: spacing,
                    rotation: rotation,
                    items: items
                ) { item in
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(item.color.gradient)
                }
                .frame(height: 180)
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Toggle("Toggle Reflection", isOn: $enableReflection)
                    
                    Text("Card Spacing")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Slider(value: $spacing, in: -120...20)
                    
                    Text("Card Rotation")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Slider(value: $rotation, in: 0...90)
                })
                .padding(15)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .padding(15)
            }
            .navigationTitle("CoverFlow")
        }
    }
}

#Preview {
    ContentView()
}
