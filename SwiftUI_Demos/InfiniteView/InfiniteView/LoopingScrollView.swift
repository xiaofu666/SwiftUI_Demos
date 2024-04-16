//
//  LoopingScrollView.swift
//  InfiniteView
//
//  Created by Lurich on 2023/11/27.
//

import SwiftUI

struct LoopingScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    var width: CGFloat
    var spacing: CGFloat = 0
    var items: Item
    @ViewBuilder var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let repeatingCount = width > 0 ? (Int((size.width / width).rounded()) + 1) : 1
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: width)
                    }
                    
                    ForEach(0 ..< repeatingCount, id: \.self) { index in
                        let item = Array(items)[index % items.count]
                        content(item)
                            .frame(width: width)
                    }
                }
                .background() {
                    ScrollViewHelper(width: width, spacing: spacing, itemsCount: items.count, repeatingCount: repeatingCount)
                }
            }
        }
    }
}

fileprivate struct ScrollViewHelper: UIViewRepresentable {
    var width: CGFloat
    var spacing: CGFloat
    var itemsCount: Int
    var repeatingCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(width: width, spacing: spacing, itemsCount: itemsCount, repeatingCount: repeatingCount)
    }
    
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isAdded = true
            }
            context.coordinator.width = width
            context.coordinator.spacing = spacing
            context.coordinator.itemsCount = itemsCount
            context.coordinator.repeatingCount = repeatingCount
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemsCount: Int
        var repeatingCount: Int
        
        init(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemsCount = itemsCount
            self.repeatingCount = repeatingCount
        }
        
        var isAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard itemsCount > 0 else { return }
            let minX = scrollView.contentOffset.x
            let mainContentSize = CGFloat(itemsCount) * width
            let spacingSize = CGFloat(itemsCount) * spacing
            let sumLength = mainContentSize + spacingSize
            if minX > sumLength {
                scrollView.contentOffset.x -= sumLength
            }
            if minX < 0 {
                scrollView.contentOffset.x += sumLength
            }
        }
    }
}

#Preview {
    ContentView()
}
