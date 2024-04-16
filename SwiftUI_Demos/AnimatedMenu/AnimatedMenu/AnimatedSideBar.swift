//
//  AnimatedSideBar.swift
//  AnimatedMenu
//
//  Created by Lurich on 2024/3/26.
//

import SwiftUI

struct AnimatedSideBar<Content: View, MenuView: View, Background: View>: View {
    var rotatesWhenExpands: Bool = true
    var disablesInteraction: Bool = true
    var sideMenuWidth: CGFloat = 200
    var cornerRadius: CGFloat = 25
    @Binding var showMenu: Bool
    @ViewBuilder var content: (UIEdgeInsets) -> Content
    @ViewBuilder var menuView: (UIEdgeInsets) -> MenuView
    @ViewBuilder var background: Background
    
    @GestureState private var isDragging: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    @State private var progress: CGFloat = 0

    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader { _ in
                    menuView(safeArea)
                }
                .frame(width: sideMenuWidth)
                .contentShape(.rect)
                
                GeometryReader { _ in
                    content(safeArea)
                }
                .frame(width: size.width)
                .overlay {
                    if disablesInteraction && progress > 0 {
                        Rectangle()
                            .fill(.primary.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: progress * cornerRadius)
                }
                .scaleEffect(rotatesWhenExpands ? (1 - progress * 0.1) : 1, anchor: .trailing)
                .rotation3DEffect(
                    .init(degrees: rotatesWhenExpands ? (progress * -15) : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            }
            .frame(width: sideMenuWidth + size.width, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            .simultaneousGesture(dragGesture)
        }
        .background(background)
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3)) {
                if newValue {
                    showSideBar()
                } else {
                    reset()
                }
            }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }
            .onChanged { value in
                guard value.startLocation.x > 10 else { return }
                let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0.0) : 0
                offsetX = translationX
                calculateProgress()
            }
            .onEnded { value in
                guard value.startLocation.x > 10 else { return }
                withAnimation(.snappy(duration: 0.3)) {
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + offsetX
                    if total > (sideMenuWidth * 0.5) {
                        showSideBar()
                    } else {
                        reset()
                    }
                }
            }
    }
    
    func showSideBar() {
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    func reset() {
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    func calculateProgress() {
        progress = max(min(offsetX / sideMenuWidth, 1.0), 0.0)
    }
}

#Preview {
    ContentView()
}
