//
//  ProgressiveBlurView.swift
//  Custom_Header
//
//  Created by Xiaofu666 on 2024/8/17.
//

import SwiftUI

struct ProgressiveBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomBlurView {
        let view = CustomBlurView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: CustomBlurView, context: Context) {
        
    }
}

class CustomBlurView: UIVisualEffectView {
    init() {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        removeFilters()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
            DispatchQueue.main.async {
                self.removeFilters()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeFilters() {
        if let filterLayer = layer.sublayers?.first {
            filterLayer.filters = []
        }
    }
}
