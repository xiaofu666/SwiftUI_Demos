//
//  View++.swift
//  PayListView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

enum Ubuntu {
    case light
    case bold
    case medium
    case regular
    
    var weight: Font.Weight {
        switch self {
            case .light:
                return .light
            case .bold:
                return.bold
            case .medium:
                return .medium
            case.regular:
                return .regular
        }
    }
}

extension View {
    func ubuntu(_ size: CGFloat, _ weight: Ubuntu) -> some View {
        self.font(.custom("", size: size))
            .fontWeight(weight.weight)
    }
    
    func hAligm(_ aligment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: aligment)
    }
    
    func vAligm(_ aligment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: aligment)
    }
}
