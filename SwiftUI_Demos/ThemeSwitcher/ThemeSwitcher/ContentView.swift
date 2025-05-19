//
//  ContentView.swift
//  ThemeSwitcher
//
//  Created by Xiaofu666 on 2025/5/19.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("AppTheme") private var scheme: AppTheme = .systemDefault
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .frame(maxWidth: .infinity)
                .padding()
            } footer: {
                Picker("主题选择器", selection: $scheme) {
                    ForEach(AppTheme.allCases, id: \.rawValue) { theme in
                        Text(theme.rawValue)
                            .tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    ContentView()
}
