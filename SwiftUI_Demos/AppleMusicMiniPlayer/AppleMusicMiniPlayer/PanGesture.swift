//
//  PanGesture.swift
//  AppleMusicMiniPlayer
//
//  Created by Xiaofu666 on 2024/10/30.
//

import SwiftUI

struct PanGesture: UIGestureRecognizerRepresentable {
    var onChange: (Value) -> ()
    var onEnd: (Value) -> ()
    
    func makeUIGestureRecognizer(context: Context) -> some UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIGestureRecognizerType, context: Context) {
        
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIGestureRecognizerType, context: Context) {
        let state = recognizer.state
        let translation = recognizer.location(in: recognizer.view).toSize()
        let velocity = recognizer.velocity(in: recognizer.view).toSize()
        let value = Value(translation: translation, velocity: velocity)
        if state == .began || state == .changed {
            onChange(value)
        } else {
            onEnd(value)
        }
    }
    
    struct Value {
        var translation: CGSize
        var velocity: CGSize
    }
}

extension CGPoint {
    func toSize() -> CGSize {
        return .init(width: x, height: y)
    }
}
