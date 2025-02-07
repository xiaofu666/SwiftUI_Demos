//
//  ContentView.swift
//  VerificationCode
//
//  Created by Xiaofu666 on 2025/2/6.
//

import SwiftUI

struct ContentView: View {
    @State private var code: String = ""
    @State private var type: CodeType = .four
    @State private var style: FieldStyle = .roundedBorder
    
    var body: some View {
        List {
            Section {
                Picker("CodeType Picker", selection: $type) {
                    ForEach(CodeType.allCases, id:\.self) { type in
                        Text(type.stringValue)
                            .tag(style)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Code Length")
            }
            
            Section {
                Picker("FieldStyle Picker", selection: $style) {
                    ForEach(FieldStyle.allCases, id:\.rawValue) { style in
                        Text(style.rawValue)
                            .tag(style)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Style")
            }
            
            VerificationField(type: type, style: style, value: $code) { result in
                if result.count < type.rawValue {
                    return .typing
                } else if result == "123456".prefix(type.rawValue) {
                    return .valid
                } else {
                    return .invalid
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
