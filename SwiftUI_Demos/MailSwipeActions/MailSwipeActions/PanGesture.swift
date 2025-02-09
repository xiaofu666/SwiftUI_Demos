//
//  PanGesture.swift
//  MailSwipeActions
//
//  Created by Xiaofu666 on 2025/2/9.
//

import SwiftUI

struct PanGestureValue {
    var translation: CGSize
    var velocity: CGSize
}

struct PanGesture: UIGestureRecognizerRepresentable {
    var onBegin: () -> ()
    var onChange: (PanGestureValue) -> ()
    var onEnded: (PanGestureValue) -> ()
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
                let velocity = panGesture.velocity(in: panGesture.view)
                if abs(velocity.x) > abs(velocity.y) {
                    return true
                } else {
                    return false
                }
            }
            return false
        }
    }
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = context.coordinator
        return panGesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        let state = recognizer.state
        let translation = recognizer.translation(in: recognizer.view).toSize()
        let velocity = recognizer.velocity(in: recognizer.view).toSize()
        
        let gestureValue = PanGestureValue(translation: translation, velocity: velocity)
        switch state {
        case .began:
            onBegin()
        case .changed:
            onChange(gestureValue)
        case .ended, .cancelled:
            onEnded(gestureValue)
        default: break
        }
    }
}

extension CGPoint {
    func toSize() -> CGSize {
        return .init(width: self.x, height: self.y)
    }
}

