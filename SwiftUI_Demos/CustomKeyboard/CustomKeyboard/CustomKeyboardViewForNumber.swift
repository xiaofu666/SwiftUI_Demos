//
//  CustomKeyboardViewForNumber.swift
//  CustomKeyboard
//
//  Created by Xiaofu666 on 2024/9/12.
//

import SwiftUI

struct CustomKeyboardViewForNumber: View {
    @Binding var text: String
    @FocusState.Binding var isActive: Bool
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
            ForEach(1...9, id: \.self) { index in
                ButtonView("\(index)")
            }
            
            ButtonView("delete.backward.fill", isImage: true)
            ButtonView("0")
            ButtonView("checkmark.circle.fill", isImage: true)
        }
        .padding(15)
        .background(.background.shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 0, y: -5)))
    }
    
    @ViewBuilder
    func ButtonView(_ value: String, isImage: Bool = false) -> some View {
        Button {
            if isImage {
                if value == "delete.backward.fill" && !text.isEmpty {
                    text.removeLast()
                }
                if value == "checkmark.circle.fill" {
                    isActive = false
                }
            } else {
                text += value
            }
        } label: {
            Group {
                if isImage {
                    Image(systemName: value)
                } else {
                    Text(value)
                }
            }
            .font(.title3)
            .fontWeight(.semibold)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background {
                if !isImage {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background.shadow(.drop(color: .black.opacity(0.08), radius: 3)))
                }
            }
            .foregroundStyle(Color.primary)
        }
    }
}

#Preview {
    ContentView()
}
