//
//  CustomTabBar.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/28.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Image(systemName: tab.rawValue)
                        .font(.title)
                        .foregroundStyle(.background)
                        .offset(y: offset(tab))
                        .contentShape(.rect)
                        .onTapGesture {
                            withAnimation(.spring) {
                                activeTab = tab
                            }
                        }
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .padding(.bottom, safeArea.bottom == 0 ? 30 : safeArea.bottom)
        .background {
            ZStack {
                TabBarTopCurve()
                    .stroke(.background, lineWidth: 0.5)
                    .blur(radius: 0.5)
                    .padding(.horizontal, -10)
                
                TabBarTopCurve()
                    .fill(.ultraThinMaterial)
                
                TabBarTopCurve()
                    .fill(Color.primary.opacity(0.5).gradient)
            }
        }
        .overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .global)
                let width = rect.width
                let height = rect.height
                let maxWidth = width * 5
                
                Circle()
                    .fill(.clear)
                    .frame(width: maxWidth, height: maxWidth)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                Color.secondary,
                                Color.primary,
                                Color.primary
                            ], startPoint: .top, endPoint: .bottom))
                            .mask(alignment: .top) {
                                Circle()
                                    .frame(width: maxWidth, height: maxWidth, alignment: .top)
                            }
                    }
                    .overlay {
                        Circle()
                            .stroke(.background, lineWidth: 0.3)
                            .blur(radius: 0.5)
                    }
                    .frame(width: width)
                    .background {
                        Rectangle()
                            .fill(.background)
                            .frame(width: 45, height: 4)
                            .glow(.white.opacity(0.5), radius: 50)
                            .glow(.blue.opacity(0.7), radius: 30)
                            .offset(y: -1.5)
                            .offset(y: -maxWidth / 2)
                            .rotationEffect(.init(degrees: calculateRotation(maxedWidth: maxWidth / 2, actualWidth: width, true)))
                            .rotationEffect(.init(degrees: calculateRotation(maxedWidth: maxWidth / 2, actualWidth: width, false)))
                    }
                    .offset(y: height / 2.1)
            }
            .overlay(alignment: .bottom) {
                Text(activeTab.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.background)
                    .offset(y: safeArea.bottom == 0 ? -15 : -safeArea.bottom + 12)
            }
        }
//        .preferredColorScheme(.dark)
    }
    
    func calculateRotation(maxedWidth y: CGFloat, actualWidth: CGFloat, _ isInitial: Bool = false) -> CGFloat {
        let tabWidth = actualWidth / Tab.count
        let firstTabPositionX: CGFloat = -(actualWidth - tabWidth) / 2
        let tan = y / firstTabPositionX
        let radians = atan(tan)
        let degree = radians * 180 / .pi
        if isInitial {
            return -(degree + 90)
        }
        let x = tabWidth * activeTab.index
        let tan_ = y / x
        let radians_ = atan(tan_)
        let degree_ = radians_ * 180 / .pi
        return -(degree_ - 90)
    }
    
    func offset(_ tab: Tab) -> CGFloat {
        let totalIndices = Tab.count
        let currentIndex = tab.index
        let progress = currentIndex / totalIndices
        return progress < 0.5 ? currentIndex * -10 : (totalIndices - currentIndex - 1) * -10
    }
}

struct TabBarTopCurve: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width
            let height = rect.height
            let midWidth = width / 2
            path.move(to: .init(x: 0, y: 5))
            path.addCurve(to: .init(x: midWidth, y: -20), control1: .init(x: midWidth / 2, y: -20), control2: .init(x: midWidth, y: -20))
            path.addCurve(to: .init(x: width, y: 5), control1: .init(x: midWidth + midWidth / 2, y: -20), control2: .init(x: width, y: 5))
            path.addLine(to: .init(x: width, y: height))
            path.addLine(to: .init(x: 0, y: height))
            path.closeSubpath()
        }
    }
}

#Preview {
    ContentView()
}
