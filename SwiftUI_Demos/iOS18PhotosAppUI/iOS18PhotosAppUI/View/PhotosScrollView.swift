//
//  PhotosScrollView.swift
//  iOS18PhotosAppUI
//
//  Created by Xiaofu666 on 2024/7/21.
//

import SwiftUI

struct PhotosScrollView: View {
    let size: CGSize
    let safeArea: EdgeInsets
    @Environment(ShareData.self) private var shareData
    @State private var position: ScrollPosition  = .init()
    
    var body: some View {
        let screenHeight = size.height + safeArea.top + safeArea.bottom
        let minimizedHeight = screenHeight * 0.4
        
        ScrollView(.horizontal) {
            LazyHStack(alignment: .bottom, spacing: 0) {
                Group {
                    StretchableView(.teal)
                        .id(1)
                    
                    StretchableView(.blue)
                        .id(2)
                }
                .frame(height: screenHeight - minimizedHeight)
                
                GridPhotosScrollView()
                    .frame(width: size.width)
                    .id(3)
                
                Group {
                    StretchableView(.yellow)
                        .id(4)
                    
                    StretchableView(.green)
                        .id(5)
                }
                .frame(height: screenHeight - minimizedHeight)
            }
            .clipped()
            .safeAreaPadding(.bottom, safeArea.bottom + 10)
            .scrollTargetLayout()
        }
        .offset(y: shareData.canPullUp ? shareData.photosScreenOffset : 0)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: .init(get: {
            return shareData.activePage
        }, set: { newValue in
            if let index = newValue {
                shareData.activePage = index
            }
        }))
        .scrollDisabled(shareData.isExpanded)
        .frame(height: screenHeight)
        .frame(height: screenHeight - minimizedHeight + minimizedHeight * shareData.progress, alignment: .bottom)
        .overlay(alignment: .bottom) {
            CustomPagingIndicatorView {
                Task {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        position.scrollTo(edge: .bottom)
                    }
                    try? await Task.sleep(for: .seconds(0.13))
                    withAnimation(.easeInOut(duration: 0.25)) {
                        shareData.progress = 0
                        shareData.isExpanded = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func GridPhotosScrollView() -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 3), spacing: 4) {
                ForEach(1...50, id: \.self) { _ in
                    Rectangle()
                        .fill(.red)
                        .frame(height: 120)
                }
            }
            .scrollTargetLayout()
            .offset(y: shareData.progress * -(safeArea.bottom + 20))
        }
        .defaultScrollAnchor(.bottom)
        .scrollDisabled(!shareData.isExpanded)
        .scrollPosition($position)
        .scrollClipDisabled()
        .onScrollGeometryChange(for: CGFloat.self) { proxy in
            proxy.contentOffset.y - proxy.contentSize.height + proxy.containerSize.height
        } action: { oldValue, newValue in
            shareData.photosScreenOffset = newValue
        }

    }
    
    @ViewBuilder
    func StretchableView(_ color: Color) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let size = proxy.size
            
            Rectangle()
                .fill(color)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .offset(y: minY > 0 ? -minY : 0)
        }
        .frame(width: size.width)
    }
}

#Preview {
    ContentView()
}
