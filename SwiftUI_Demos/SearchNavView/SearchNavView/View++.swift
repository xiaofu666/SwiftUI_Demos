//
//  View++.swift
//  SearchNavView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
extension View {
    @ViewBuilder
    func getMinY(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: coordinateSpace).minY
                Color.clear
                    .preference(key: OffsetKey.self, value:minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}
