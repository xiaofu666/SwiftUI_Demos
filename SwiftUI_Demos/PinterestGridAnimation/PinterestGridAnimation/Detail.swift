//
//  Detail.swift
//  PinterestGridAnimation
//
//  Created by Lurich on 2024/5/9.
//

import SwiftUI

struct Detail: View {
    @Environment(UICoordinator.self) private var coordinator
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let rect = coordinator.rect
            let animationView = coordinator.animateView
            let hideRootView = coordinator.hideRootView
            let hideLayer = coordinator.hideLayer
            let anchorX = (coordinator.rect.minX / size.width) > 0.5 ? 1.0 : 0.0
            let scale = size.width / coordinator.rect.width
            // 15 是 padding horizontal 值
            let offsetX = animationView ? (anchorX > 0.5 ? 15 : -15) * scale : 0
            let offsetY = animationView ? -coordinator.rect.minY * scale : 0
            
            let detailHeight = rect.height * scale
            let contentHeight = size.height - detailHeight
            
            if let image = coordinator.animationLayer, let post = coordinator.selectedItem {
                if !hideLayer {
                    Image(uiImage: image)
                        .scaleEffect(animationView ? scale : 1, anchor: .init(x: anchorX, y: 0))
                        .offset(x: offsetX, y: offsetY)
                        .offset(y: animationView ? -coordinator.headerOffset : 0)
                        .opacity(animationView ? 0 : 1)
                        .transition(.identity)
                }
                
                ScrollView(.vertical) {
                    ScrollContent()
                        .safeAreaInset(edge: .top, spacing: 0) {
                            Rectangle()
                                .fill(.clear)
                                .frame(height: detailHeight)
                                .offsetY { offset in
                                    coordinator.headerOffset = max(min(-offset, detailHeight), 0.0)
                                }
                        }
                }
                .scrollDisabled(!hideLayer)
                .contentMargins(.top, detailHeight, for: .scrollIndicators)
                .background {
                    Rectangle()
                        .fill(.background)
                        .padding(.top, contentHeight)
                }
                .animation(.easeInOut(duration: 0.3).speed(1.5)) {
                    $0.offset(y: animationView ? 0 : contentHeight)
                        .opacity(animationView ? 1 : 0)
                }
                
                ImageView(post: post)
                    .allowsHitTesting(false)
                    .frame(
                        width: animationView ? size.width : rect.width,
                        height: animationView ? rect.height * scale : rect.height
                    )
                    .clipShape(.rect(cornerRadius: animationView ? 0 : 10))
                    .overlay(alignment: .top) {
                        HeaderActions(post)
                            .offset(y: coordinator.headerOffset)
                            .padding(.top, safeArea.top )
                    }
                    .offset(x: animationView ? 0 : rect.minX, y: animationView ? 0 : rect.minY)
                    .offset(y: animationView ? -coordinator.headerOffset : 0)
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func ScrollContent() -> some View {
        // 此处编写自定义详情页
        DummyContent()
    }
    
    @ViewBuilder
    func HeaderActions(_ post: Item) -> some View {
        HStack {
            Spacer(minLength: 0)
            
            Button {
                coordinator.toggleView(show: false, frame: .zero, post: post)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.primary, .bar)
                    .padding(10)
                    .contentShape(.rect)
            }
        }
        .animation(.easeInOut(duration: 0.3)) {
            $0.opacity(coordinator.hideLayer ? 1 : 0)
        }
    }
}

#Preview {
    ContentView()
}
