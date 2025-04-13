//
//  PopOutView.swift
//  SlackHeaderAnimation
//
//  Created by Xiaofu666 on 2025/4/13.
//

import SwiftUI

struct PopOutView<Header: View, Content: View>: View {
    @ViewBuilder var header: (Bool) -> Header
    @ViewBuilder var content: (Bool) -> Content
    @State private var sourceRect: CGRect = .zero
    @State private var showFullScreenCover: Bool = false
    @State private var animateView: Bool = false
    @State private var haptics: Bool = false
    
    var body: some View {
        header(animateView)
            .background(solidBackground(color: .gray, opacity: 0.1))
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action:{ newValue in
                sourceRect = newValue
            }
            .clipShape(.rect(cornerRadius: 10))
            .contentShape(.rect)
            .opacity(showFullScreenCover ? 0 : 1)
            .onTapGesture {
                haptics.toggle()
                toggleFullScreenCover()
            }
            .fullScreenCover(isPresented: $showFullScreenCover) {
                PopOutOverlay(
                    sourceRect: $sourceRect,
                    animateView: $animateView,
                    header: header,
                    content: content
                ) {
                    withAnimation(.easeInOut(duration:
                    0.25), completionCriteria: .removed) {
                        animateView = false
                    } completion:{
                        toggleFullScreenCover()
                    }
                }
            }
            .sensoryFeedback(.impact, trigger: haptics)
    }
    private func toggleFullScreenCover() {
        ///Toggles u1l-Screen-cover without any Animation
        var transaction = Transaction()
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            showFullScreenCover.toggle()
        }
    }

}

/// 自定义叠加视图（实际上是全屏覆盖）！
/// 因此，这将显示在窗口的顶部！
fileprivate struct PopOutOverlay<Header: View, Content: View>: View {
    @Binding var sourceRect: CGRect
    @Binding var animateView: Bool
    @ViewBuilder var header: (Bool) -> Header
    @ViewBuilder var content: (Bool) -> Content
    var dismissView: () -> ()
    /// View Properties
    @State private var edgeInsets: EdgeInsets = .init()
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                /// Close Button
                if animateView {
                    Button(action: dismissView) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.primary)
                            .contentShape(.rect)
                    }
                }
                header(animateView)
            }
            
            if animateView {
                content(animateView)
                    .transition(.blurReplace)
            }
        }
        /// 在扩展模式下占用全部可用空间
        .frame(maxWidth: animateView ? .infinity : nil)
        .padding(animateView ? 15 : 0)
        .background {
            ZStack {
                solidBackground(color: .gray, opacity: 0.1)
                    .opacity(!animateView ? 1 : 0)
                
                Rectangle()
                    .fill(.background)
                    .opacity(animateView ? 1 : 0)
            }
        }
        .clipShape(.rect(cornerRadius: animateView ? 20 : 10))
        .scaleEffect(scale, anchor: .top)
        .frame(
            width: animateView ? nil : sourceRect.width,
            height: animateView ? nil : sourceRect.height
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .offset(
            x: animateView ? 0 : sourceRect.minX,
            y: animateView ? 0 : sourceRect.minY
        )
        .padding(animateView ? 15 : 0)
        .padding(.top, animateView ? edgeInsets.top : 0)
        .ignoresSafeArea()
        .presentationBackground {
            /// 规模计算所需
            GeometryReader {
                let size = $0.size
                
                Rectangle()
                    .fill(.black.opacity(animateView ? 0.5 : 0))
                    .onTapGesture {
                        dismissView()
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let height = value.translation.height
                                let scale = height / size.height
                                let applyingRatio: CGFloat = 0.1
                                self.scale = 1 + (scale * applyingRatio)
                            }
                            .onEnded { value in
                                let velocityHeight = value.velocity.height / 5
                                let height = value.translation.height
                                let scale = height / size.height
                                let applyingRatio: CGFloat = 0.1

                                withAnimation(.easeInOut(duration: 0.25)) {
                                    self.scale = 1
                                    
                                    if -scale > 0.5 {
                                        dismissView()
                                    }
                                }
                            }
                    )
            }
        }
        .onGeometryChange(for: EdgeInsets.self) {
            $0.safeAreaInsets
        } action:{ newValue in
            guard !animateView else { return }
            edgeInsets = newValue
            Task { @MainActor in
                withAnimation(.easeInOut(duration: 0.25)) {
                    animateView = true
                }
            }
        }
    }
}

extension View {
    func solidBackground(color: Color, opacity: CGFloat) -> some View {
        Rectangle()
            .fill(.background)
            .overlay {
                Rectangle()
                    .fill(color.opacity(opacity))
            }
    }
}


#Preview {
    ContentView()
}
