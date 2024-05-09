//
//  UICoordinator.swift
//  PinterestGridAnimation
//
//  Created by Lurich on 2024/5/9.
//

import SwiftUI

@Observable
class UICoordinator {
    /// 主视图和局部视图之间的共享视图特性
    var scrollview: UIScrollView = .init(frame: .zero)
    var rect: CGRect = .zero
    var selectedItem: Item?
    /// 动画层属性
    var animationLayer: UIImage?
    var animateView: Bool = false
    var hideLayer: Bool = false
    /// 根视图属性
    var hideRootView: Bool = false
    var headerOffset: CGFloat = .zero
    
    // 获取ScrollView滚动视图可见区域的屏幕快照
    func createVisibleAreaSnapshot() {
        let renderer = UIGraphicsImageRenderer(size: scrollview.bounds.size)
        let image = renderer.image { context in
            context.cgContext.translateBy(x: -scrollview.contentOffset.x, y: -scrollview.contentOffset.y)
            scrollview.layer.render(in: context.cgContext)
        }
        animationLayer = image
    }
    
    func toggleView(show: Bool, frame: CGRect, post: Item) {
        if show {
            selectedItem = post
            rect = frame
            createVisibleAreaSnapshot()
            hideRootView = true
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.hideLayer = true
            }
        } else {
            hideLayer = false
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = false
            } completion: {
                DispatchQueue.main.async {
                    self.resetAnimationProperties()
                }
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        hideRootView = false
        headerOffset = .zero
        animationLayer = nil
    }
}
struct ScrollViewExtractor: UIViewRepresentable {
    var result: (UIScrollView) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            if let scrollView = view.superview?.superview?.superview as? UIScrollView {
                result(scrollView)
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

extension View {
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
    @ViewBuilder
    func offsetY(result: @escaping (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader {
                let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        result(value)
                    })
            }
        }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
