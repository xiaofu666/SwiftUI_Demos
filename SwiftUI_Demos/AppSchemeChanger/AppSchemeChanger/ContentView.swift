//
//  ContentView.swift
//  AppSchemeChanger
//
//  Created by Xiaofu666 on 2024/8/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("AppScheme") private var appScheme: AppScheme = .device
    @SceneStorage("ShowScenePickerView") private var showPickerView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...20, id: \.self) {
                    Text("Chat history \($0)")
                }
            }
            .navigationTitle("Chart List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPickerView.toggle()
                    } label: {
                        Image(systemName: "moon.fill")
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .animation(.smooth(duration: 0.3), value: appScheme)
    }
}

#Preview {
    ContentView()
}
