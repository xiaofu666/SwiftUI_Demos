//
//  ContentView.swift
//  CustomAlertView
//
//  Created by Xiaofu666 on 2025/2/6.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showAlert3 = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("TextField Alert") {
                    showAlert1.toggle()
                }
                .alert(isPresented: $showAlert1) {
                    /// YOUR ALERT CONTENT IN VIEW FORMAT
                    CustomDialog(
                        title: "Folder Name",
                        content: "Enter a file Name",
                        image: .init(content: "folder.fill.badge.plus",tint:.blue, foreground: .white),
                        button1: .init(content: "Save Folder", tint: .blue, foreground: .white, action: { folder in
                            print(folder)
                            showAlert1 = false
                        }),
                        button2: .init(content: "Cancel", tint: .red, foreground: .white, action: { _ in
                            showAlert1 = false
                        }),
                        addsTextField: true,
                        textFieldHint: "Personal Documents"
                    )
                    .transition(.blurReplace.combined(with: .push(from: .bottom)))
                } background: {
                    /// YOUR BACKGROUND CONTENT IN VIEW FORMAT
                    Rectangle()
                        .fill(.primary.opacity(0.35))
                }
                
                Button("Dialog Alert") {
                    showAlert2.toggle()
                }
                .alert(isPresented: $showAlert2) {
                    /// YOUR ALERT CONTENT IN VIEW FORMAT
                    CustomDialog(
                        title: "Replace Existing File?",
                        content: "This will rewrite the existing file with the new file content.",
                        image: .init(content: "questionmark.folder.fill",tint:.blue, foreground: .white),
                        button1: .init(content: "Replace", tint: .blue, foreground: .white, action: { folder in
                            print(folder)
                            showAlert2 = false
                        }),
                        button2: .init(content: "Cancel", tint: .gray.opacity(0.3), foreground: .white, action: { _ in
                            showAlert2 = false
                        }),
                        addsTextField: false,
                        textFieldHint: "Personal Documents"
                    )
                    .transition(.blurReplace.combined(with: .push(from: .bottom)))
                } background: {
                    /// YOUR BACKGROUND CONTENT IN VIEW FORMAT
                    Rectangle()
                        .fill(.primary.opacity(0.35))
                }
                
                Button("Alert") {
                    showAlert3.toggle()
                }
                .alert(isPresented: $showAlert3) {
                    /// YOUR ALERT CONTENT IN VIEW FORMAT
                    CustomDialog(
                        title: "Application Error",
                        content: "There was an error while saving your file.\nPlease try again later.",
                        image: .init(content: "externaldrive.fill.badge.exclamationmark",tint:.blue, foreground: .white),
                        button1: .init(content: "Done", tint: .red, foreground: .white, action: { _ in
                            showAlert3 = false
                        }),
                        addsTextField: false,
                        textFieldHint: "Personal Documents"
                    )
                    .transition(.blurReplace.combined(with: .push(from: .bottom)))
                } background: {
                    /// YOUR BACKGROUND CONTENT IN VIEW FORMAT
                    Rectangle()
                        .fill(.primary.opacity(0.35))
                }
            }
            .navigationTitle("Custom Alert")
        }
    }
}

#Preview {
    ContentView()
}

struct CustomDialog: View {
    var title: String
    var content: String?
    var image: Config
    var button1: Config
    var button2: Config?
    var addsTextField: Bool = false
    var textFieldHint: String = ""
    /// State properties
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName:image.content)
                .font(.title)
                .foregroundStyle(image.foreground)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
                .background {
                    Circle()
                        .stroke(.background, lineWidth: 8)
                }
            
            Text(title)
                .font(.title3.bold())
            
            if let content {
                Text(content)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 4)
            }
            
            if addsTextField {
                TextField(textFieldHint, text: $text)
                    .padding(.horizontal,15)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius:10)
                            .fill(.gray.opacity(0.1))
                    }
                    .padding(.bottom, 5)
            }
            
            ButtonView(button1)
            
            if let button2 {
                ButtonView(button2)
                    .padding(.top, -5)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .frame(maxWidth: 310)
        .compositingGroup()
    }
    
    @ViewBuilder
    private func ButtonView(_ config: Config) -> some View {
        Button {
            config.action(addsTextField ? text : "")
        } label:{
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
    
    struct Config {
        var content: String
        var tint: Color
        var foreground: Color
        var action: (String) -> () = { _ in }
    }
}
