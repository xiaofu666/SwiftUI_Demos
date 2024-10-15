//
//  Home.swift
//  DragToSelect
//
//  Created by Xiaofu666 on 2024/10/13.
//

import SwiftUI

struct Home: View {
    @State private var items: [Item] = []
    @State private var isSelectionEnabled: Bool = false
    @State private var panGesture: UIPanGestureRecognizer?
    @State private var properties: SelectionProperties = .init()
    @State private var scrollProperties: ScrollProperties = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                Text("Grid View")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .trailing) {
                        Button(isSelectionEnabled ? "Cancel" : "Select") {
                            isSelectionEnabled.toggle()
                            
                            if !isSelectionEnabled {
                                properties = .init()
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    }
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 4), spacing: 10) {
                    ForEach($items) { $item in
                        ItemCardView($item)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding(15)
        .scrollPosition($scrollProperties.position)
        .overlay(alignment: .top) {
            ScrollDetectionRegion()
        }
        .overlay(alignment: .bottom) {
            ScrollDetectionRegion(false)
        }
        .onAppear(perform: createSampleData)
        .onChange(of: isSelectionEnabled) { oldValue, newValue in
            panGesture?.isEnabled = newValue
        }
        .onScrollGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.contentOffset.y + proxy.contentInsets.top
        }, action: { oldValue, newValue in
            scrollProperties.currentScrollOffset = newValue
        })
        .onChange(of: scrollProperties.direction) { oldValue, newValue in
            if newValue != .none {
                guard scrollProperties.timer == nil else { return }
                scrollProperties.manualScrollOffset = scrollProperties.currentScrollOffset
                scrollProperties.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                    if newValue == .up {
                        scrollProperties.manualScrollOffset -= 3
                    }
                    if newValue == .down {
                        scrollProperties.manualScrollOffset += 3
                    }
                    scrollProperties.position.scrollTo(y: scrollProperties.manualScrollOffset)
                })
                scrollProperties.timer?.fire()
            } else {
                resetTimer()
            }
        }
        .gesture(
            PanGesture { gesture in
                if panGesture == nil {
                    panGesture = gesture
                    gesture.isEnabled = isSelectionEnabled
                }
                let state = gesture.state
                if state == .began || state == .changed {
                    onGestureChange(gesture)
                } else {
                    onGestureEnded(gesture)
                }
            }
        )
    }
    
    func onGestureChange(_ gesture: UIPanGestureRecognizer) {
        let position = gesture.location(in: gesture.view)
        if let fallingIndex = items.firstIndex(where: { $0.location.contains(position) }) {
            if properties.start == nil {
                properties.start = fallingIndex
                properties.isDeleteDrag = properties.previousIndices.contains(fallingIndex)
            }
            properties.end = fallingIndex
            
            if let start = properties.start, let end = properties.end {
                let indices = (start > end ? end...start : start...end).compactMap({ $0 })
                if properties.isDeleteDrag {
                    properties.toBeDeleteIndices = Set(properties.previousIndices).intersection(indices).compactMap({ $0 })
                } else {
                    properties.selectedIndices = Set(properties.previousIndices).union(indices).compactMap({ $0 })
                }
            }
            
            scrollProperties.direction = scrollProperties.topRegion.contains(position) ? .up : scrollProperties.bottomRegion.contains(position) ? .down : .none
        }
    }
    
    func onGestureEnded(_ gesture: UIPanGestureRecognizer) {
        for index in properties.toBeDeleteIndices {
            properties.selectedIndices.removeAll(where: { index == $0 })
        }
        properties.toBeDeleteIndices = []
        properties.previousIndices = properties.selectedIndices
        properties.start = nil
        properties.end = nil
        properties.isDeleteDrag = false
        
        resetTimer()
    }
    
    @ViewBuilder
    func ItemCardView(_ bidding: Binding<Item>) -> some View {
        let item = bidding.wrappedValue
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(item.color.gradient)
                .frame(height: 80)
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .global)
                } action: { newValue in
                    bidding.wrappedValue.location = newValue
                }
                .overlay(alignment: .topTrailing) {
                    if properties.selectedIndices.contains(index) && !properties.toBeDeleteIndices.contains(index) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white, .black)
                            .padding(5)
                    }
                }
                .overlay {
                    if isSelectionEnabled {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.clear)
                            .contentShape(.rect)
                            .onTapGesture {
                                if properties.selectedIndices.contains(index) {
                                    properties.selectedIndices.removeAll(where: { $0 == index })
                                } else {
                                    properties.selectedIndices.append(index)
                                }
                                properties.previousIndices = properties.selectedIndices
                            }
                            .transition(.identity)
                    }
                }
        }
    }
    
    @ViewBuilder
    func ScrollDetectionRegion(_ isTop: Bool = true) -> some View {
        Rectangle()
            .foregroundStyle(.clear)
            .frame(height: 100)
            .ignoresSafeArea()
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                if isTop {
                    scrollProperties.topRegion = newValue
                } else {
                    scrollProperties.bottomRegion = newValue
                }
            }

    }
    
    private func resetTimer() {
        scrollProperties.manualScrollOffset = 0
        scrollProperties.timer?.invalidate()
        scrollProperties.timer = nil
        scrollProperties.direction = .none
    }
    
    private func createSampleData() {
        guard items.isEmpty else { return }
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .cyan, .purple, .teal, .brown, .pink]
        for _ in 1...4 {
            let sampleItems = colors.shuffled().compactMap({ Item(color: $0) })
            items.append(contentsOf: sampleItems)
        }
    }
    
    struct SelectionProperties {
        var start: Int?
        var end: Int?
        var selectedIndices: [Int] = []
        var previousIndices: [Int] = []
        var toBeDeleteIndices: [Int] = []
        var isDeleteDrag: Bool = false
    }
    
    struct ScrollProperties {
        var position: ScrollPosition = .init()
        var currentScrollOffset: CGFloat = 0
        var manualScrollOffset: CGFloat = 0
        var timer: Timer?
        var direction: ScrollDirection = .none
        var topRegion: CGRect = .zero
        var bottomRegion: CGRect = .zero
    }
    
    enum ScrollDirection {
        case up
        case down
        case none
    }
}

struct PanGesture: UIGestureRecognizerRepresentable {
    var handle: (UIPanGestureRecognizer) -> ()
    func makeUIGestureRecognizer(context: Context) -> some UIPanGestureRecognizer {
        return UIPanGestureRecognizer()
    }
    func updateUIGestureRecognizer(_ recognizer: UIGestureRecognizerType, context: Context) {
        
    }
    func handleUIGestureRecognizerAction(_ recognizer: UIGestureRecognizerType, context: Context) {
        handle(recognizer)
    }
}

#Preview {
    Home()
}
