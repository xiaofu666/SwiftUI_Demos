//
//  ResizableHeaderScrollView.swift
//  ResizableHeaderScroll
//
//  Created by Xiaofu666 on 2025/5/18.
//

import SwiftUI

struct ResizableHeViewScrollView<Header: View, StickyHeader: View, Background: View, Content: View>: View {
    var spacing: CGFloat = 10
    @ViewBuilder var header: Header
    @ViewBuilder var stickyHeader: StickyHeader
    // 仅用于标题背景，不用于整个视图
    @ViewBuilder var background: Background
    @ViewBuilder var content: Content
    
    @State private var currentDragOffset: CGFloat = 0
    @State private var previousDragOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var headerSize: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            content
        }
        .frame(maxWidth: .infinity)
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentOffset.y + $0.contentInsets.top
        }, action: { oldValue, newValue in
            scrollOffset = newValue
        })
        .simultaneousGesture(
            DragGesture(minimumDistance:10)
                .onChanged { value in
                    // 调整最小距离值
                    // 因此它从0开始。
                    let dragOffset = -max(0, abs(value.translation.height) - 50) * (value.translation.height < 0 ? -1 : 1)
                    previousDragOffset = currentDragOffset
                    currentDragOffset = dragOffset
                    let deltaOffset = (currentDragOffset - previousDragOffset).rounded()
                    headerOffset = max(min(headerOffset + deltaOffset, headerSize), 0)
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        if headerOffset > (headerSize * 0.5) && scrollOffset > headerSize {
                            headerOffset = headerSize
                        } else {
                            headerOffset = 0
                        }
                    }
                    // 重置偏移数据
                    currentDragOffset = 0
                    previousDragOffset = 0
                }
        )
        .safeAreaInset(edge:.top,spacing: spacing) {
            CombinedHeaderView()
        }
    }
    
    @ViewBuilder
    private func CombinedHeaderView() -> some View {
        VStack(spacing: spacing) {
            header
                .onGeometryChange(for: CGFloat.self) {
                    $0.size.height
                } action: { newValue in
                    headerSize = newValue + spacing
                }
            
            stickyHeader
        }
        .offset(y: -headerOffset)
        .clipped()
        .background {
            background
                .ignoresSafeArea()
                .offset(y: -headerOffset)
        }
    }
}

#Preview {
    ContentView()
}
