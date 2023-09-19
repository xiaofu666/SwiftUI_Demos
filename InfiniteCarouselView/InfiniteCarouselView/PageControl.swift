//
//  PageControl.swift
//  InfiniteCarouselView
//
//  Created by Lurich on 2023/9/19.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    
    var maxPages: Int
    var currentPage: Int
    var backgroundStyle: UIPageControl.BackgroundStyle = .minimal
    var pageIndicatorTintColor: UIColor?
    var currentPageIndicatorTintColor: UIColor?
    var hidesForSinglePage: Bool = false
    
    func makeUIView(context: Context) -> UIPageControl {
        
        let control = UIPageControl()
        control.backgroundStyle = backgroundStyle
        control.numberOfPages = maxPages
        control.currentPage = currentPage
        control.pageIndicatorTintColor = pageIndicatorTintColor
        control.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        control.hidesForSinglePage = hidesForSinglePage
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        
        uiView.currentPage = currentPage
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
