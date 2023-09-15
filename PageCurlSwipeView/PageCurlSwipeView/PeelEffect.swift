//
//  PeelEffect.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/1.
//

import SwiftUI

@available(iOS 16.0, *)
struct PeelEffect<Content: View>: View {
    var content: Content
    var onDelete: () -> ()
    
    init(content: @escaping () -> Content, onDelete: @escaping () -> ()) {
        self.content = content()
        self.onDelete = onDelete
    }
    @State private var dragProgress: CGFloat = 0
    @State private var isExpanded: Bool = false
    var body: some View {
        content
            .hidden()
            .overlay(content: {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let minX = rect.minX
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.red.gradient)
                        .overlay(alignment: .trailing) {
                            Button {
                                withAnimation(.spring()) {
                                    dragProgress = 1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    onDelete()
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 20)
                                    .contentShape(Rectangle())
                            }
                            .disabled(!isExpanded)
                        }
//                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    guard !isExpanded else { return }
                                    var translationX = value.translation.width
                                    translationX = max(0, -translationX)
                                    let progress = min(1, translationX / rect.width)
                                    dragProgress = progress
                                })
                                .onEnded({ _ in
                                    guard !isExpanded else { return }
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        if dragProgress > 0.25 {
                                            dragProgress = 0.6
                                            isExpanded = true
                                        } else {
                                            dragProgress = .zero
                                            isExpanded = false
                                        }
                                    }
                                })
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                dragProgress = .zero
                                isExpanded = false
                            }
                        }
                    
                    Rectangle()
                        .fill(.black)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                        .padding(.trailing, dragProgress * rect.width)
                        .mask(content)
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                    
                    content
                        .mask {
                            Rectangle()
                                .padding(.trailing, dragProgress * rect.width)
                        }
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                }
            })
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size
                    let minX = proxy.frame(in: .global).minX
                    let minOpacity = dragProgress / 0.05
                    let opactiy = min(1, minOpacity)
                    
                    content
                        .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y: 0)
                        .overlay(content: {
                            Rectangle()
                                .fill(.white.opacity(0.25))
                                .mask(content)
                        })
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(.linearGradient(colors: [
                                    .clear,
                                    .white,
                                    .clear,
                                    .clear
                                ], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60)
                                .offset(x: 40)
                                .offset(x: -30 + 30 * opactiy)
                                .offset(x: size.width * -dragProgress)
                        }
                        .scaleEffect(x: -1)
                        .offset(x: size.width - dragProgress * size.width)
                        .offset(x: size.width * -dragProgress)
                        .mask({
                            Rectangle()
                                .offset(x: size.width * -dragProgress)
                        })
                        .offset(x: dragProgress == 1 ? -minX : 0)
                }
                .allowsHitTesting(false)
            }
    }
}

@available(iOS 16.0, *)
struct PeelEffect_Previews: PreviewProvider {
    static var previews: some View {
        PageCurlSwipeView()
    }
}
