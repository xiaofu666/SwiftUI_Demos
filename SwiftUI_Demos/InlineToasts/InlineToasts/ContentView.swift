//
//  ContentView.swift
//  InlineToasts
//
//  Created by Xiaofu666 on 2025/4/28.
//

import SwiftUI

struct ContentView: View {
    @State private var showToast1: Bool = false
    @State private var showToast2: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            let toast1 = InlineToastConfig(
                icon: "exclamationmark.circle.fill",
                title: "Incorrect password :(",
                subTitle: "0ops! That didn't match, Give it another shot.",
                tint: .red,
                anchor: .bottom,
                animationAnchor: .bottom,
                actionIcon: "xmark"
            ) {
                showToast1 = false
            }
            
            let toast2 = InlineToastConfig(
                icon: "checkmark.circle.fill",
                title: "Password Reset Email Sent!",
                subTitle: "",
                tint: .green,
                anchor: .bottom,
                animationAnchor: .bottom,
                actionIcon: "xmark"
            ) {
                showToast2 = false
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Email Address" )
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    TextField("", text: $email)
                        .textContentType(.username)
                    
                    Text("Password" )
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    SecureField("", text: $password)
                        .textContentType(.password)
                    
                    VStack(alignment: .trailing, spacing: 20) {
                        Button {
                            showToast1.toggle()
                        } label: {
                            Text("Login in to Account")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 2)
                        }
                        .tint(.blue)
                        .buttonBorderShape(.roundedRectangle(radius:10)).buttonStyle(.borderedProminent)
                        
                        Button("Forgot Password?") {
                            showToast2.toggle()
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .textFieldStyle(.roundedBorder)
            }
            .inlineToast(alignment: .center, config: toast2, isPresented: showToast2)
            .inlineToast(alignment: .center, config: toast1, isPresented: showToast1)
            .padding(15)
            .navigationTitle("Login")
            .animation(.smooth(duration: 0.35), value: showToast1)
            .animation(.smooth(duration: 0.35), value: showToast2)
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

#Preview {
    ContentView()
}
