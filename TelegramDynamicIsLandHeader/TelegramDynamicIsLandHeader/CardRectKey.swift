//
//  CardRectKey.swift
//  TelegramDynamicIsLandHeader
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI


struct CardRectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

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
