//
//  View+Extension.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/8/10.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
