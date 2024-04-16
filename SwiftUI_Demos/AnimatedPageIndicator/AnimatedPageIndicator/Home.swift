//
//  Home.swift
//  AnimatedPageIndicator
//
//  Created by Lurich on 2024/1/3.
//

import SwiftUI

struct Home: View {
    @State private var colors: [Color] = [.red, .blue, .green, .yellow]
    @State private var opacityEffect: Bool = false
    @State private var clipEdges: Bool = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(color.gradient)
                            .padding(.horizontal, 15)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .overlay(alignment: .bottom) {
                    PagingIndicator(
                        activeTint: .white,
                        inActiveTint: .black.opacity(0.25),
                        opacityEffect: opacityEffect,
                        clipEdges: clipEdges,
                        circleWidth: 8,
                        activeCapsuleWidth: 18
                    )
                }
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .frame(height: 220)
            .padding(.top, 5)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(color.gradient)
                            .padding(.horizontal, 5)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
                .overlay(alignment: .bottom) {
                    PagingIndicator(
                        activeTint: .white,
                        inActiveTint: .black.opacity(0.25),
                        opacityEffect: opacityEffect,
                        clipEdges: clipEdges,
                        circleWidth: 8,
                        activeCapsuleWidth: 18
                    )
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .frame(height: 200)
            .safeAreaPadding(.vertical, 5)
            .safeAreaPadding(.horizontal, 25)
            
            List {
                Section {
                    Toggle("Opacity Effect", isOn: $opacityEffect)
                    
                    Toggle("Clip Edges", isOn: $clipEdges)
                    
                    Button("Add Item") {
                        colors.append(.purple)
                    }
                } header: {
                    Text("Options")
                }

            }
            .clipShape(.rect(cornerRadius: 0))
            .padding(0)
        }
        .navigationTitle("Custom Indicator")
    }
}

#Preview {
    ContentView()
}
