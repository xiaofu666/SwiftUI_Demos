//
//  CustomSegmentedControl.swift
//  CamBottomControl
//
//  Created by Xiaofu666 on 2025/7/15.
//

import SwiftUI

// Segmented Tab Model
struct SegmentedTab: Identifiable {
    var id: Int
    var title: String
    var size: CGSize = .zero
}

struct CustomSegmentedControl: View {
    var initialIndex: Int
    var horizontalPadding: CGFloat
    @Binding var tabs: [SegmentedTab]
    var onTabSelection: (Int) -> ()
    var gestureStatus: (Bool) -> () = { _ in }
    // View Properties
    @State private var activeIndex: Int?
    @State private var centerPadding: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var lastDrag: CGFloat?
    @GestureState private var isActive: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach($tabs) { $tab in
                        Text(tab.title)
                            .foregroundStyle(activeIndex == tab.id ? .clear : .white)
                            .padding(.horizontal, 15)
                            .frame(height: 45)
                            .frame(maxHeight: .infinity)
                            .onGeometryChange(for: CGSize.self) {
                                $0.size
                            } action: { newValue in
                                tab.size = newValue
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (size.width - centerPadding) / 2)
            .scrollPosition(id: $activeIndex, anchor: .center)
            .scrollDisabled(true)
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .background {
                Capsule()
                    .fill(.gray.opacity(0.3))
                    .padding(.horizontal, isActive ? -horizontalPadding : 0)
            }
            .mask {
                Capsule()
                    .padding(.horizontal, isActive ? -horizontalPadding : 0)
            }
            .animation(.interpolatingSpring(duration: 0.3), value: isActive)
            
            // Option: 1
//            if let activeIndex {
//                Text(tabs[activeIndex].title)
//                    .foregroundStyle(.yellow)
//                    .padding(.horizontal, 15)
//                    .frame(height: 45)
//                    .glassEffect()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                    .allowsTightening(false)
//            }
            
            // Option: 2
            IndicatorScrollView(size)
                .frame(width: centerPadding)
                .clipShape(.capsule)
                .glassEffect()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sensoryFeedback(.selection, trigger: activeIndex)
        }
        .frame(height:50)
        .contentShape(.rect)
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isActive) { _, out, _ in
                    out = true
                }
                .onChanged { value in
                    if let lastDrag {
                        let xOffset = value.translation.width + lastDrag
                        dragOffset = xOffset
                        let index = Int(dragOffset / 50)
                        let cappedIndex = max(0, min(tabs.count-1, index))
                        guard activeIndex != cappedIndex else { return }
                        
                        withAnimation(.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0)) {
                            activeIndex = cappedIndex
                            centerPadding = tabs[cappedIndex].size.width
                        }
                        onTabSelection(cappedIndex)
                    } else {
                        lastDrag = dragOffset
                    }
                }
                .onEnded { value in
                    lastDrag = nil
                    if activeIndex == 0 {
                        dragOffset = 0
                    }
                    
                    if activeIndex == tabs.count - 1 {
                        dragOffset = CGFloat((tabs.count - 1) * 50) + 25
                    }
                }
        )
        .onChange(of: isActive) { oldValue, newValue in
            withAnimation(.interpolatingSpring(duration: 0.3)) {
                gestureStatus(newValue)
            }
        }
        .task {
            guard activeIndex == nil else { return }
            setupInitialIndex()
        }
    }
    
    @ViewBuilder
    func IndicatorScrollView(_ size: CGSize) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach($tabs) { $tab in
                    Text(tab.title)
                        .foregroundStyle(.yellow)
                        .padding(.horizontal, 15)
                        .frame(height: 45)
                        .frame(maxHeight: .infinity)
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action: { newValue in
                            tab.size = newValue
                        }
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding(.horizontal, (size.width - centerPadding) / 2)
        .scrollPosition(id: $activeIndex, anchor: .center)
        .scrollDisabled(true)
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
    }

    
    private func setupInitialIndex() {
        activeIndex = initialIndex
        centerPadding = tabs[initialIndex].size.width
        dragOffset = CGFloat(initialIndex * 50) + 25
    }
}

#Preview {
    ContentView()
}
