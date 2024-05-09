//
//  DateTextField.swift
//  DateTextField
//
//  Created by Lurich on 2024/5/8.
//

import SwiftUI

struct DateTextField: View {
    var components: DatePickerComponents = [.date, .hourAndMinute]
    @Binding var date: Date
    var formattedString: (Date) -> String
    @State private var viewID: String = UUID().uuidString
    @FocusState private var isActive
    var body: some View {
        TextField(viewID, text: .constant(formattedString(date)))
            .focused($isActive)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isActive = false
                    }
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .overlay {
                AddInputViewToTextField(id: viewID) {
                    DatePicker("", selection: $date)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                .onTapGesture {
                    isActive = true
                }
            }
    }
}

fileprivate struct AddInputViewToTextField<Content: View>: UIViewRepresentable {
    var id: String
    @ViewBuilder var content: Content
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let window = view.window, let textField = window.allSubViews(type: UITextField.self).first(where: { $0.placeholder == id }) {
                textField.tintColor = .clear
                let hostView = UIHostingController(rootView: content).view!
                hostView.backgroundColor = .clear
                hostView.frame.size = hostView.intrinsicContentSize
                textField.inputView = hostView
                textField.reloadInputViews()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

fileprivate extension UIView {
    func allSubViews<T: UIView>(type: T.Type) -> [T] {
        var resultViews = subviews.compactMap({ $0 as? T })
        for view in subviews {
            resultViews.append(contentsOf: view.allSubViews(type: type))
        }
        return resultViews
    }
}

#Preview {
    ContentView()
}
