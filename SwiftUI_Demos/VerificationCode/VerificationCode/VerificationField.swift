//
//  VerificationField.swift
//  VerificationCode
//
//  Created by Xiaofu666 on 2025/2/6.
//

import SwiftUI

enum CodeType: Int, CaseIterable {
    case four = 4
    case six = 6
    
    var stringValue: String {
        "\(rawValue) Digit"
    }
}

enum TypingState {
    case typing
    case valid
    case invalid
}

enum FieldStyle: String, CaseIterable {
    case roundedBorder = "Rounded Border"
    case underlined = "Underlined"
}

struct VerificationField: View {
    var type: CodeType = .four
    var style: FieldStyle = .roundedBorder
    @Binding var value: String
    var onChange: (String) async -> TypingState
    
    @State private var state: TypingState = .typing
    @State private var invalidTrigger: Bool = false
    @FocusState private var isActive: Bool
    
    var body: some View {
        HStack(spacing: style == .roundedBorder ? 6 : 10) {
            ForEach(0..<type.rawValue, id: \.self) { index in
                CharacterView(index)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: value)
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .compositingGroup()
        .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: invalidTrigger) { content, offset in
            content
                .offset(x: offset)
        } animation: { _ in
                .linear(duration: 0.06)
        }
        .background {
            TextField("", text: $value)
                .focused($isActive)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .mask(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                }
                .allowsTightening(false)
        }
        .contentShape(.rect)
        .onTapGesture {
            isActive = true
        }
        .onChange(of: value) { oldValue, newValue in
            value = String(newValue.prefix(type.rawValue))
            Task { @MainActor in
                state = await onChange(value)
                if state == .invalid {
                    invalidTrigger.toggle()
                }
            }
        }
        .onChange(of: type) { oldValue, newValue in
            value = ""
        }
        .onChange(of: style) { oldValue, newValue in
            value = ""
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isActive = false
                }
                .tint(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    ///Individual Character View
    @ViewBuilder
    func CharacterView(_ index: Int) -> some View {
        Group {
            if style == .roundedBorder {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(index), lineWidth: 1.2)
            } else {
                Rectangle()
                    .fill(borderColor(index))
                    .frame(height:1)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(width: style == .roundedBorder ? 50 : 40, height: 50)
        .overlay {
            /// Character
            let stringValue = string(index)
            if stringValue != "" {
                Text(stringValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .transition(.blurReplace)
            }
        }
    }
    
    func string(_ index: Int) -> String {
        if value.count > index {
            let startIndex = value.startIndex
            let stringIndex = value.index(startIndex, offsetBy: index)
            return String(value[stringIndex])
        }
        return ""
    }
    
    func borderColor(_ index: Int) -> Color {
        switch state {
        case .typing:
            value.count == index && isActive ? .primary : .gray
        case .valid:
                .green
        case .invalid:
                .red
        }
    }

}

#Preview {
    ContentView()
}
