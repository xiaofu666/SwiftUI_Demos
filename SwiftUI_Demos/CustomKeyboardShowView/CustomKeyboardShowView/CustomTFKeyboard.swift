//
//  CustomTFKeyboard.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/2.
//

import SwiftUI

@available(iOS 15.0, *)
extension TextField {
    @ViewBuilder
    func inputCustomView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .background {
                SetTFKeyboard(keyboardContent: content())
            }
    }
}

fileprivate struct SetTFKeyboard<Content: View>: UIViewRepresentable {
    var keyboardContent: Content
    @State private var hostingController: UIHostingController<Content>?
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let textfieldContainerView = uiView.superview?.superview {
                if let textField = textfieldContainerView.firstTextField {
                    if textField.inputView == nil {
                        hostingController = UIHostingController(rootView: keyboardContent)
                        hostingController?.view.frame = .init(origin: .zero, size: hostingController?.view.intrinsicContentSize ?? .zero)
                        textField.inputView = hostingController?.view
                    } else {
                        hostingController?.rootView = keyboardContent
                    }
                } else {
                    print("Failed To Find TextField")
                }
            }
        }
    }
}

fileprivate extension UIView {
    var allSubViews: [UIView] {
        return subviews.flatMap { view in
            [view] + view.subviews
        }
    }
    
    var firstTextField: UITextField? {
        if let textField = allSubViews.first(where: { view in
            view is UITextField
        }) as? UITextField {
            return textField
        }
        return nil
    }
}

enum KeyboardValue {
    case text(String)
    case image(String)
}

@available(iOS 16.0, *)
struct CustomTFKeyboard: View {
    @Binding var text: String
    var inputPrefix: String = "¥ "
    var endInput: () -> ()
    
    var body: some View {
        CustomKeyboardView()
    }
    
    @ViewBuilder
    func CustomKeyboardView() -> some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 3), spacing: 10) {
            ForEach(1...9, id: \.self) { index in
                keyboardButtonView(.text("\(index)")) {
                    if text.isEmpty {
                        text.append(inputPrefix)
                    }
                    text.append("\(index)")
                }
            }
            
            keyboardButtonView(.image("delete.backward")) {
                if !text.isEmpty {
                    text.removeLast()
                }
                if text == inputPrefix {
                    text = ""
                }
            }
            
            keyboardButtonView(.text("0")) {
                if text.isEmpty {
                    text.append(inputPrefix)
                }
                text.append("0")
            }
            
            keyboardButtonView(.image("checkmark.circle.fill")) {
                endInput()
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .background {
            Rectangle()
                .fill(.black.gradient)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func keyboardButtonView(_ value: KeyboardValue, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            ZStack {
                switch value {
                case .text(let string):
                    Text(string)
                case .image(let imgStr):
                    Image(systemName: imgStr)
                        .font(imgStr == "checkmark.circle.fill" ? .title : .title2)
                        .foregroundColor(imgStr == "checkmark.circle.fill" ? .green : .white)
                }
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .contentShape(Rectangle())
    }
}
