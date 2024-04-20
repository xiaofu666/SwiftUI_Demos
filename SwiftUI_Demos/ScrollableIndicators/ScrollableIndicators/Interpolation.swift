//
//  Interpolation.swift
//  ScrollableIndicators
//
//  Created by Lurich on 2024/4/20.
//

import SwiftUI

extension CGFloat {
    func interpolate(inputRange:[CGFloat], outputRange:[CGFloat]) -> CGFloat {
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return outputRange[0] }
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            if x <= inputRange[index] {
                let y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
                return y
            }
        }
        return outputRange[length]
    }
}
