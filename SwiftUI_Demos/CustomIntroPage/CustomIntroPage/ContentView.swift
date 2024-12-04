//
//  ContentView.swift
//  CustomIntroPage
//
//  Created by Xiaofu666 on 2024/12/4.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedItem: Item = items.first!
    @State private var introItems: [Item] = items
    @State private var activeIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                updateItem(isForward: false)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(.green.gradient)
                    .contentShape(.rect)
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(selectedItem.id != items.first?.id ? 1 : 0)
            
            ZStack {
                ForEach(introItems) { item in
                    AnimatedIconView(item)
                }
            }
            .frame(height: 250)
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    ForEach(introItems) { item in
                        Capsule()
                            .fill(selectedItem.id == item.id ? Color.primary : .gray)
                            .frame(width: selectedItem.id == item.id ? 8 : 4)
                            .frame(height: 4)
                        
                    }
                }
                .padding(.bottom, 15)
                
                Text(selectedItem.title)
                    .font(.title.bold())
                    .contentTransition(.numericText())
                
                Text("This is simply dummy text.")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                Button {
                    updateItem(isForward: true)
                } label: {
                    Text(selectedItem.id == items.last?.id ? "Continue" : "Next")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .frame(width: 250)
                        .padding(.vertical, 12)
                        .background(.green.gradient, in: .capsule)
                }
                .padding(.top, 25)
            }
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .frame(maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    func AnimatedIconView(_ item: Item) -> some View {
        let isSelected = selectedItem.id == item.id
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.gradient.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(.green.gradient, in: .rect(cornerRadius: 35))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.background)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: 1, y: 1)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: -1, y: -1)
                    .padding(-3)
                    .opacity(isSelected ? 1 : 0)
            }
            .rotationEffect(.degrees(-item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x: item.offset)
            .rotationEffect(.degrees(item.rotation))
            .zIndex(isSelected ? 2 : item.zIndex)
    }
    
    func updateItem(isForward: Bool) {
        var fromIndex: Int
        if isForward {
            guard activeIndex != introItems.count - 1 else { return }
            activeIndex += 1
            fromIndex = activeIndex - 1
        } else {
            guard activeIndex != 0 else { return }
            activeIndex -= 1
            fromIndex = activeIndex + 1
        }
        let extraOffset = introItems[activeIndex].extraOffset
        for index in introItems.indices {
            introItems[index].zIndex = 0
        }
        Task {
            withAnimation(.bouncy(duration: 1.0)) {
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].offset = introItems[activeIndex].offset
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                
                introItems[activeIndex].offset = extraOffset
                introItems[fromIndex].zIndex = 1
            }
            
            try? await Task.sleep(for: .seconds(0.09))
            
            withAnimation(.bouncy(duration: 1.0)) {
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].offset = .zero
                introItems[activeIndex].anchor = .center
                
                
                selectedItem = introItems[activeIndex]
            }
        }
    }
}

#Preview {
    ContentView()
}
