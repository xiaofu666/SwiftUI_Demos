//
//  CustomHeaderView.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/29.
//

import SwiftUI

struct CustomHeaderView: View {
    let size: CGSize
    @State private var activeTab: HeaderTab = .chat
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @State private var dragProgress: CGFloat = 0
    @Namespace private var animation
    
    var body: some View {
        let height = size.height + safeArea.top
        
        VStack {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        SwiftUI.Tab.init(value: HeaderTab.chat) {
                            Text(HeaderTab.chat.title)
                        }
                        SwiftUI.Tab.init(value: HeaderTab.friends) {
                            Text(HeaderTab.friends.title)
                        }
                    }
                } else {
                    TabView(selection: $activeTab) {
                        Text(HeaderTab.chat.title)
                            .tag(HeaderTab.chat)
                        Text(HeaderTab.friends.title)
                            .tag(HeaderTab.friends)
                    }
                }
            }
            .foregroundStyle(.background)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(dragProgress == 1 ? .snappy(duration: 0.25) : .none, value: activeTab)
            .background {
                Rectangle()
                    .fill(Color.primary.gradient)
                    .rotationEffect(.degrees(180))
                    .mask {
                        let isChat: Bool = activeTab == .chat
                        
                        VStack(alignment: isChat ? .leading : .trailing, spacing: 0) {
                            UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15, style: .continuous)
                                .fill(.linearGradient(colors: [
                                    Color.clear,
                                    Color.clear,
                                    Color.primary
                                ], startPoint: .top, endPoint: .bottom))
                            
                            if isChat {
                                ActiveHeaderIndicatorShape()
                                    .matchedGeometryEffect(id: "ACTIVE_HEADER_TAB", in: animation)
                                    .frame(width: size.width / 2, height: 50)
                            } else {
                                ActiveHeaderIndicatorShape()
                                    .matchedGeometryEffect(id: "ACTIVE_HEADER_TAB", in: animation)
                                    .frame(width: size.width / 2, height: 50)
                                    .scaleEffect(x: -1)
                            }
                        }
                        .compositingGroup()
                    }
                    .shadow(color: Color.primary.opacity(0.3), radius: 6, x: 2, y: 5)
                    .padding(.bottom, -50)
                    .animation(.snappy(duration: 0.25), value: activeTab)
            }
            .offset(y: -150 + 150 * dragProgress)
            
            Rectangle()
                .fill(.clear)
                .frame(height: 50)
        }
        .frame(height: height)
        .offset(y: -(height - 50))
        .offset(y: offset)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 15, style: .continuous)
                .fill(Color.secondary.gradient)
                .rotationEffect(.degrees(180))
                .clipShape(DragIndicatorCutoutShape(progress: dragProgress))
                .overlay(alignment: .bottom) {
                    ArrowIndicator()
                }
                .background {
                    let extraOffset = (dragProgress > 0.8 ? (dragProgress - 0.8) / 0.2 : 0) * 100
                    Rectangle()
                        .fill(Color.primary)
                        .offset(y: extraOffset)
                }
                .offset(y: -(height - 50))
                .offset(y: offset)
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                HeaderTabButton(.chat, alignment: .leading)
                
                Spacer(minLength: 0)
                    .frame(maxWidth: .infinity)
                
                HeaderTabButton(.friends, alignment: .trailing)
            }
            .padding(.horizontal, 25)
            .frame(height: 50)
            .contentShape(.rect)
            .offset(y: -(height - 50))
            .offset(y: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.height + lastOffset
                        offset = max(min(translation, height - safeArea.top - 50), 0.0)
                        dragProgress = offset / (height - safeArea.top - 50)
                    }
                    .onEnded{ value in
                        let velocity = value.velocity.height / 5
                        withAnimation(.snappy(duration: 0.2)) {
                            if (velocity + offset) > height * 0.4 {
                                offset = height - safeArea.top - 50
                                dragProgress = 1
                            } else {
                                offset = 0
                                dragProgress = 0
                            }
                        }
                        lastOffset = offset
                    }
            )
        }
    }
    
    @ViewBuilder
    func HeaderTabButton(_ tab: HeaderTab, alignment: Alignment) -> some View {
        GeometryReader {
            let mid = $0.size.width / 2 - 30
            Image(systemName: tab.rawValue)
                .font(.title3)
                .foregroundStyle(.background)
                .offset(x: mid * (alignment == .leading ? dragProgress : -dragProgress))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                    
                    withAnimation(.snappy(duration: 0.25)) {
                        offset = size.height - 50
                        dragProgress = 1
                    }
                    lastOffset = offset
                }
        }
    }
    
    @ViewBuilder
    func ArrowIndicator() -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(.background)
                .frame(width: 30, height: 4)
                .offset(x: dragProgress * 3)
                .rotationEffect(.degrees(dragProgress * -30), anchor: .center)
            
            Rectangle()
                .fill(.background)
                .frame(width: 30, height: 4)
                .offset(x: dragProgress * -3)
                .rotationEffect(.degrees(dragProgress * 30), anchor: .center)
        }
        .compositingGroup()
        .offset(y: dragProgress * -40)
        .scaleEffect(1 - dragProgress * 0.5)
    }
}

#Preview {
    ContentView()
}
