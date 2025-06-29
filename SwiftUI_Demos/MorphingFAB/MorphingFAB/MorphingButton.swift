//
//  MorphingButton.swift
//  MorphingFAB
//
//  Created by Xiaofu666 on 2025/6/29.
//

import SwiftUI

struct MorphingButton<Label: View, Content: View, ExpandedContent: View>: View {
    var backgroundColor: Color
    @Binding var showExpandedContent: Bool
    @ViewBuilder var label: Label
    @ViewBuilder var content: Content
    @ViewBuilder var expandedContent: ExpandedContent
    
    @State private var showFullScreenCover: Bool = false
    @State private var animateContent: Bool = false
    @State private var viewPosition: CGRect = .zero
    
    var body: some View {
        label
            .background(backgroundColor)
            .clipShape(.circle)
            .contentShape(.circle)
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action: { newValue in
                viewPosition = newValue
            }
            .opacity(showFullScreenCover ? 0 : 1)
            .onTapGesture {
                toggleFullScreenCover(false, status: true)
            }
            .fullScreenCover(isPresented: $showFullScreenCover) {
                ZStack(alignment:.topLeading) {
                    if animateContent {
                        ZStack(alignment: .top) {
                            if showExpandedContent {
                                expandedContent
                                    .transition(.blurReplace)
                            } else {
                                content
                                    .transition(.blurReplace)
                            }
                        }
                    } else {
                        label
                            .transition(.blurReplace)
                    }
                }
                .geometryGroup()
                .clipShape(.rect(cornerRadius:30, style:.continuous))
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(backgroundColor)
                        .ignoresSafeArea()
                }
                .padding(.horizontal, animateContent && !showExpandedContent ? 15 : 0)
                .padding(.bottom, animateContent && !showExpandedContent ? 5 : 0)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: animateContent ? .bottom : .topLeading
                )
                .offset(x: animateContent ? 0 : viewPosition.minX, y: animateContent ? 0 : viewPosition.minY)
                .ignoresSafeArea(animateContent ? [] : .all)
                .background {
                    Rectangle()
                        .fill(.black.opacity(animateContent ? 0.05 : 0))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(duration: 0.2), completionCriteria: .removed) {
                                animateContent = false
                            } completion: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    toggleFullScreenCover(false, status: false)
                                }
                            }

                        }
                }
                .task {
                    try? await Task.sleep(for: .seconds(0.05))
                    withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                        animateContent = true
                    }
                }
                .animation(.interpolatingSpring(duration: 0.2), value: showExpandedContent)
            }
    }
    private func toggleFullScreenCover(_ withAnimation: Bool, status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = !withAnimation
        
        withTransaction(transaction) {
            showFullScreenCover = status
        }
    }
}

#Preview {
    ContentView()
}
