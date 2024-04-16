//
//  SheetRootViewFinder.swift
//  MapsBottomSheetV2
//
//  Created by Lurich on 2024/2/21.
//

import SwiftUI


extension View {
    @ViewBuilder
    func bottomMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(mask: mask, height: height))
    }
}

fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    var mask: Bool
    var height: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
            if let rootView = uiView.viewBeforeWindow, let window = rootView.window {
                let safeArea = window.safeAreaInsets
                rootView.frame = .init(x: 0, y: 0, width: window.frame.width, height: window.frame.height - (mask ? (height + safeArea.bottom) : 0))
                rootView.clipsToBounds = true
                for view in rootView.subviews {
                    view.layer.shadowColor = UIColor.clear.cgColor
                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubViews.first(where: {
                            $0.layer.animationKeys()?.contains("cornerRadius") ?? false
                        }) {
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                }
            }
        }
    }
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
    
    var allSubViews: [UIView] {
        return subviews.flatMap { view in
            [view] + view.subviews
        }
    }
}

#Preview {
    ContentView()
}
