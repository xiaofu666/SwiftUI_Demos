//
//  Home.swift
//  iOS18PhotosAppUI
//
//  Created by Xiaofu666 on 2024/7/20.
//

import SwiftUI

struct Home: View {
    let size: CGSize
    let safeArea: EdgeInsets
    let shareData = ShareData()
    
    var body: some View {
        let minimizedHeight = (size.height + safeArea.top + safeArea.bottom) * 0.4
        let mainOffset = shareData.mainOffset
        
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                PhotosScrollView(size: size, safeArea: safeArea)
                
                OtherContents()
                    .padding(.top, -20)
                    .offset(y: shareData.progress * 30)
            }
            .offset(y: shareData.canPullDown ? 0 : mainOffset < 0 ? -mainOffset : 0)
            .offset(y: mainOffset < 0 ? mainOffset : 0)
        }
        .onScrollGeometryChange(for: CGFloat.self) { proxy in
            proxy.contentOffset.y
        } action: { oldValue, newValue in
            shareData.mainOffset = newValue
        }
        .scrollDisabled(shareData.isExpanded)
        .environment(shareData)
        .gesture(
            CustomGesture(isEnabled: shareData.activePage == 3) { gesture in
                let state = gesture.state
                let translation = gesture.translation(in: gesture.view).y
                let isScrolling = state == .began || state == .changed
                
                if state == .began {
                    shareData.canPullDown = translation > 0 && shareData.mainOffset == 0
                    shareData.canPullUp = translation < 0 && shareData.photosScreenOffset == 0
                }
                
                if isScrolling {
                    if shareData.canPullDown && !shareData.isExpanded{
                        let progress = max(min(translation / minimizedHeight, 1.0), 0.0)
                        shareData.progress = progress
                    }
                    if shareData.canPullUp && shareData.isExpanded{
                        let progress = max(min(-translation / minimizedHeight, 1.0), 0.0)
                        shareData.progress = 1 - progress
                    }
                } else {
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                        if shareData.canPullDown && translation > 0 && !shareData.isExpanded {
                            shareData.isExpanded = true
                            shareData.progress = 1
                        }
                        if shareData.canPullUp && translation < 0 && shareData.isExpanded {
                            shareData.isExpanded = false
                            shareData.progress = 0
                        }
                    }
                }
            }
        )
        .background(.gray.opacity(0.12))
    }
}

#Preview {
    ContentView()
}
