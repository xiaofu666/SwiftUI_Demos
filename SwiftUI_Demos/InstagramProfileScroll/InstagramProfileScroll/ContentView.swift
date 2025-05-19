//
//  ContentView.swift
//  InstagramProfileScroll
//
//  Created by Xiaofu666 on 2025/5/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HeaderPageScrollView(displaysSymbols: false) {
            RoundedRectangle(cornerRadius: 30)
                .fill(.blue.gradient)
                .frame(height: 350)
                .padding(15)
        } labels: {
            PageLabel(title: "Posts", symbolImage: "square.grid.3x3.fil1")
            PageLabel(title: "Reels", symbolImage: "photo.stack.fill")
            PageLabel(title: "Tagged", symbolImage: "person.crop.rectangle")
        } pages: {
            DummyView(.red, count: 50)
            DummyView(.green, count: 10)
            DummyView(.purple, count: 5)
        } onRefresh: { index in
            print("Refresh data for \(index) page")
        }
    }
    
    /// Dummy Looping View
    @ViewBuilder
    private func DummyView(_ color: Color, count: Int) -> some View {
        LazyVStack(spacing: 12) {
            ForEach(0..<count,id:\.self) { index in
                RoundedRectangle(cornerRadius:12)
                    .fill(color.gradient)
                    .frame(height: 45)
            }
        }
        .padding(15)
    }
}

#Preview {
    ContentView()
}
