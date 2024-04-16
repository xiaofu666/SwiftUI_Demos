//
//  OffsetKey.swift
//  ImageViewer
//
//  Created by Lurich on 2023/12/12.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { _, anchor in
            anchor
        }
    }
}

