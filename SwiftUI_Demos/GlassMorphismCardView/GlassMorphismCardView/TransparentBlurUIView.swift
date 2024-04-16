//
//  TransparentBlurUIView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/27.
//

import SwiftUI

struct TransparentBlurUIView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    func makeUIView(context: Context) -> TransparentBlurUIViewHelper {
        return TransparentBlurUIViewHelper(removeAllFilters: removeAllFilters)
    }
    func updateUIView(_ uiView: TransparentBlurUIViewHelper, context: Context) {
        
    }
}

class TransparentBlurUIViewHelper: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0
        }
        
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
}

#Preview {
    TransparentBlurUIView()
}
