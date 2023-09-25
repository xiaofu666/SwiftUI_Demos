//
//  VerifyCode.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/1.
//

import SwiftUI

@available(iOS 15.0, *)
struct VerifyCode: View {
    @State var code = ""
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
        VStack {
            Text("Verify Code")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ForEach(0..<6, id: \.self) { index in
                    CodeTextBox(index)
                }
            }
            .background {
                TextField("",text: $code.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing.toggle()
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            Button {
                isKeyboardShowing = false
                print("开始验证： code = \(code)")
            } label: {
                Text("Submit")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.blue)
                    }
            }
            .disableWithOpacity(code.count < 6)

        }
        .padding(.all)
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    @ViewBuilder
    func CodeTextBox(_ index: Int) -> some View {
        ZStack {
            if code.count > index {
                let startIndex = code.startIndex
                let charIndex = code.index(startIndex, offsetBy: index)
                let charToString = String(code[charIndex])
                Text(charToString)
            } else {
                Text("")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            let status = isKeyboardShowing && code.count == index
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? .black : .gray, lineWidth:status ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.3), value: status)
        }
        .frame(maxWidth: .infinity)
        
    }
}

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition)
            .opacity(condition ? 0.6 : 1.0)
    }
}
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

@available(iOS 15.0, *)
struct VerifyCode_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                VerifyCode()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .navigationBar)
            }
        } else {
            NavigationView {
                VerifyCode()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
            }
        }
    }
}
