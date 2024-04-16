//
//  CustomSlider.swift
//  StretchySlider
//
//  Created by Lurich on 2024/2/19.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var sliderProgress: CGFloat
    var symbol: Symbol?
    var axis: SliderAxis
    var tint: Color
    
    @State private var progress: CGFloat = .zero
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader(content: {
            geometry in
            let size = geometry.size
            let orientationSize = axis == .horizontal ? size.width : size.height
            let progressValue = max(progress, .zero) * orientationSize
            
            ZStack(alignment: axis == .vertical ? .bottom : .leading,
                   content: {
                Rectangle()
                    .fill(.fill)
                Rectangle()
                    .fill(tint)
                    .frame(
                        width: axis == .horizontal ? progressValue : nil,
                        height: axis == .vertical ? progressValue : nil
                    )
                
                if let symbol, symbol.display {
                    Image(systemName: symbol.icon)
                        .font(symbol.font)
                        .foregroundStyle(symbol.tint)
                        .padding(symbol.padding)
                        .frame(width: size.width, height: size.height, alignment: symbol.alignment)
                }
            })
            .clipShape(.rect(cornerRadius: 15))
            .contentShape(.rect(cornerRadius: 15))
            .frame(
                width: axis == .horizontal && progress < 0 ? size.width + (
                    -progress * size.width
                ) : nil,
                height: axis == .vertical && progress < 0 ? size.height + (
                    -progress * size.height
                ) : nil
            )
            .scaleEffect(
                x: axis == .vertical ? (
                    progress > 1 ? (
                        1 - (progress - 1) * 0.25
                    ) : (
                        progress < 0 ? (1 + progress * 0.25) : 1
                    )
                ) : 1 ,
                y: axis == .horizontal ? (
                    progress > 1 ? (
                        1 - (progress - 1) * 0.25
                    ) : (
                        progress < 0 ? (1 + progress * 0.25) : 1
                    )
                ) : 1,
                anchor: axis == .horizontal ? (progress < 0 ? .trailing : .leading) : (progress < 0 ? .top : .bottom)
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        let translation = value.translation
                        let movement = (axis == .horizontal ? translation.width : -translation.height) + lastDragOffset
                        dragOffset = movement
                        calculateProgress(orientationSize: orientationSize)
                    })
                    .onEnded({ _ in
                        withAnimation(.smooth, {
                            dragOffset = (dragOffset > orientationSize ? orientationSize : (dragOffset < 0 ? 0 : dragOffset))
                            calculateProgress(orientationSize: orientationSize)
                        })
                        lastDragOffset = dragOffset
                    })
            )
            .frame(
                maxWidth: size.width,
                maxHeight: size.height,
                alignment: axis == .horizontal ? (progress < 0 ? .trailing : .leading) : (progress < 0 ? .top : .bottom)
            )
            .onChange(of: sliderProgress, initial: true) { oldValue, newValue in
                guard sliderProgress != progress, (sliderProgress > 0 && sliderProgress < 1) else { return }
                progress = max(min(sliderProgress, 1.0), 0.0)
                dragOffset = progress * orientationSize
                lastDragOffset = dragOffset
            }
            .onChange(of: axis) { oldValue, newValue in
                dragOffset = progress * orientationSize
                lastDragOffset = dragOffset
            }
        })
        .onChange(of: progress, initial: true) { oldValue, newValue in
            sliderProgress = max(min(progress, 1.0), 0.0)
        }
    }
    
    private func calculateProgress(orientationSize: CGFloat) {
        let topAndTrailingExcessOffset = orientationSize + (dragOffset - orientationSize) * 0.15
        let bottomAndLeadingExcessOffset = dragOffset < 0 ? dragOffset * 0.15 : dragOffset
        let progress = (dragOffset > orientationSize ? topAndTrailingExcessOffset : bottomAndLeadingExcessOffset) / orientationSize
        self.progress = progress
    }
    
    struct Symbol {
        var icon: String
        var tint: Color
        var font: Font
        var padding:CGFloat
        var display: Bool = true
        var alignment: Alignment = .center
    }
    enum SliderAxis {
        case vertical
        case horizontal
    }

}

#Preview {
    ContentView()
}
