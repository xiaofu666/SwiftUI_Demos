//
//  ContentView.swift
//  ThemeChanger
//
//  Created by Lurich on 2023/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var changeTheme: Bool = false
    @Environment(\.colorScheme) private var scheme: ColorScheme
    @AppStorage("userScheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Button("Change Theme") {
                        changeTheme = true
                    }
                }
            }
            .navigationTitle("Setting")
        }
        .preferredColorScheme(userTheme.colorCheme)
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeView(scheme: scheme)
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
}

#Preview {
    ContentView()
}
