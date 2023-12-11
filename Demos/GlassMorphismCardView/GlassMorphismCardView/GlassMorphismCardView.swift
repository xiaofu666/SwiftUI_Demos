//
//  GlassMorphismCardView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/27.
//

import SwiftUI

struct GlassMorphismCardView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 12, content: {
                Text("Welcome!")
                    .font(.title.bold())
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("UserName")
                        .font(.callout.bold())
                    
                    CustomTextField("Lurich", value: $userName)
                    
                    Text("PassWord")
                        .font(.callout.bold())
                        .padding(.top, 15)
                    
                    CustomTextField("●●●●●●", value: $password, isPassword: true)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.BG)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 8))
                            .padding(.top, 30)
                    })
                })
                
                HStack(spacing: 12, content: {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Label("Email", systemImage: "envelope.fill")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background() {
                                TransparentBlurUIView(removeAllFilters: false)
                                    .background(.white.opacity(0.2))
                            }
                            .clipShape(.rect(cornerRadius: 8))
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Label("Apple", systemImage: "applelogo")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background() {
                                TransparentBlurUIView(removeAllFilters: false)
                                    .background(.white.opacity(0.2))
                            }
                            .clipShape(.rect(cornerRadius: 8))
                    })
                })
                .foregroundColor(.white)
                .padding(.top, 15)
            })
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.top, 35)
            .padding(.bottom, 25)
            .background {
                TransparentBlurUIView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(.white.opacity(0.05))
            }
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white.opacity(0.3), lineWidth: 1.5)
            }
            .shadow(color: .black.opacity(0.2), radius: 10)
            .padding(.horizontal, 40)
            .background {
                ZStack {
                    Circle()
                        .fill(.linearGradient(colors: [
                            .blue,
                            .purple
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .offset(x: -25, y: -55)
                    
                    Circle()
                        .fill(.linearGradient(colors: [
                            .red,
                            .orange
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: 25, y: 55)
                }
            }
        }
        .frame(maxWidth: 390)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(.BG)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CustomTextField(_ hint: String, value: Binding<String>, isPassword: Bool = false) -> some View {
        Group {
            if isPassword {
                SecureField(hint, text: value)
            } else {
                TextField(hint, text: value)
            }
        }
        .environment(\.colorScheme, .dark)
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(.white.opacity(0.12))
        .clipShape(.rect(cornerRadius: 8))
        
    }
}

#Preview {
    GlassMorphismCardView()
}
