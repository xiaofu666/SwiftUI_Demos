//
//  RadialView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/25.
//

import SwiftUI

struct RadialHomeView: View {
    @State private var colors: [ColorValue] = [.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint].compactMap { color -> ColorValue? in
        return .init(color: color)
    }
    @State private var activeIndex: Int = 0
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                Spacer()
                
                RadialLayout(items: colors, keyPathID: \.id, spacing: 220) { value, index, size in
                    Circle()
                        .fill(value.color.gradient)
                        .overlay {
                            Text("\(index)")
                        }
                } onIndexChange: { index in
                    activeIndex = index
                }
                .padding(.horizontal, -100)
                .frame(width: geometry.size.width, height: geometry.size.width / 2)
                .overlay {
                    Text("\(activeIndex)")
                        .font(.largeTitle.bold())
                        .offset(y: 70)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .padding(15)
        .navigationTitle("Redial Layout")
    }
}

struct ColorValue: Identifiable {
    var id: UUID = .init()
    var color: Color
}

struct RadialLayout<Content: View, Item: RandomAccessCollection, ID: Hashable>: View where Item.Element: Identifiable {
    var content: (Item.Element, Int, CGFloat) -> Content
    var keyPathID: KeyPath<Item.Element, ID>
    var items: Item
    var spacing: CGFloat?
    var onIndexChange: (Int) -> ()
    
    init(items: Item, keyPathID: KeyPath<Item.Element, ID>, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (Item.Element, Int, CGFloat) -> Content, onIndexChange: @escaping (Int) -> Void) {
        self.content = content
        self.keyPathID = keyPathID
        self.items = items
        self.spacing = spacing
        self.onIndexChange = onIndexChange
    }
    
    @State private var dragRotation: Angle = .zero
    @State private var lastDragRotation: Angle = .zero
    @State private var activeIndex: Int = 0
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let width = size.width
            let count = CGFloat(items.count)
            let spacing = spacing ?? 0
            let viewSize = (width - spacing) / (count / 2)
            
            ZStack {
                ForEach(items, id: keyPathID) { item in
                    let index = fetchIndex(item)
                    let rotation = (CGFloat(index) / count) * 360.0
                    
                    content(item, index, viewSize)
                        .rotationEffect(.degrees(90))
                        .rotationEffect(.degrees(-rotation))
                        .rotationEffect(-dragRotation)
                        .frame(width: viewSize, height: viewSize)
                        .offset(x: (width - viewSize) / 2.0)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(rotation))
                }
            }
            .frame(width: width, height: width)
            .contentShape(.rect)
            .rotationEffect(dragRotation)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationX = value.translation.width
                        let progress = translationX / (viewSize * 2)
                        let rotationFraction = 360.0 / count
                        dragRotation = .degrees(rotationFraction * progress) + lastDragRotation
                        calculateIndex(count)
                    })
                    .onEnded({ value in
                        let velocityX = value.velocity.width / 15
                        let translationX = value.translation.width + velocityX
                        let progress = (translationX / (viewSize * 2)).rounded()
                        let rotationFraction = 360.0 / count
                        withAnimation(.smooth) {
                            dragRotation = .degrees(rotationFraction * progress) + lastDragRotation
                        }
                        lastDragRotation = dragRotation
                        calculateIndex(count)
                    })
            )
        })
    }
    
    func calculateIndex(_ count: CGFloat) {
        var activeIndex = (dragRotation.degrees / 360.0 * count).rounded().truncatingRemainder(dividingBy: count)
        activeIndex = activeIndex == 0 ? 0 : (activeIndex < 0 ? -activeIndex : (count - activeIndex))
        self.activeIndex = Int(activeIndex)
        onIndexChange(self.activeIndex)
    }
    
    func fetchIndex(_ item: Item.Element) -> Int {
        return items.firstIndex(where: { $0.id == item.id }) as? Int ?? 0
    }
}
    
#Preview {
    NavigationStack {
        RadialHomeView()
    }
}

