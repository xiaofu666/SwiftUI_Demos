//
//  ContentView.swift
//  ScrollInteraction
//
//  Created by Xiaofu666 on 2024/10/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 20) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(images) { item in
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150)
                                .clipShape(.rect(cornerRadius: 25))
                                .scrollTransition(.interactive, axis: .horizontal) { context, phase in
                                    context
                                        .blur(radius: phase == .identity ? 0 : 2, opaque: false)
                                        .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                                        .offset(y: phase == .identity ? 0 : 20)
                                        .rotationEffect(.degrees(phase == .identity ? 0 : phase.value * 15), anchor: .bottom)
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollClipDisabled()
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                .safeAreaPadding(.horizontal, (size.width - 150) / 2)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 15) {
                        ForEach(images) { item in
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150 + 60)
                                .scrollTransition(.interactive, axis: .horizontal) { context, phase in
                                    context
                                        .offset(x: phase == .identity ? 0 : -phase.value * 60)
                                }
                                .frame(width: 150, height: 240)
                                .clipShape(.rect(cornerRadius: 15))
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                .safeAreaPadding(.horizontal, (size.width - 150) / 2)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(images) { item in
                            let index = Double(images.firstIndex(where: { $0.id == item.id }) ?? 0)
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Image(item.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150)
                                    .clipShape(.rect(cornerRadius: 25))
                                    .scrollTransition(.interactive, axis: .horizontal) { context, phase in
                                        context
                                            .blur(radius: phase == .identity ? 0 : 2, opaque: false)
                                            .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                                            .offset(y: phase == .identity ? 0 : -10)
                                            .rotationEffect(.degrees(phase == .identity ? 0 : phase.value * 5), anchor: .bottomTrailing)
                                            .offset(x: minX < 0 ? minX / 2 : -minX)
                                    }
                            }
                            .frame(width: 150)
                            .zIndex(-index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollClipDisabled()
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                .safeAreaPadding(.horizontal, (size.width - 150) / 2)
            }
            .padding(.vertical, 10)
            .scrollClipDisabled()
        }
    }
}

#Preview {
    ContentView()
}

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var image: String
}

var images: [ImageModel] = (0...8).map({ ImageModel(image: "Profile \($0)") })

