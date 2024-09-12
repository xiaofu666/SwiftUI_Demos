//
//  ContentView.swift
//  CustomKeyboard
//
//  Created by Xiaofu666 on 2024/9/12.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @FocusState private var isActive: Bool
    
    var body: some View {
        NavigationStack {
            CustomTextFieldWithKeyboard {
                TextField("App Pin Code", text: $text)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .frame(maxWidth: 150)
                    .background(.fill, in: .rect(cornerRadius: 15))
                    .focused($isActive)
            } keyboard: {
                CustomKeyboardViewForNumber(text: $text, isActive: $isActive)
            }
            .navigationTitle("Custom Keyboard")
        }
    }
}

#Preview {
    ContentView()
}
