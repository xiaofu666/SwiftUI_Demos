//
//  ContentView.swift
//  AutoScrollCarousel
//
//  Created by Xiaofu666 on 2024/9/29.
//

import SwiftUI

struct Item: Identifiable {
    var id: String = UUID().uuidString
    var color: Color
}

var mockItems: [Item] = [
    .init(color: .red),
    .init(color: .orange),
    .init(color: .blue),
    .init(color: .yellow),
    .init(color: .green),
    .init(color: .cyan),
    .init(color: .purple)
]

struct ContentView: View {
    @State private var activePage: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomCarousel(activeIndex: $activePage) {
                    ForEach(mockItems) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    }
                }
                .frame(height: 220)
                
                HStack(spacing: 5) {
                    ForEach(mockItems.indices, id: \.self) { index in
                        Circle()
                            .fill(activePage == index ? .primary : .secondary)
                            .frame(width: 8)
                    }
                }
                .animation(.snappy(duration: 0.3), value: activePage)
            }
            .navigationTitle("Auto Scroll Carousel")
        }
    }
}

#Preview {
    ContentView()
}
