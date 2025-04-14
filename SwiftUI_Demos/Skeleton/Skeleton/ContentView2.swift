//
//  ContentView2.swift
//  Skeleton
//
//  Created by Xiaofu666 on 2025/4/14.
//

import SwiftUI

struct ContentView2: View {
    @State private var isLoading: Bool = false
    @State private var cards: [Card] = []
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                if cards.isEmpty {
                    ForEach(1...2, id: \.self) { _ in
                        SomeCardView()
                    }
                } else {
                    ForEach(cards) { card in
                        SomeCardView(card: card)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation(.smooth) {
                cards = [.init(
                    image: "WWDC2025",
                    title: "2025年全球开发者大会",
                    subTitle: "自2025年6月9日起",
                    description:"在那里了解最新的框架和功能。学习Apple工具，通过Apple工程师和设计师主持的视频会议提升您的应用程序和游戏。")]
            }
        }
    }
}

#Preview {
    ContentView2()
}
