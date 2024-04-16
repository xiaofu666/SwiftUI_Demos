//
//  SpotLightView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/19.
//

import SwiftUI

@available(iOS 15.0, *)
extension View {
    func spotlight(enabled: Bool, title: String = "") -> some View {
        return self
            .overlay {
                if enabled {
                    GeometryReader { proxy in
                        let rect = proxy.frame(in: .global)
                        SpotLightView(rect: rect, title: title) {
                            self
                        }
                    }
                }
            }
    }
}

@available(iOS 15.0, *)
struct SpotLightView<Content: View>: View {
    var content: Content
    var rect: CGRect
    var title: String
    @State var tag: Int = 1009
    
    init(rect: CGRect, title: String, content: @escaping () -> Content) {
        self.rect = rect
        self.content = content()
        self.title = title
    }
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.02))
            .onAppear {
                addOverlayView()
            }
            .onDisappear {
                removeOverlayView()
            }
    }
    
    private func getCurrentView() -> UIView {
        return getTopController().view
    }
    
    func removeOverlayView() {
        getCurrentView().subviews.forEach { view in
            if view.tag == self.tag {
                view.removeFromSuperview()
            }
        }
    }
    
    func addOverlayView() {
        let hostView = UIHostingController(rootView: overlaySwiftUIView())
        hostView.view.frame = getScreenRect()
        hostView.view.backgroundColor = .clear
        if self.tag == 1009 {
            self.tag = generateRandom()
        }
        hostView.view.tag = self.tag
        
        getCurrentView().subviews.forEach { view in
            if view.tag == self.tag { return }
        }
        getCurrentView().addSubview(hostView.view)
    }
    
    @ViewBuilder
    func overlaySwiftUIView() -> some View {
        ZStack {
            Rectangle()
                .fill(.primary.opacity(0.8))
                .mask({
                    let radius: CGFloat = 8
                    Rectangle()
                        .overlay {
                            content
                                .frame(width: rect.width, height: rect.height)
                                .padding(5)
                                .background(.white, in: RoundedRectangle(cornerRadius: radius))
                                .position()
                                .offset(x: rect.midX, y: rect.midY)
                                .blendMode(.destinationOut)
                        }
                })
            let offsetY: CGFloat = 100
            if !title.isEmpty {
                Text(title)
                    .font(.title.bold())
                    .foregroundStyle(.background)
                    .position()
                    .offset(x: getScreenRect().midX, y: rect.maxY > (getScreenRect().height - offsetY) ? (rect.minY - offsetY) : (rect.maxY + offsetY))
                    .padding()
                    .lineLimit(2)
            }
        }
        .frame(width: getScreenRect().width, height: getScreenRect().height)
        .ignoresSafeArea()
    }
    
    func generateRandom() -> Int {
        let random = Int(UUID().uuid.0)
        let subViews = getCurrentView().subviews
        for index in subViews.indices {
            if subViews[index].tag == random {
                return generateRandom()
            }
        }
        return random
    }
}


@available(iOS 15.0, *)
struct SpotLightView_Previews: PreviewProvider {
    static var previews: some View {
        SpotLightTestView()
    }
}
