//
//  AnchorKey.swift
//  ProgressHeroEffect
//
//  Created by Lurich on 2023/10/14.
//

import SwiftUI

struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { _, value in
            value
        }
    }
}
