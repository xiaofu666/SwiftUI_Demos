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
            VStack(spacing: 10, content: {
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
                
                Text("失败示范")
            })
            .frame(maxHeight: .infinity)
            
            Divider()
            
            VStack(spacing: 10, content: {
                RequestButton(buttonTint: .white, foregroundColor: .gray) {
                    try? await Task.sleep(for: .seconds(2))
                    return .success
                } content: {
                    HStack(spacing: 10) {
                        Text("Login")
                        Image(systemName: "chevron.right")
                    }
                    .fontWeight(.bold)
                }
                
                Text("成功示范")
            })
            .frame(maxHeight: .infinity)
        })
        .frame(width: 200, height: 300)
    }
}

#Preview {
    ContentView()
}
