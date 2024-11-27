//
//  Snapshot.swift
//  ViewSnapshot
//
//  Created by Xiaofu666 on 2024/10/31.
//

import SwiftUI

extension View {
    @ViewBuilder
    func snapshot(trigger: Bool, onComplete: @escaping (UIImage) -> ()) -> some View {
        self
            .modifier(SnapshotModifier(trigger: trigger, onComplete: onComplete))
    }
}

fileprivate struct SnapshotModifier: ViewModifier {
    var trigger: Bool
    var onComplete: (UIImage) -> ()
    @State private var view: UIView = .init()
    
    func body(content: Content) -> some View {
        content
            .background(ViewExtractor(view: view))
            .compositingGroup()
            .onChange(of: trigger) { oldValue, newValue in
                generateSnapshot()
            }
    }
    
    func generateSnapshot() {
        if let superview = view.superview?.superview {
            let renderer = UIGraphicsImageRenderer(size: superview.bounds.size)
            let image = renderer.image { _ in
                superview.drawHierarchy(in: superview.bounds, afterScreenUpdates: true)
            }
            onComplete(image)
        }
    }
}

fileprivate struct ViewExtractor: UIViewRepresentable {
    var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    ContentView()
}
