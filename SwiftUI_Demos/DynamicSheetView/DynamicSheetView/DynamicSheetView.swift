//
//  DynamicSheetView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/8/10.
//

import SwiftUI

struct DynamicSheetView: View {
    @State private var showSheet: Bool = false
    @State private var sheetHeight: CGFloat = .zero
    @State private var sheetFirstPageHeight: CGFloat = .zero
    @State private var sheetSecondPageHeight: CGFloat = .zero
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var sheetProgress: CGFloat = .zero
    @State private var alreadyHavingAccount: Bool = false
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button("Show Sheet") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(30)
        .sheet(isPresented: $showSheet, onDismiss: {
            sheetHeight = .zero
            sheetFirstPageHeight = .zero
            sheetSecondPageHeight = .zero
            sheetProgress = .zero
        }, content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                ScrollViewReader(content: { proxy in
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0, content: {
                            OnBoarding(size)
                                .id("First Page")
                            
                            LoginView(size)
                                .id("Second Page")
                        })
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(isKeyboardShowing)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            if sheetProgress < 1.0 {
                                // push next page
                                withAnimation(.snappy) {
                                    proxy.scrollTo("Second Page", anchor: .leading)
                                }
                            } else {
                                
                            }
                        }, label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .opacity(1 - sheetProgress)
                                .frame(width: 120 + sheetProgress * (alreadyHavingAccount ? -0 : 50))
                                .overlay(content: {
                                    HStack(spacing: 8, content: {
                                        Text(alreadyHavingAccount ? "Login" : "Get Started")
                                        
                                        Image(systemName: "arrow.right")
                                    })
                                    .fontWeight(.semibold)
                                    .opacity(sheetProgress)
                                })
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(.linearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), in: .capsule)
                        })
                        .padding(15)
                        .offset(y: sheetHeight - 100)
                        .offset(y: -sheetProgress * 120)
                    }
                })
            })
            .presentationCornerRadius(30)
            .presentationDetents(sheetHeight == .zero ? [.medium] : [.height(sheetHeight)])
//            .interactiveDismissDisabled() // 禁止滑动返回
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                isKeyboardShowing = true
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                isKeyboardShowing = false
            })
        })
    }
    
    @ViewBuilder
    func OnBoarding(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("Know Everything\n\("about the weather")")
                .font(.largeTitle.bold())
                .lineLimit(2)
            
            Text(attributedSubTitle)
                .font(.callout)
                .foregroundStyle(.gray)
        })
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 130)
        .frame(width: size.width, alignment: .leading)
        .heightChangePreference { height in
            sheetFirstPageHeight = height
            sheetHeight = height
        }
    }
    
    var attributedSubTitle: AttributedString {
        let string = "Start now and learn more about local weather instantly"
        var attString = AttributedString(stringLiteral: string)
        if let range = attString.range(of: "local weather") {
            attString[range].foregroundColor = .black
            attString[range].font = .callout.bold()
        }
        return attString
    }
    
    @ViewBuilder
    func LoginView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text(alreadyHavingAccount ? "Login" : "Create an account")
                .font(.largeTitle.bold())
            
            CustomTextField(hint: "Email Address", text: $emailAddress, icon: "envelope")
            
            CustomTextField(hint: "Password", text: $password, icon: "lock", isPassword: true)
        })
        .padding(15)
        .padding(.horizontal, 10)
        .padding(.top, 15)
        .padding(.bottom, 220)
        .overlay(alignment: .bottom, content: {
            VStack(spacing: 15, content: {
                Group {
                    if alreadyHavingAccount {
                        HStack(spacing: 4, content: {
                            Text("Don't have an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Create an account") {
                                withAnimation(.snappy) {
                                    alreadyHavingAccount.toggle()
                                }
                            }
                            .tint(.red)
                        })
                        .transition(.push(from: .bottom))
                    } else {
                        HStack(spacing: 4, content: {
                            Text("Already having an account?")
                                .foregroundStyle(.gray)
                            
                            Button("Login") {
                                withAnimation(.snappy) {
                                    alreadyHavingAccount.toggle()
                                }
                            }
                            .tint(.red)
                        })
                        .transition(.push(from: .top))
                    }
                }
                .font(.callout)
                .textScale(.secondary)
//                .padding(.bottom, alreadyHavingAccount ? 0 : 15)
                
                if !alreadyHavingAccount {
                    Text("By signing up, you're agreeing to our **[Terms & Condition](https://apple.com)** and **[Privacy Policy](https://apple.com)**")
                        .font(.caption)
                        .tint(.red)
                        .foregroundStyle(.gray)
                        .transition(.offset(y: 100))
                }
            })
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
            .frame(width: size.width)
        })
        .frame(width: size.width)
        .heightChangePreference { height in
            sheetSecondPageHeight = height
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            sheetHeight = sheetFirstPageHeight + diff * sheetProgress
        }
        .offsetX { minX in
            let diff = sheetSecondPageHeight - sheetFirstPageHeight
            let truncatedMinX = min(size.width - minX, size.width)
            guard truncatedMinX > 0 else { return }
            sheetProgress = truncatedMinX / size.width
            sheetHeight = sheetFirstPageHeight + diff * sheetProgress
        }
    }
}

#Preview {
    DynamicSheetView()
}

struct CustomTextField: View {
    var hint: String
    @Binding var text: String
    var icon: String
    var isPassword: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            if isPassword {
                SecureField(hint, text: $text)
            } else {
                TextField(hint, text: $text)
            }
            
            Divider()
        })
        .overlay(alignment: .trailing) {
            Image(systemName: icon)
                .foregroundStyle(.gray)
        }
    }
}
