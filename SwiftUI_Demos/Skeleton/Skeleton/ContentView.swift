//
//  ContentView.swift
//  Skeleton
//
//  Created by Xiaofu666 on 2025/4/14.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading: Bool = false
    @State private var card: Card?
    
    var body: some View {
        VStack {
            SomeCardView(card: card)
                .onTapGesture {
                    withAnimation(.smooth) {
                        if card == nil {
                            card = .init(
                                image: "WWDC2025",
                                title: "2025年全球开发者大会",
                                subTitle: "自2025年6月9日起",
                                description:"在那里了解最新的框架和功能。学习Apple工具，通过Apple工程师和设计师主持的视频会议提升您的应用程序和游戏。")
                        } else {
                            card = nil
                        }
                    }
                }
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}
struct Card: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var subTitle: String
    var description: String
    
    static let cardData: Card = .init(
        image: "WWDC2025",
        title: "2025年全球开发者大会",
        subTitle: "自2025年6月9日起",
        description:"在那里了解最新的框架和功能。学习Apple工具，通过Apple工程师和设计师主持的视频会议提升您的应用程序和游戏。")
    
    static let mock: Card = .init(
        image: "WWDC2025",
        title: "World Wide Developer Conference 2025",
        subTitle: "From June 9th 2025",
        description:"Be there for the reveal of the latest,frameworks, and features. Learn toApple tools,elevate your apps and games through video sessions hosted by Apple engineers and designers.")
}

struct SomeCardView: View {
    var card: Card?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            Rectangle()
                .foregroundStyle(.clear)
                .overlay {
                    if let card {
                        Image(card.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        SkeletonView(.rect)
                    }
                }
                .frame(height: 400)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                if let card {
                    Text(card.title)
                        .fontWeight(.semibold)
                } else {
                    SkeletonView(.rect(cornerRadius: 5))
                        .frame(height: 20)
                }
                
                Group {
                    if let card {
                        Text(card.subTitle)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                            .frame(height: 15)
                    }
                }
                .padding(.trailing, 30)
                
                ZStack {
                    if let card {
                        Text(card.description)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } else {
                        SkeletonView(.rect(cornerRadius: 5))
                            .frame(height: 50).lineLimit(3)
                    }
                }
            }
            .padding([.horizontal, .top], 15)
            .padding(.bottom, 25)
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(color: .black.opacity(0.1), radius: 10)

    }
}

#Preview {
    ContentView()
}
