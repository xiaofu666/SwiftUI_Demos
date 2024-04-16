//
//  UniversalAlert.swift
//  CustomUniversalAlert
//
//  Created by Lurich on 2023/9/20.
//

import SwiftUI

struct AlertConfig {
    // 背景模糊化
    fileprivate var enableBackgroundBlur: Bool = true
    // 背景区域不能点击关闭，默认为true
    fileprivate var disableOutsideTap: Bool = true
    fileprivate var transitionType: TransitionType = .slide
    fileprivate var slideEdge: Edge = .bottom
    fileprivate var show: Bool = false
    fileprivate var showView: Bool = false
    
    init(enableBackgroundBlur: Bool = true, disableOutsideTap: Bool = true, transitionType: TransitionType = .slide, slideEdge: Edge = .bottom) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }
    
    enum TransitionType {
        case slide
        case opacity
    }
    
    mutating
    func present() {
        show = true
    }
    
    mutating
    func dismiss() {
        show = false
    }
}

@Observable
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

@Observable
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    var overlayWindow: UIWindow?
    var tag: Int = 0
    var alerts: [UIView] = []
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
        setupOverlayWindow()
    }
    
    private func setupOverlayWindow() {
        guard let windowScene = windowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.isHidden = true
        window.isUserInteractionEnabled = false
        self.overlayWindow = window
        print("add window")
    }
    
    fileprivate func alert<Content: View>(config: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content, viewTag: @escaping (Int) -> ()) {
        guard let alertWindow = overlayWindow else { return }
        let viewController = UIHostingController(rootView: AlertView(config: config, tag: tag, content: {
            content()
        }))
        viewController.view.backgroundColor = .clear
        viewController.view.tag = tag
        viewTag(tag)
        tag += 1
        if alertWindow.rootViewController == nil {
            alertWindow.rootViewController = viewController
            alertWindow.isHidden = false
            alertWindow.isUserInteractionEnabled = true
        } else {
            viewController.view.frame = alertWindow.rootViewController?.view.frame ?? .zero
            alerts.append(viewController.view)
        }
    }
}

fileprivate struct AlertView<Content: View>: View {
    @Binding var config: AlertConfig
    var tag: Int
    @ViewBuilder var content: () -> Content
    @State private var showView: Bool = false
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                if config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.primary.opacity(0.25))
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !config.disableOutsideTap {
                    config.dismiss()
                }
            }
            .opacity(showView ? 1 : 0)
            
            if showView && config.transitionType == .slide {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: config.slideEdge))
            } else {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showView ? 1 : 0)
            }
        })
        .onAppear(perform: {
            config.showView = true
        })
        .onChange(of: config.showView) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                showView = newValue
            }
        }
    }
}

extension View {
    @ViewBuilder
    func alert<Content: View>(alertConfig: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(AlertModifier(config: alertConfig, alertContent: content))
    }
}

fileprivate struct AlertModifier<AlertContent: View>: ViewModifier {
    @Binding var config: AlertConfig
    @ViewBuilder var alertContent: () -> AlertContent
    @Environment(SceneDelegate.self) private var sceneDelegate
    @State private var viewTag: Int = 0
    
    func body(content: Content) -> some View {
        content
            .onChange(of: config.show, initial: false) { oldValue, newValue in
                if newValue {
                    sceneDelegate.alert(config: $config, content: alertContent) { tag in
                        viewTag = tag
                    }
                } else {
                    guard let alertWindow = sceneDelegate.overlayWindow else { return }
                    if config.showView {
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            config.showView = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            if sceneDelegate.alerts.isEmpty {
                                alertWindow.rootViewController = nil
                                alertWindow.isHidden = true
                                alertWindow.isUserInteractionEnabled = false
                            } else {
                                if let first = sceneDelegate.alerts.first {
                                    alertWindow.rootViewController?.view.subviews.forEach({ view in
                                        view.removeFromSuperview()
                                    })
                                    
                                    alertWindow.rootViewController?.view.addSubview(first)
                                    sceneDelegate.alerts.removeFirst()
                                }
                            }
                        }
                    } else {
                        sceneDelegate.alerts.removeAll(where: { $0.tag == viewTag })
                    }
                }
            }
    }
}
