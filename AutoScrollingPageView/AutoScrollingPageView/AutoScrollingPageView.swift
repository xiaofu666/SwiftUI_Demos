//
//  AutoScrollingPageView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/1.
//

import SwiftUI

@available(iOS 15.0, *)
struct AutoScrollingPageView: View {
    @State var currentSel = posts[0]
    @State var scrollProgress: CGFloat = .zero
    @State var endAnimation: Bool = true
    var body: some View {
        GeometryReader { proxy in
            VStack {
                tabIndicatorView()
                
                TabView(selection: $currentSel) {
                    ForEach(posts) { post in
                        tabImageVIew(post)
                            .tag(post)
                            .getGlobalRect(currentSel == post) { rect in
                                let minX = rect.minX
                                let pageOffset = minX - (proxy.size.width * CGFloat(getIndex(post)))
                                let pageProgress = pageOffset / proxy.size.width
                                if endAnimation {
                                    withAnimation {
                                        scrollProgress = max(min(pageProgress, 0), CGFloat(-(posts.count - 1)))
                                    }
                                }
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
    }
    
    @ViewBuilder
    func tabIndicatorView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let tabWidth = size.width / 3
            HStack(spacing: 0) {
                ForEach(posts) { post in
                    Text(post.title)
                        .font(.title3.bold())
                        .foregroundColor(currentSel == post ? .primary : .gray)
                        .frame(width: tabWidth)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentSel = post
                                scrollProgress = CGFloat(-(getIndex(post)))
                                endAnimation = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                endAnimation = true
                            }
                        }
                }
            }
            .frame(width: tabWidth * CGFloat(posts.count))
            .padding(.leading, tabWidth)
            .offset(x: scrollProgress * tabWidth)
        }
        .frame(height: 50)
        .padding(.top, 15)
    }
    
    @ViewBuilder
    func tabImageVIew(_ post: Post) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            Image(post.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    func getIndex(_ post: Post) -> Int {
        return posts.firstIndex(of: post) ?? 0
    }
}

@available(iOS 15.0, *)
struct AutoScrollingPageView_Previews: PreviewProvider {
    static var previews: some View {
        AutoScrollingPageView()
    }
}

extension View {
    @ViewBuilder
    func getGlobalRect(_ addObserver: Bool = false, completion:@escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
            if addObserver {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: completion)
                }
            }
        }
    }
}
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
