//
//  BlurEffect.swift
//  MapBottomSheetView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct BlurEffect: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
    
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
