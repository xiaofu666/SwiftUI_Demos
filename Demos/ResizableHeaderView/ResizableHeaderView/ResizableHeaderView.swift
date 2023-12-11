//
//  ResizableHeaderView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/5/7.
//

import SwiftUI

@available(iOS 16.0, *)
struct ResizableHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@available(iOS 16.0, *)
struct ResizableHeaderDetailView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HeaderView()
                        .zIndex(100)
                    
                    sampleCardsView()
                }
                .id("ResizableHeaderDetailView")
                .background {
                    ScrollDetector { offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        let headerHeight = 250 + safeArea.top
                        let minimumHeaderHeight = 65 + safeArea.top
                        let targetEnd = offset + velocity * 45
                        if targetEnd < (headerHeight - minimumHeaderHeight) && targetEnd > 0 {
                            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)) {
                                scrollProxy.scrollTo("ResizableHeaderDetailView", anchor: .top)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = 250 + safeArea.top
        let minimumHeaderHeight = 65 + safeArea.top
        // 0-1之间
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeight), 1), 0)
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(Color("Pink").gradient)
                
                HeaderSubView(headerHeight: headerHeight, minimumHeaderHeight: minimumHeaderHeight, progress: progress)
            }
            .frame(height: ((headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY)), alignment: .bottom)
            .offset(y: -offsetY)
        }
        .frame(height: headerHeight)
    }
    
    @ViewBuilder
    func sampleCardsView() -> some View {
        VStack(spacing: 15) {
            ForEach(1...20, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.black.opacity(0.05))
                    .frame(height: 75)
            }
        }
        .padding(15)
    }
    
    @ViewBuilder
    func HeaderSubView(headerHeight: CGFloat, minimumHeaderHeight: CGFloat, progress: CGFloat) -> some View {
        VStack(spacing: 15) {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .global)
                let resizedOffsetY = rect.midY - (minimumHeaderHeight - rect.height * 0.3 * 0.5 - 15)
                Image("Pic")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: rect.width, height: rect.height)
                    .clipShape(Circle())
                    .scaleEffect(1 - progress * 0.7, anchor: .leading)
                    .offset(x: -(rect.minX - 15) * progress, y: -resizedOffsetY * progress)
            }
            .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
            
            Text("Lurich")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .scaleEffect(1 - progress * 0.15)
                .offset(y: -4.5 * progress)
        }
        .padding(.top, safeArea.top)
        .padding(.bottom, 15)
    }
}
