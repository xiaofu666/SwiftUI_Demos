//
//  ContentView.swift
//  CustomPopView
//
//  Created by Xiaofu666 on 2024/9/7.
//

import SwiftUI

struct ContentView: View {
    @State private var showPopup: Bool = false
    @State private var showAlert: Bool = false
    @State private var isWrongPassword: Bool = false
    @State private var isTryingAgain: Bool = false
    
    var body: some View {
        NavigationStack {
            Button {
                showPopup.toggle()
            } label: {
                Text("Unlock File")
            }
            .navigationTitle("Documents")
        }
        .popView(isPresented: $showPopup) {
            showAlert = isWrongPassword
            isWrongPassword = false
        } content: {
            CustomAlertWithTextField(show: $showPopup) { password in
                isWrongPassword = password != "xiaofu666"
            }
        }
        .popView(isPresented: $showAlert) {
            showPopup = isTryingAgain
            isTryingAgain = false
        } content: {
            CustomAlert(show: $showAlert) {
                isTryingAgain = true
            }
        }

    }
}

struct CustomAlertWithTextField: View {
    @Binding var show: Bool
    var onUnlock: (String) -> ()
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.badge.key.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.blue.gradient)
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-5)
                        }
                }
            
            Text("Lock File")
                .fontWeight(.semibold)
            
            Text("This file has been locked by the user, please enter the password to continue.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            SecureField("Password", text: $password)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.bar)
                }
                .padding(.vertical, 10)

            HStack(spacing: 10) {
                Button {
                    show = false
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                }
                
                Button {
                    onUnlock(password)
                    show = false
                } label: {
                    Text("Unlock")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                }
            }
        }
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 25)
        }
    }
}

struct CustomAlert: View {
    @Binding var show: Bool
    var onTryAgain: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.trianglebadge.exclamationmark.fill")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 65, height: 65)
                .background {
                    Circle()
                        .fill(.red.gradient)
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-5)
                        }
                }
            
            Text("Wrong Password")
                .fontWeight(.semibold)
            
            Text("Please enter the correct password to unclock the file.")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)

            HStack(spacing: 10) {
                Button {
                    show = false
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                        }
                }
                
                Button {
                    onTryAgain()
                    show = false
                } label: {
                    Text("Unlock")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        }
                }
            }
        }
        .frame(width: 250)
        .padding([.horizontal, .bottom], 25)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 25)
        }
    }
}

#Preview {
    ContentView()
}
