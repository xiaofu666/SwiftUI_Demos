//
//  InfiniteCarouselView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/29.
//

import SwiftUI

@available(iOS 15.0, *)
struct InfiniteCarouselView: View {
    @State private var currentPage: String = UUID().uuidString
    @State private var listPages: [Post] = posts
    @State private var fakePages: [Post] = []
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $currentPage) {
                ForEach(fakePages) { page in
                    Image(page.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .tag(page.id)
                        .getGlobalRect(currentPage == page.id) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(fakeIndex(page)))
                            let pageProgress = pageOffset / size.width
                            if -pageOffset < 1 {
                                if fakePages.indices.contains(fakePages.count - 2) {
                                    currentPage = fakePages[fakePages.count - 2].id
                                }
                            }
                            if -pageProgress >= CGFloat(fakePages.count - 1) {
                                if fakePages.indices.contains(1) {
                                    currentPage = fakePages[1].id
                                }
                            }
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                PageControl(maxPages: listPages.count, currentPage: originalIndex(currentPage), backgroundStyle: .prominent)
                    .offset(y: -15)
            }
        }
        .frame(height: 400)
        .onAppear {
            fakePages.append(contentsOf: listPages)
            
            if var firstPage = listPages.first, var lastPage = listPages.last {
                firstPage.id = UUID().uuidString
                lastPage.id = UUID().uuidString
                
                currentPage = firstPage.id
                fakePages.append(firstPage)
                fakePages.insert(lastPage, at: 0)
            }
        }
    }
    
    func fakeIndex(_ page: Post) -> Int {
        return fakePages.firstIndex(of: page) ?? 0
    }
    
    func originalIndex(_ id: String) -> Int {
        return listPages.firstIndex { page in
            page.id == id
        } ?? 0
    }
}

@available(iOS 15.0, *)
struct InfiniteCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteCarouselView()
    }
}
