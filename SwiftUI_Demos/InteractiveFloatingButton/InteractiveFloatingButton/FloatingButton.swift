//
//  FloatingButton.swift
//  InteractiveFloatingButton
//
//  Created by Lurich on 2024/4/8.
//

import SwiftUI

struct FloatingButton<Label: View>: View {
    private var buttonSize: CGFloat
    private var actions: [FloatingAction]
    private var label: (Bool) -> Label
    
    init(buttonSize: CGFloat = 50, @FloatingActionBuilder actions: @escaping () -> [FloatingAction], @ViewBuilder label: @escaping (Bool) -> Label) {
        self.buttonSize = buttonSize
        self.actions = actions()
        self.label = label
    }
    
    @State private var isExpanded: Bool = false
    @State private var dragLocation: CGPoint = .zero
    @State private var selectedAction: FloatingAction?
    @GestureState private var isDragging: Bool = false
    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            label(isExpanded)
                .frame(width: buttonSize, height: buttonSize)
                .contentShape(.rect)
        }
        .buttonStyle(NoAnimationButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3)
                .onEnded {
                    _ in
                    isExpanded = true
                }
                .sequenced(
                    before: DragGesture()
                        .updating($isDragging) { _, out, _ in
                            out = true
                        }
                        .onChanged { value in
                            guard isExpanded else { return }
                            dragLocation = value.location
                        }
                        .onEnded { value in
                            Task.detached {
                                if let selectedAction {
                                    isExpanded = false
                                    selectedAction.action()
                                }
                                selectedAction = nil
                                dragLocation = .zero
                            }
                        }
                )
        )
        .background {
            ZStack {
                ForEach(actions) { action in
                    ActionView(action)
                }
            }
            .frame(width: buttonSize, height: buttonSize)
        }
        .coordinateSpace(.named("FLOATING_VIEW"))
        .animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpanded)
    }
    
    @ViewBuilder
    func ActionView(_ action: FloatingAction) -> some View {
        Button {
            action.action()
            isExpanded = false
        } label: {
            Image(systemName: action.symbol)
                .font(action.font)
                .foregroundStyle(action.tint)
                .frame(width: buttonSize, height: buttonSize)
                .background(action.background, in: .circle)
                .contentShape(.circle)
        }
        .buttonStyle(PressedButtonStyle())
        .disabled(!isExpanded)
        .animation(.snappy(duration: 0.3, extraBounce: 0)) { content in
            content
                .scaleEffect(selectedAction?.id == action.id ? 1.15 : 1)
        }
        .background() {
            GeometryReader {
                let rect = $0.frame(in: .named("FLOATING_VIEW"))
                
                Color.clear
                    .onChange(of: dragLocation) { oldValue, newValue in
                        if isExpanded && isDragging {
                            if rect.contains(newValue) {
                                selectedAction = action
                            } else {
                                if selectedAction?.id == action.id && !rect.contains(newValue) {
                                    selectedAction = nil
                                }
                            }
                        }
                    }
            }
        }
        .rotationEffect(.degrees(progress(action) * -90))
        .offset(x: isExpanded ? -offset / 2 : 0)
        .rotationEffect(.degrees(progress(action) * 90))
    }
    
    private var offset: CGFloat {
        let buttonOffset = buttonSize + 10
        return CGFloat(actions.count) * (actions.count == 1 ? buttonOffset * 2 : (actions.count == 2 ? buttonOffset * 1.25 : buttonOffset))
    }
    
    private func progress(_ action: FloatingAction) -> CGFloat {
        let index = CGFloat(actions.firstIndex(where: { $0.id == action.id }) ?? 0)
        return actions.count == 1 ? 1 : index / CGFloat(actions.count - 1)
    }
}

fileprivate struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
fileprivate struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: configuration.isPressed)
    }
}

struct FloatingAction: Identifiable {
    private(set) var id: UUID = .init()
    var symbol: String
    var font: Font = .title3
    var tint: Color = .white
    var background: Color = .black
    var action: () -> ()
}

@resultBuilder
struct FloatingActionBuilder {
    static func buildBlock(_ components: FloatingAction...) -> [FloatingAction] {
        components.compactMap({ $0 })
    }
}

#Preview {
    ContentView()
}
