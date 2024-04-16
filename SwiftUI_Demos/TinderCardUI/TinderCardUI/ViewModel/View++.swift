//
//  View++.swift
//  TinderCardUI
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

extension View {
    func getScreenRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func frame(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}

