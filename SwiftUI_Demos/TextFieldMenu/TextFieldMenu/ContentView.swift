//
//  ContentView.swift
//  TextFieldMenu
//
//  Created by Xiaofu666 on 2024/11/6.
//

import SwiftUI

struct ContentView: View {
    @State private var message: String = "Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!Hello world!"
    @State private var selection: TextSelection?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Message", text: $message, selection: $selection, axis: .vertical)
                        .menu {
                            TextFieldAction(title: "大写") { _, textInput in
                                if let selectedRange = textInput.selectedTextRange, let selectedText = textInput.text(in: selectedRange) {
                                    let upperCasedText = selectedText.uppercased()
                                    textInput.replace(selectedRange, withText: upperCasedText)
                                    textInput.selectedTextRange = selectedRange
                                }
                            }
                            TextFieldAction(title: "小写") { _, textInput in
                                if let selectedRange = textInput.selectedTextRange, let selectedText = textInput.text(in: selectedRange) {
                                    let lowerCasedText = selectedText.lowercased()
                                    textInput.replace(selectedRange, withText: lowerCasedText)
                                    textInput.selectedTextRange = selectedRange
                                }
                            }
                            TextFieldAction(title: "AI重写") { _, textInput in
                                if let selectedRange = textInput.selectedTextRange {
                                    let aiText = "你是不是有点想多了？"
                                    textInput.replace(selectedRange, withText: aiText)
                                    if let start = textInput.position(from: selectedRange.start, offset: 0), let end = textInput.position(from: selectedRange.start, offset: aiText.count) {
                                        textInput.selectedTextRange = textInput.textRange(from: start, to: end)
                                    }
                                }
                            }
                        }
                }
                
                Section {
                    if let selection, !selection.isInsertion {
                        Text("Some Text is Selected")
                    }
                }
            }
            .navigationTitle("Custom TextField Menu")
        }
    }
}

#Preview {
    ContentView()
}
