//
//  ContentView.swift
//  SnapEffect
//
//  Created by Xiaofu666 on 2024/11/27.
//

import SwiftUI

struct ContentView: View {
    @State private var snapEffect: Bool = false
    @State private var isRemoved: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !isRemoved {
                    Image(.pic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .clipped()
                        .disintegrationEffect(isDeleted: snapEffect) {
                            withAnimation(.snappy) {
                                isRemoved = true
                            }
                        }
                    
                    Button("隐藏") {
                        snapEffect = true
                    }
                    .buttonStyle(.borderedProminent)
                    .opacity(snapEffect ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 25)
            .navigationTitle("Disintegration Effect")
        }
    }
}

#Preview {
    ContentView()
}
