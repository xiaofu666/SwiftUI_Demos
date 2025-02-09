//
//  ContentView.swift
//  MailSwipeActions
//
//  Created by Xiaofu666 on 2025/2/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(1...20, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.3).gradient)
                            .frame(height: 50)
                            .swipeActions {
                                Action(symbolImage:"square.and.arrow.up.fill", tint: .white, background: .blue) {
                                    resetPosition in
                                    resetPosition.toggle()
                                }
                                Action(symbolImage: "square.and.arrow.down.fill", tint: .white, background: .purple) {
                                    resetPosition in
                                }
                                Action(symbolImage: "trash.fill", tint: .white, background: .red) {
                                    resetPosition in
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(15)
            .navigationTitle("Custom Swipe Actions")
        }
    }
}

#Preview {
    ContentView()
}
