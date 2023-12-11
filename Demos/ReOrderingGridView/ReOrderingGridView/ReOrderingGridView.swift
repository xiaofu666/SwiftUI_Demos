//
//  ReOrderingGridView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/3.
//

import SwiftUI

struct ReOrderingGridView: View {
    @State private var colors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown, .white, .gray, .black]
    @State private var draggingItem: Color?
    
    var body: some View {
        ScrollView(.vertical) {
            let column = Array(repeating: GridItem(spacing: 10), count: 3)
            LazyVGrid(columns: column, spacing: 10, content: {
                ForEach(colors, id: \.self) { color in
                    GeometryReader(content: { geometry in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(color)
                            .draggable(color) {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 1, height: 1)
                                    .onAppear() {
                                        draggingItem = color
                                    }
                            }
                            .dropDestination(for: Color.self) { items, location in
                                draggingItem = nil
                                return false
                            } isTargeted: { status in
                                if let draggingItem, status, draggingItem != color {
                                    if let sourceIndex = colors.firstIndex(of: draggingItem), let destinationIndex = colors.firstIndex(of: color) {
                                        withAnimation(.bouncy) {
                                            let sourceItem = colors.remove(at: sourceIndex)
                                            colors.insert(sourceItem, at: destinationIndex)
                                        }
                                    }
                                }
                            }
                    })
                    .frame(height: 100)
                }
            })
            .padding()
        }
        .background(.primary.opacity(0.1))
        .navigationTitle("Movable Grid")
    }
}

#Preview {
    ReOrderingGridView()
}
