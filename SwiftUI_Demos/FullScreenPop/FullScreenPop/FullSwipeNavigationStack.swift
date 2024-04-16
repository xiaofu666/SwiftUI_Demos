//
//  FullSwipeNavigationStack.swift
//  FullScreenPop
//
//  Created by Lurich on 2023/10/9.
//

import SwiftUI

struct FullSwipeNavigationStack<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = false
        return gesture
    }()
    
    var body: some View {
        NavigationStack {
            content
                .background() {
                    AttachGestureView(gesture: $customGesture)
                }
        }
        .environment(\.PopGestureID, customGesture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? "")), perform: { info in
            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
                customGesture.isEnabled = status
            }
        })
    }
}

fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

fileprivate extension EnvironmentValues {
    var PopGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

extension View {
    @ViewBuilder
    func enableFullSwipePop(_ isEnabled: Bool) -> some View {
        self.modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}

fileprivate struct FullSwipeModifier: ViewModifier {
    var isEnabled: Bool
    @Environment(\.PopGestureID) private var gestureID
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isEnabled, initial: true) { oldValue, newValue in
                guard let gestureID = gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: [
                    "status":newValue
                ])
            }
            .onDisappear(perform: {
                guard let gestureID = gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: [
                    "status":false
                ])
            })
    }
}

fileprivate struct AttachGestureView: UIViewRepresentable {
    @Binding var gesture: UIPanGestureRecognizer
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            if let parentViewController = uiView.parentViewController {
                if let navigationController = parentViewController.navigationController {
                    if let _ = navigationController.view.gestureRecognizers?.first(where: { $0.name == gesture.name }) {
                        print("Already Attached")
                    } else {
                        print("Attached")
                        navigationController.addFullSwipeGesture(gesture)
                    }
                }
            }
        }
    }
}

fileprivate extension UINavigationController {
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else { return }
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) { $0.next }.first(where: { $0 is UIViewController }) as? UIViewController
    }
}

#Preview {
    ContentView()
}
