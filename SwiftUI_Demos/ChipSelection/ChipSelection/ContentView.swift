//
//  ContentView.swift
//  ChipSelection
//
//  Created by Xiaofu666 on 2025/3/11.
//

import SwiftUI

let tags: [String] = [
    "iOS 14",
    "SwiftUI",
    "macOS",
    "watchOS",
    "tvOS",
    "Xcode",
    "macCatalyst",
    "UIKit",
    "AppKit",
    "Cocoa",
    "Objective-C"
]

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ChipsView(tags: tags) { tag, isSelected in
                    ChipView(tag, isSelected: isSelected)
                } didChangeSelection: { selections in
                    print(selections)
                }
                .padding(10)
                .background(.gray.opacity(0.1), in: .rect(cornerRadius: 20))
            }
            .padding(15)
            .navigationTitle("Chips Selection")
        }
    }
    
    @ViewBuilder
    func ChipView(_ tag: String, isSelected: Bool) -> some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.callout)
                .foregroundStyle(isSelected ? .white : Color.primary)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            ZStack {
                Capsule()
                    .fill(.background)
                    .opacity(!isSelected ? 1 : 0)
                
                Capsule()
                    .fill(.green.gradient)
                    .opacity(isSelected ? 1 : 0)
            }
        }
    }
}

#Preview {
    ContentView()
}
