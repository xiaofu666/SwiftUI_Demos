//
//  View++.swift
//  ElasticScrollView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

extension View {
    @ViewBuilder
    func getRectFor(key coordinateSpace: String, completion: @escaping (CGRect) -> ()) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named(coordinateSpace))
                Color.clear
                    .preference(key: RectKey.self, value:rect)
                    .onPreferenceChange(RectKey.self) { value in
                        completion(value)
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
