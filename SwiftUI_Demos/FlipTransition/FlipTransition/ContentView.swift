//
//  ContentView.swift
//  FlipTransition
//
//  Created by Lurich on 2024/4/17.
//

import SwiftUI

struct ContentView: View {
    @State private var flipCard: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    if flipCard {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.purple.gradient)
                            .overlay {
                                Text("反面")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.white)
                            }
                            .transition(.flip)
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red.gradient)
                            .overlay {
                                Text("正面")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.white)
                            }
                            .transition(.reverseFlip)
                    }
                }
                .frame(width: 200, height: 300)
                
                Button("翻卡牌") {
                    withAnimation(.bouncy(duration: 2)) {
                        flipCard.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
