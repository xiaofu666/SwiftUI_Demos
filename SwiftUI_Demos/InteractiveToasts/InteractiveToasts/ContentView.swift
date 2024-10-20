//
//  ContentView.swift
//  InteractiveToasts
//
//  Created by Xiaofu666 on 2024/10/19.
//

import SwiftUI

struct ContentView: View {
    @State private var toasts: [Toast] = []
    
    var body: some View {
        NavigationStack {
            List {
                Text("Dummy List Row View")
            }
            .navigationTitle("Toasts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Show", action: showToast)
                }
            }
        }
        .interactiveToasts($toasts)
    }
    
    func showToast() {
        withAnimation(.bouncy) {
            let toast = Toast { id in
                ToastView(id)
            }
            toasts.append(toast)
        }
    }
    
    @ViewBuilder
    func ToastView(_ id: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "square.and.arrow.up.fill")
            
            Text("Hello world")
                .font(.callout)
            
            Spacer(minLength: 0)
            
            Button {
                $toasts.delete(id)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
            }
        }
        .foregroundStyle(.primary)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
                .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 4)
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    ContentView()
}
