//
//  ContentView.swift
//  FloatingBottomSheet
//
//  Created by Xiaofu666 on 2024/8/6.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet: Bool = false
    @State private var textSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Button("Show Sheet") {
                    showSheet.toggle()
                }
                
                Button("Show Text Sheet") {
                    textSheet.toggle()
                }
            }
        }
        .floatingBottomSheet(isPresented: $showSheet) {
            SheetView (
                title: "Replace Existing Folder?",
                content: "Lorem 1psum is simply dummy text of the printing and typesetting industry.",
                image: .init(
                    content: "questionmark.folder.fill",
                    tint: .blue,
                    foreground: .white
                ),
                button1: .init(
                    content: "Replace",
                    tint: .blue,
                    foreground: .white
                ),
                button2: .init(
                    content: "Cancel",
                    tint: Color.primary.opacity(0.08),
                    foreground: Color.primary
                )
            )
            .presentationDetents([.height(330)])
        }
        .floatingBottomSheet(isPresented: $textSheet) {
            Text("Test")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background.shadow(.drop(color: .black.opacity(0.12), radius: 5)), in: .rect(cornerRadius: 25))
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .presentationDetents([.height(100), .height(330), .fraction(0.999)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(330)))
        }
    }
}

#Preview {
    ContentView()
}
