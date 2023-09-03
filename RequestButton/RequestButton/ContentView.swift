//
//  ContentView.swift
//  RequestButton
//
//  Created by Lurich on 2023/9/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 15, content: {
            HStack(spacing: 12, content: {
                Text("失败示范")
                
                RequestButton(buttonTint: .white, foregroundColor: .gray) {
                    try? await Task.sleep(for: .seconds(2))
                    return .failed("网络错误")
                } content: {
                    HStack(spacing: 10) {
                        Text("Login")
                        Image(systemName: "chevron.right")
                    }
                    .fontWeight(.bold)
                }
            })
            
            HStack(spacing: 12, content: {
                Text("成功示范")
                
                RequestButton(buttonTint: .white, foregroundColor: .gray) {
                    try? await Task.sleep(for: .seconds(2))
                    return .failed("网络错误")
                } content: {
                    HStack(spacing: 10) {
                        Text("Login")
                        Image(systemName: "chevron.right")
                    }
                    .fontWeight(.bold)
                }
            })
        })
    }
}

#Preview {
    ContentView()
}
