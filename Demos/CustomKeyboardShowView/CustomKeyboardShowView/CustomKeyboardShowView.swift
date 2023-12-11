//
//  CustomKeyboardShowView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/2.
//

import SwiftUI

@available(iOS 16.0, *)
struct CustomKeyboardShowView: View {
    @State private var text: String = ""
    @FocusState private var showKeyboard: Bool
    var textPrefix = "+86 "
    
    var body: some View {
        VStack {
            Image("AppLogo")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            
            TextField("\(textPrefix)输入电话号码", text: $text)
                .inputCustomView {
                    CustomTFKeyboard(text: $text, inputPrefix: textPrefix) {
                        showKeyboard = false
                    }
                }
                .focused($showKeyboard)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .environment(\.colorScheme, .dark)
                .padding([.horizontal, .top], 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.black.gradient)
                .ignoresSafeArea()
        }
    }
}

@available(iOS 16.0, *)
struct CustomKeyboardShowView_Previews: PreviewProvider {
    static var previews: some View {
        CustomKeyboardShowView()
    }
}
