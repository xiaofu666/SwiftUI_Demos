//
//  CustomMenuView.swift
//  iMessageAnimation
//
//  Created by Xiaofu666 on 2025/5/28.
//

import SwiftUI

struct CustomMenuView<Content: View>: View {
    @Binding var config: MenuConfig
    @ViewBuilder var content: Content
    @MenuActionBuilder var actions: [MenuAction]
    @State private var animateContent: Bool = false
    @State private var animateLabels: Bool = false
    @State private var activeActionID: String?
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                // 模糊覆盖
                Rectangle()
                    .fill(.bar)
                    .ignoresSafeArea()
                    .opacity(animateContent ? 1 : 0)
                    .allowsHitTesting(false)
            }
            .overlay {
                if animateContent {
                    // Instead of using withAnimation completion callback, I'm using onDisappear modifierto know when the animation get's completed!
                    Rectangle()
                        .foregroundStyle(.clear)
                        .contentShape(.rect)
                        .onDisappear {
                            config.hideSourceView = false
                            activeActionID = actions.first?.id
                        }
                }
            }
            .overlay {
                GeometryReader { proxy in
                    MenuScrollView(proxy)
                    
                    if config.hideSourceView {
                        config.sourceView
                            .scaleEffect(animateContent ? 15 : 1, anchor: .bottom)
                            .offset(x: config.sourceLocation.minX, y: config.sourceLocation.minY)
                            .opacity(animateContent ? 0.25 : 1)
                            .blur(radius:animateContent ? 130 : 0)
                            .ignoresSafeArea()
                            .allowsHitTesting(false)
                    }
                }
                .opacity(config.hideSourceView ? 1 : 0)
            }
            .onChange(of: config.showMenu) { oldValue, newValue in
                if newValue {
                    config.hideSourceView = true
                }
                // Change the animation, as per your needs!
                withAnimation(.smooth(duration: 0.45, extraBounce: 0)) {
                    animateContent = newValue
                }
                // Change the animation, as per your needs!
                withAnimation(.easeInOut(duration: newValue ? 0.35 : 0.15)) {
                    animateLabels = newValue
                }
            }
    }
    
    // Menu Scroll View
    @ViewBuilder
    func MenuScrollView(_ proxy: GeometryProxy) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(actions) { action in
                    MenuActionView(action)
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity, alignment:.leading)
            // For background tap to dismiss the menu view
            .background {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: proxy.size.width, height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom)
                    .contentShape(.rect)
                    .onTapGesture {
                        guard config.showMenu else { return }
                        config.showMenu = false
                    }
                    .visualEffect { content, proxy in
                        content
                            .offset(
                                x: -proxy.frame(in: .global).minX,
                                y: -proxy.frame(in: .global).minY
                            )
                    }
            }
        }
        .safeAreaPadding(.vertical, 20)
        .safeAreaPadding(.top, (proxy.size.height - 70) / 2)
        .scrollPosition(id: $activeActionID, anchor: .top)
        .scrollIndicators(.hidden)
        .allowsHitTesting(config.showMenu)
    }
    
    // 菜单操作视图
    @ViewBuilder
    func MenuActionView(_ action: MenuAction) -> some View {
        let sourceLocation = config.sourceLocation
        
        HStack(spacing: 20) {
            Image(systemName: action.symbolImage)
                .font(.title3)
                .frame(width: 40, height: 40)
                .background {
                    Circle()
                        .fill(.background)
                        .shadow(radius: 1.5)
                }
                .scaleEffect(animateContent ? 1 : 0.6)
                .opacity(animateContent ? 1 : 0)
                .blur(radius: animateContent ? 0 : 4)

            
            Text(action.text)
                .font(.system(size: 19))
                .fontWeight(.medium)
                .lineLimit(1)
                .opacity(animateLabels ? 1 : 0)
                .blur(radius: animateLabels ? 0 : 4)
        }
        .visualEffect { [animateContent] content, proxy in
            content
                .offset(
                    // 将所有操作放置在源按钮位置
                    x: animateContent ? 0 : sourceLocation.minX - proxy.frame(in: .global).minX,
                    y: animateContent ? 0 : sourceLocation.minY - proxy.frame(in: .global).minY
                )
        }
        .frame(height: 70)
        .contentShape(.rect)
        .onTapGesture {
            config.showMenu = false
            action.action()
        }
    }
}

#Preview {
    ContentView()
}

// 自定义源按钮
struct MenuSourceButton<Content: View>: View {
    @Binding var config: MenuConfig
    @ViewBuilder var content: Content
    var onTap: () -> ()
    
    var body: some View {
        content
            .contentShape(.rect)
            .onTapGesture {
                onTap()
                config.sourceView = .init(content)
                config.showMenu.toggle()
            }
            // 保存源位置
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action:{ newValue in
                config.sourceLocation = newValue
            }
            // 启用隐藏源代码视图时隐藏源代码视图
            .opacity(config.hideSourceView ? 0.01 : 1)
    }
}

// Menu Config
struct MenuConfig {
    var symbolImage: String
    var sourceLocation: CGRect = .zero
    var showMenu: Bool = false
    // 存储源代码视图（标签）以实现缩放效果！
    var sourceView: AnyView = .init(EmptyView())
    var hideSourceView: Bool = false
}

// Menu Action & Action Builder
struct MenuAction: Identifiable {
    private(set) var id: String = UUID().uuidString
    var symbolImage: String
    var text: String
    var action: () -> () = { }
}

@resultBuilder
struct MenuActionBuilder {
    static func buildBlock(_ components: MenuAction...) -> [MenuAction] {
        components.compactMap({ $0 })
    }
}
