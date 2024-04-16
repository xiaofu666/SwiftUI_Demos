//
//  StatusBarView.swift
//  StatusBarUpdate
//
//  Created by Lurich on 2023/10/8.
//

import SwiftUI

struct StatusBarView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var statusBarWindow: UIWindow?
    
    var body: some View {
        content
            .onAppear() {
                if statusBarWindow == nil {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let statusBarWindow = UIWindow(windowScene: windowScene)
                        statusBarWindow.windowLevel = .statusBar
                        statusBarWindow.tag = 6140
                        let controller = StatusBarViewController()
                        controller.view.isUserInteractionEnabled = false
                        controller.view.backgroundColor = .clear
                        statusBarWindow.rootViewController = controller
                        statusBarWindow.isHidden = false
                        statusBarWindow.isUserInteractionEnabled = false
                        self.statusBarWindow = statusBarWindow
                    }
                }
            }
    }
}

extension UIApplication {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBarWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 6140 }), let statusBarController = statusBarWindow.rootViewController as? StatusBarViewController {
            statusBarController.statusBarStyle = style
            statusBarController.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

class StatusBarViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

#Preview {
    ContentView()
}
