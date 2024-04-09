//
//  ContentView.swift
//  BookCard
//
//  Created by Lurich on 2024/4/9.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        VStack {
            OpenBookView(config: .init(progress: progress)) { size in
                FrontView(size)
            } insideLeft: { size in
                InsideLeftView(size)
            } insideRight: { size in
                InsideRightView(size)
            }
            
            HStack {
                Slider(value: $progress)
                
                Button("Toggle") {
                    withAnimation(.snappy(duration: 1)) {
                        progress = progress == 1.0 ? 0.2 : 1.0
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(10)
            .background(.background, in: .rect(cornerRadius: 10))
            .padding(.top, 50)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.15))
        .navigationTitle("Book View")
    }
    
    @ViewBuilder
    func FrontView(_ size: CGSize) -> some View {
        Image(.book)
            .resizable()
            .aspectRatio(contentMode: .fill)
//            .offset(y: 10)
            .frame(width: size.width, height: size.height)
    }
    
    @ViewBuilder
    func InsideLeftView(_ size: CGSize) -> some View {
        VStack(spacing: 5) {
            Image(.author)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
            
            Text("火星引力")
                .fontWidth(.condensed)
                .fontWeight(.bold)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
    
    @ViewBuilder
    func InsideRightView(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("逆天邪神")
                .font(.subheadline)
            
            Text("《逆天邪神》是网络作家火星引力创作的东方玄幻类网络小说，首发于纵横中文网。小说主要讲述一代少年云澈继承邪神之血，走上了逆天之途的故事。")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

#Preview {
    ContentView()
}
