//
//  FloatingSheet.swift
//  FloatingBottomSheet
//
//  Created by Xiaofu666 on 2024/8/6.
//

import SwiftUI

extension View {
    @ViewBuilder
    func floatingBottomSheet<Content: View>(isPresented: Binding<Bool>, dismiss: @escaping () -> () = { }, content: @escaping () -> Content) -> some View {
        self
            .sheet(isPresented: isPresented, onDismiss: dismiss) {
                content()
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .background(SheetShadowRemover())
            }
    }
}

fileprivate struct SheetShadowRemover: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let shadowView = view.viewBeforeWindow {
                for subView in shadowView.subviews {
                    subView.layer.shadowColor = UIColor.clear.cgColor
                }
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
}
