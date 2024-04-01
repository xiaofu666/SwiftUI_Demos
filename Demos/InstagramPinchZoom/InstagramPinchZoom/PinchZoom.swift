//
//  PinchZoom.swift
//  InstagramPinchZoom
//
//  Created by Lurich on 2024/3/30.
//

import SwiftUI

extension View {
    @ViewBuilder
    func pinchZoom(_ dimsBackground: Bool = true) -> some View {
        PinchZoomHelper(dimsBackground: dimsBackground) {
            self
        }
    }
}

/// Zoom Container View
/// Where the Zooming View will be displayed and zoomed
struct ZoomContainer<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    private var containerData = ZoomContainerData()
    
    var body: some View {
        GeometryReader { _ in
            content
                .environment(containerData)
            
            ZStack(alignment:.topLeading) {
                if let view = containerData.zoomingView {
                    Group {
                        if containerData.dimsBackground {
                            Rectangle()
                                .fill(.black.opacity(0.2))
                                .opacity(containerData.zoom - 1)
                        }
                        
                        view
                            .scaleEffect(containerData.zoom, anchor: containerData.zoomAnchor)
                            .offset(containerData.dragOffset)
                            /// View Position
                            .offset(x: containerData.viewRect.minX,
                                    y: containerData.viewRect.minY)
                    }
                }
            }
            .ignoresSafeArea()

        }
    }
}

/// Observable Class to share data between Container and it's Views inside it
@Observable
fileprivate class ZoomContainerData {
    var zoomingView: AnyView?
    var viewRect: CGRect = .zero
    var dimsBackground: Bool = false
    /// View Properties
    var zoom: CGFloat = 1
    var zoomAnchor: UnitPoint = .center
    var dragOffset: CGSize = .zero
    var isResetting: Bool = false
}

fileprivate struct PinchZoomHelper<Content: View>: View {
    var dimsBackground: Bool
    @ViewBuilder var content: Content
    @Environment(ZoomContainerData.self) private var containerData
    @State private var config: Config = .init()
    
    var body: some View {
        content
            .opacity(config.hidesSourceView ? 0 : 1)
            .overlay(GestureOverlay(config: $config))
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    Color.clear
                        .onChange(of: config.isGestureActive) { oldValue,newValue in
                            if newValue {
                                guard !containerData.isResetting else { return }
                                // Showing View on Zoom Container
                                containerData.viewRect = rect
                                containerData.zoomAnchor = config.zoomAnchor
                                containerData.dimsBackground = dimsBackground
                                containerData.zoomingView = .init(erasing: content)
                                /// Hiding Source View
                                config.hidesSourceView = true
                            } else {
                                // Resetting to it's Initial Position With Animation
                                containerData.isResetting = true
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0),
                                              completionCriteria:.logicallyComplete) {
                                    containerData.dragOffset = .zero
                                    containerData.zoom = 1
                                } completion: {
                                    /// Resetting Config
                                    config = .init()
                                    /// Removing View From Container Layer
                                    containerData.zoomingView = nil
                                    containerData.isResetting = false
                                }
                            }
                        }
                        .onChange(of: config) { oldValue,  newValue in
                            if config.isGestureActive && !containerData.isResetting {
                                /// Updating View's Position and Scale in Zoom Container
                                containerData.zoom = config.zoom
                                containerData.dragOffset = config.dragOffset
                            }
                            
                        }
                }
            }
    }
}

fileprivate struct GestureOverlay: UIViewRepresentable {
    @Binding var config: Config
    func makeCoordinator() -> Coordinator {
        Coordinator(config: $config)
    }
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        /// Pan Gesture
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = "PANGESTURE"
        panGesture.minimumNumberOfTouches = 2
        panGesture.addTarget(context.coordinator,action: #selector(Coordinator.panGesture(gesture:)))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)
        /// Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.name = "PINCHGESTURE"
        pinchGesture.addTarget(context.coordinator,action: #selector(Coordinator.pinchGesture(gesture:)))
        pinchGesture.delegate = context.coordinator
        view.addGestureRecognizer(pinchGesture)
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @Binding var config: Config
        init(config: Binding<Config>) {
            self._config = config
        }
        
        @objc
        func panGesture(gesture: UIPanGestureRecognizer) {
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: gesture.view)
                config.dragOffset = .init(width: translation.x, height: translation.y)
                config.isGestureActive = true
            } else {
                config.isGestureActive = false
            }
        }
        
        @objc
        func pinchGesture(gesture: UIPinchGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view)
                if let bounds = gesture.view?.bounds {
                    config.zoomAnchor = .init(x: location.x / bounds.width, y: location.y / bounds.height)
                }
            }
            if gesture.state == .began || gesture.state == .changed {
                let scale = max(gesture.scale, 1)
                config.zoom = scale
                config.isGestureActive = true
            } else {
                config.isGestureActive = false
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer.name == "PANGESTURE" && otherGestureRecognizer.name == "PINCHGESTURE" {
                return true
            }
            return false
        }
    }
}

/// Config
fileprivate struct Config: Equatable {
    var isGestureActive: Bool = false
    var zoom: CGFloat = 1
    var zoomAnchor: UnitPoint = .center
    var dragOffset: CGSize = .zero
    var hidesSourceView: Bool = false
}

#Preview {
    ZoomContainer {
        ContentView()
    }
}
