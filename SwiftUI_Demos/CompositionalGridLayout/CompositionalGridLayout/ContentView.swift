//
//  ContentView.swift
//  CompositionalGridLayout
//
//  Created by Xiaofu666 on 2024/8/7.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int = 5
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 6) {
                    CompositionalLayout(count: count) {
                        ForEach(1...50, id: \.self) { index in
                            Rectangle()
                                .fill(.black.gradient)
                                .overlay {
                                    Text("\(index)")
                                        .font(.largeTitle.bold())
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Compositional Grid")
            .animation(.bouncy, value: count)
            .safeAreaInset(edge: .top) {
                PickerView()
                    .background(.thickMaterial)
                    .padding(.horizontal, 15)
                    .zIndex(100)
            }
        }
    }
    
    @ViewBuilder
    func PickerView() -> some View {
        Picker("", selection: $count) {
            ForEach(1...5, id: \.self) {
                Text("\($0)")
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    ContentView()
}
