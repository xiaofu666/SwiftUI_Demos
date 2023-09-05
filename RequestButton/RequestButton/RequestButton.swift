//
//  RequestButton.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/8/25.
//

import SwiftUI

struct RequestButton<ButtonContent>: View where ButtonContent: View {
    var buttonTint: Color = .blue
    var foregroundColor: Color = .white
    var action: () async -> TaskStatus
    @ViewBuilder
    var content: () -> ButtonContent
    
    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idle
    @State private var isFailed: Bool = false
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    @State private var wiggle: Bool = false
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        Button {
            Task {
                isLoading = true
                let taskStatus = await action()
                switch taskStatus {
                case .idle:
                    isFailed = false
                case .failed(let string):
                    isFailed = true
                    popupMessage = string
                case .success:
                    isFailed = false
                }
                self.taskStatus = taskStatus
                if isFailed {
                    try? await Task.sleep(for: .seconds(0))
                    wiggle.toggle()
                }
                try? await Task.sleep(for: .seconds(0.8))
                if isFailed {
                    showPopup = true
                }
                self.taskStatus = .idle
                isLoading = false
            }
        } label: {
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .foregroundStyle(foregroundColor)
                .opacity(isLoading ? 0 : 1)
                .lineLimit(1)
                .frame(width: isLoading ? contentSize.height : nil, height: isLoading ? contentSize.height : nil)
                .background(Color(taskStatus == .idle ? buttonTint : taskStatus == .success ? .green : .red).shadow(.drop(color: .black.opacity(0.15), radius: 6)), in: .capsule)
                .overlay {
                    if isLoading && taskStatus == .idle {
                        ProgressView()
                            .tint(foregroundColor)
                    }
                }
                .overlay {
                    if taskStatus != .idle {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                }
                .overlay(content: {
                    GeometryReader(content: { geometry in
                        Color.clear
                            .preference(key: SizeKey.self, value: geometry.size)
                            .onPreferenceChange(SizeKey.self, perform: { value in
                                contentSize = value
                            })
                    })
                })
                .wiggle(wiggle)
        }
        .disabled(isLoading)
        .popover(isPresented: $showPopup, content: {
            Text(popupMessage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: isLoading)
        .animation(.snappy, value: taskStatus)
    }
}

extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view, value in
                view.offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
    }
}

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
}

extension ButtonStyle where Self == OpacityLessButtonStyle {
    static var opacityLess: Self {
        Self()
    }
}
struct OpacityLessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    RequestButton(buttonTint: .white, foregroundColor: .gray) {
        try? await Task.sleep(for: .seconds(2))
        return .failed("网络错误")
    } content: {
        HStack(spacing: 10) {
            Text("Login")
            Image(systemName: "chevron.right")
        }
        .fontWeight(.bold)
    }
//    .buttonStyle(.opacityLess)
//    .preferredColorScheme(.dark)
}
struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
