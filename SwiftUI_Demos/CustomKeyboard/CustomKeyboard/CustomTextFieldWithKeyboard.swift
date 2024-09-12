//
//  CustomTextFieldWithKeyboard.swift
//  CustomKeyboard
//
//  Created by Xiaofu666 on 2024/9/12.
//

import SwiftUI

struct CustomTextFieldWithKeyboard<TextField: View, Keyboard: View>: UIViewControllerRepresentable {
    @ViewBuilder var textField: TextField
    @ViewBuilder var keyboard: Keyboard
    
    func makeUIViewController(context: Context) -> UIHostingController<TextField> {
        let controller = UIHostingController(rootView: textField)
        controller.view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let textField = controller.view.allSubviews.first(where: { $0 is UITextField }) as? UITextField, textField.inputView == nil {
                let keyboardView = UIHostingController(rootView: keyboard)
                keyboardView.view.backgroundColor = .clear
                keyboardView.view.frame = .init(origin: .zero, size: keyboardView.view.intrinsicContentSize)
                textField.inputView = keyboardView.view
                textField.reloadInputViews()
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<TextField>, context: Context) {
        
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIHostingController<TextField>, context: Context) -> CGSize? {
        return uiViewController.view.intrinsicContentSize
    }
}

fileprivate extension UIView {
    var allSubviews: [UIView] {
        return subviews.flatMap({ [$0] + $0.allSubviews })
    }
}

#Preview {
    ContentView()
}
