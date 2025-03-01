//
//  SearchView.swift
//  AppleBooks
//
//  Created by Xiaofu666 on 2025/3/1.
//

import SwiftUI

struct SearchView: View {
    @State private var activeID: String? = books.first?.id
    @State private var scrollPosition: ScrollPosition = .init(idType: String.self)
    @State private var isAnyBookCardScrolled: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(books) { book in
                        BookCardView(book: book, size: proxy.size) { isScrolled in
                            isAnyBookCardScrolled = isScrolled
                        }
                        .frame(width: proxy.size.width - 30)
                        .zIndex(activeID == book.id ? 1000 : 1)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(15)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollPosition($scrollPosition)
            .scrollDisabled(isAnyBookCardScrolled)
            .onChange(of: scrollPosition.viewID(type: String.self)) { oldValue, newValue in
                activeID = newValue
            }
        }
    }
}

#Preview {
    SearchView()
}
