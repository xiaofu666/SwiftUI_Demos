//
//  PopView.swift
//  CustomPopView
//
//  Created by Xiaofu666 on 2024/9/7.
//

import SwiftUI

struct Config {
    var backgroundColor: Color = .black.opacity(0.25)
}

extension View {
    @ViewBuilder
    func popView<Content: View>(
        config: Config = .init(),
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> (),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            PopViewHelper(
                config: config,
                isPresented: isPresented,
                onDismiss: onDismiss,
                viewContent: content
            )
        )
    }
}

fileprivate struct PopViewHelper<ViewContent: View>: ViewModifier {
    var config: Config
    @Binding var isPresented: Bool
    var onDismiss: () -> ()
    @ViewBuilder var viewContent: ViewContent
    
    @State private var presentFullScreenCover: Bool = false
    @State private var animationView: Bool = false
    
    func body(content: Content) -> some View {
        let screenHeight = screenSize.height
        let animation = animationView
        content
            .fullScreenCover(isPresented: $presentFullScreenCover, onDismiss: onDismiss) {
                ZStack {
                    Rectangle()
                        .fill(config.backgroundColor)
                        .ignoresSafeArea()
                        .opacity(animation ? 1 : 0)
                    
                    viewContent
                        .visualEffect { effectContent, proxy in
                            effectContent
                                .offset(y: offset(proxy, screenHeight, animation))
                        }
                        .presentationBackground(.clear)
                        .task {
                            guard !animationView else { return }
                            withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                                animationView = true
                            }
                        }
                }
            }
            .onChange(of: isPresented) { oldValue, newValue in
                if newValue {
                    toggleView(true)
                } else {
                    withAnimation(.snappy(duration: 0.45), completionCriteria: .logicallyComplete) {
                        animationView = false
                    } completion: {
                        toggleView(false)
                    }

                }
            }
    }
    
    func toggleView(_ status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        
        withTransaction(transaction) {
            presentFullScreenCover = status
        }
    }
    
    nonisolated func offset(_ proxy: GeometryProxy, _ screenHeight: CGFloat, _ animation: Bool) -> CGFloat {
        let viewHeight = proxy.size.height
        return animation ? 0 : (screenHeight + viewHeight) / 2
    }
    
    var screenSize: CGSize {
        if let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return screen.screen.bounds.size
        }
        return .zero
    }
}

#Preview {
    ContentView()
}
