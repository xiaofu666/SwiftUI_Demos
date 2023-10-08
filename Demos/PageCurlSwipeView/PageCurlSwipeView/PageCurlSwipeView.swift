//
//  PageCurlSwipeView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/1.
//

import SwiftUI

@available(iOS 16.0, *)
struct PageCurlSwipeView: View {
    @State private var items: [AppItem] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(items) { item in
                    PeelEffect {
                        cellCardView(item)
                    } onDelete: {
                        //delete
                        if let index = items.firstIndex(where: { tmpItem in
                            tmpItem.id == item.id
                        }) {
                            let _ = withAnimation(.easeInOut(duration: 0.35)) {
                                items.remove(at: index)
                            }
                        }
                    }

                }
            }
            .padding(15)
        }
        .navigationTitle("Page Effect")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            for index in 1...6 {
                items.append(AppItem(name: "user\(index)"))
            }
        }
    }
    
    @ViewBuilder
    func cellCardView(_ model: AppItem) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            Image(model.name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .frame(height: 130)
        .contentShape(Rectangle())
    }
}

@available(iOS 16.0, *)
struct PageCurlSwipeView_Previews: PreviewProvider {
    static var previews: some View {
        PageCurlSwipeView()
    }
}
