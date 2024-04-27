//
//  RangeSliderView.swift
//  RangeSlider
//
//  Created by Lurich on 2024/4/27.
//

import SwiftUI

struct RangeSliderView: View {
    @Binding var selection: ClosedRange<CGFloat>
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .primary
    
    @State private var slider1: GestureProperties = .init()
    @State private var slider2: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    @State private var isInitial: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            let maxSliderWidth = reader.size.width - 30
            let minDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(tint.tertiary)
                    .frame(height: 5)
                
                HStack(spacing: 0) {
                    Circle()
                        .fill(tint)
                        .frame(width: 15)
                        .contentShape(.circle)
                        .offset(x: slider1.offset)
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(tint)
                                .frame(width: indicatorWidth, height: 5)
                                .offset(x: 15)
                                .offset(x: slider1.offset)
                                .allowsHitTesting(false)
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    var translation = value.translation.width + slider1.lastOffset
                                    translation = min(max(translation, 0), slider2.offset - minDistance)
                                    slider1.offset = translation
                                    
                                    calculateNewRange(reader.size)
                                }
                                .onEnded { _ in
                                    slider1.lastOffset = slider1.offset
                                }
                        )
                    
                    Circle()
                        .fill(tint)
                        .frame(width: 15)
                        .contentShape(.circle)
                        .offset(x: slider2.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    var translation = value.translation.width + slider2.lastOffset
                                    translation = min(max(translation, slider1.offset + minDistance), maxSliderWidth)
                                    slider2.offset = translation
                                    
                                    calculateNewRange(reader.size)
                                }
                                .onEnded { _ in
                                    slider2.lastOffset = slider2.offset
                                }
                        )
                }
                .frame(maxHeight: .infinity)
                .task {
                    guard !isInitial else { return }
                    isInitial = true
                    try? await Task.sleep(for: .seconds(0))
                    let maxWidth = reader.size.width - 30
                    let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                    let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                    
                    slider1.offset = start
                    slider1.lastOffset = start
                    slider2.offset = end
                    slider2.lastOffset = end
                    calculateNewRange(reader.size)
                }
            }
            .frame(height: 20)
        }
    }
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset
        
        let maxWidth = size.width - 30
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        selection = newRangeStart...newRangeEnd
    }
    
    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastOffset: CGFloat = 0
    }
}

/// 插值算法
extension CGFloat {
    func interpolate(inputRange:[CGFloat], outputRange:[CGFloat]) -> CGFloat {
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0]{ return outputRange[0] }
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            /// 线性插值公式: y1 + ((y2-y1) / (x2-x1)) *(x-x1)
            if x <= inputRange[index] {
                let y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
                return y
            }
        }
        return outputRange[length]
    }
}


#Preview {
    ContentView()
}
