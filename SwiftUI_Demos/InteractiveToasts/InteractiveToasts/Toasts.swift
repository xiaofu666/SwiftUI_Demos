//
//  Toasts.swift
//  InteractiveToasts
//
//  Created by Xiaofu666 on 2024/10/19.
//

import SwiftUI

struct Toast: Identifiable {
    var content: AnyView
    
    private(set) var id: String = UUID().uuidString
    var offsetX: CGFloat = 0
    var isDeleting: Bool = false
    
    init(@ViewBuilder content: @escaping (String) -> some View) {
        self.content = .init(content(id))
    }
}

extension View {
    @ViewBuilder
    func interactiveToasts(_ toasts: Binding<[Toast]>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                ToastsView(toasts: toasts)
            }
    }
}

fileprivate struct ToastsView: View {
    @Binding var toasts: [Toast]
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isExpanded {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isExpanded = false
                    }
            }
            
            let layout = isExpanded ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
            
            layout {
                ForEach($toasts) { $toast in
                    let index = (toasts.count - 1) - (toasts.firstIndex(where: { $0.id == toast.id }) ?? 0)
                    toast.content
                        .offset(x: toast.offsetX)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    let offsetX = value.translation.width < 0 ? value.translation.width : 0
                                    toast.offsetX = offsetX
                                })
                                .onEnded({ value in
                                    let offsetX = value.translation.width + (value.velocity.width / 2)
                                    
                                    if -offsetX > 200 {
                                        $toasts.delete(toast.id)
                                    } else {
                                        withAnimation(.bouncy) {
                                            toast.offsetX = 0
                                        }
                                    }
                                })
                        )
                        .visualEffect { [isExpanded] content, proxy in
                            content
                                .scaleEffect(isExpanded ? 1 : scale(index), anchor: .bottom)
                                .offset(y: isExpanded ? 0 : offsetY(index))
                        }
                        .zIndex(toast.isDeleting ? 10000 : 0)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(insertion: .offset(y: 100), removal: .move(edge: .leading)))
                }
            }
            .onTapGesture {
                isExpanded.toggle()
            }
            .padding(.bottom, 15)
        }
        .animation(.bouncy, value: isExpanded)
        .onChange(of: toasts.isEmpty) { oldValue, newValue in
            if newValue {
                isExpanded = false
            }
        }
    }
    
    nonisolated func offsetY(_ index: Int) -> CGFloat {
        let offset = min(CGFloat(index) * 15, 30)
        return -offset
    }
    
    nonisolated func scale(_ index: Int) -> CGFloat {
        let scale = min(CGFloat(index) * 0.1, 1)
        return 1 - scale
    }
}

extension Binding<[Toast]> {
    func delete(_ id: String) {
        if let toast = first(where: { $0.id == id }) {
            toast.wrappedValue.isDeleting = true
        }
        withAnimation(.bouncy) {
            self.wrappedValue.removeAll(where: { $0.id == id })
        }
    }
}

#Preview {
    ContentView()
}
