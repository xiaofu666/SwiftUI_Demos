//
//  Toast.swift
//  CustomToasts
//
//  Created by Lurich on 2023/12/17.
//

import SwiftUI

struct RootView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var overlayWindow: UIWindow?
    var body: some View {
        content
            .onAppear() {
                if let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScenes)
                    let rootController = UIHostingController(rootView: ToastGroup())
                    rootController.view.frame = windowScenes.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.backgroundColor = .clear
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    overlayWindow = window
                }
            }
    }
}

fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}

fileprivate struct ToastGroup: View {
    var model = Toast.shared
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets
            ZStack {
                ForEach(model.toasts) { item in
                    ToastView(size: size, item: item)
                        .animation(.easeInOut, body: { view in
                            view
                                .scaleEffect(scale(item))
                                .offset(y: offsetY(item))
                        })
                }
            }
            .padding(.bottom, safeArea.bottom == .zero ? 15 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    func offsetY(_ item: ToastModel) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalToast = CGFloat(model.toasts.count) - 1
        return (totalToast - index) >= 2 ? -20 : ((totalToast - index) * -10)
    }
    
    func scale(_ item: ToastModel) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalToast = CGFloat(model.toasts.count) - 1
        return 1.0 - ((totalToast - index) >= 2 ? 0.2 : ((totalToast - index) * 0.1))
    }
}

fileprivate struct ToastView: View {
    var size: CGSize
    var item: ToastModel
    
    @State private var delayTask: DispatchWorkItem?
    
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            Text(item.title)
                .lineLimit(1)
        }
        .foregroundStyle(item.tint)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(
            .background
                .shadow(.drop(color: .primary.opacity(0.04), radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5))
            , in: .capsule)
        .contentShape(.capsule)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    if (endY + velocityY) > 100 {
                        removeToast()
                    }
                })
        )
        .onAppear() {
            guard delayTask == nil else { return }
            delayTask = .init(block: {
                removeToast()
            })
            if let delayTask {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + item.timing.rawValue, execute: delayTask)
            }
        }
        .frame(maxWidth: size.width * 0.7)
        .transition(.offset(y: 150))
    }
    
    func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.toasts.removeAll(where: { $0.id == item.id })
        }
    }
}

@Observable
class Toast {
    static let shared = Toast()
    fileprivate var toasts: [ToastModel] = []
    
    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .medium) {
        withAnimation(.snappy) {
            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing))
        }
    }
}

struct ToastModel: Identifiable {
    let id: UUID = .init()
    /// Custom Properties
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled:Bool
    var timing: ToastTime = .medium
}
enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 2.0
    case long = 3.5
}

#Preview {
    RootView {
        ContentView()
    }
}
