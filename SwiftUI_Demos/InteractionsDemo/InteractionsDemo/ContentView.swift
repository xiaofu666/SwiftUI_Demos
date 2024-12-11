//
//  ContentView.swift
//  InteractionsDemo
//
//  Created by Xiaofu666 on 2024/12/11.
//

import SwiftUI

struct ContentView: View {
    @State private var effect: InteractionEffect = .tap
    @State private var showView: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $effect) {
                ForEach(InteractionEffect.allCases, id: \.self) { item in
                    Text(item.name)
                }
            }
            .pickerStyle(.segmented)
            
            Spacer()
            
            if showView {
                Interactions(effect: effect) { size, showsTouch, isAnimated in
                    switch effect {
                    case .tap:
                        PressView(animates: isAnimated, scale: 0.95)
                    case .longPress:
                        PressView(animates: isAnimated)
                    case .verticalSwipe:
                        VerticalSwipeView(size, animates: isAnimated)
                    case .horizontalSwipe:
                        HorizontalSwipeView(size, animates: isAnimated)
                    case .pinch:
                        PressView(animates: isAnimated, scale: 1.3)
                    }
                }
            }
        }
        .frame(height: 350)
        .padding()
        .onChange(of: effect) { oldValue, newValue in
            if newValue != oldValue {
                print(newValue)
                showView = false
                Task {
                    effect = newValue
                    showView = true
                }
            }
        }
    }
    
    @ViewBuilder
    func HorizontalSwipeView(_ size: CGSize, animates: Bool) -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
        }
        .offset(x: animates ? -(size.width + 10) : 0)
    }
    
    @ViewBuilder
    func VerticalSwipeView(_ size: CGSize, animates: Bool) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.fill)
                .frame(width: 80, height: 150)
                .frame(width: size.width, height: size.height)
        }
        .offset(y: animates ? -(size.height + 10) : 0)
    }
    
    @ViewBuilder
    func PressView(animates: Bool, scale: CGFloat = 0.9) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.fill)
            .frame(width: 80, height: 150)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(animates ? scale : 1)
    }
}

struct Interactions<Content: View>: View {
    var effect: InteractionEffect
    @ViewBuilder var content: (CGSize, Bool, Bool) -> Content
    @State private var showsTouch: Bool = false
    @State private var animate: Bool = false
    @State private var isStarted: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color.primary, style: .init(lineWidth: 6, lineCap: .round, lineJoin: .round))
            .frame(width: 100, height: 200)
            .background {
                GeometryReader {
                    let size = $0.size
                    content(size, showsTouch, animate)
                }
                .clipped()
            }
            .overlay(alignment: .top) {
                Capsule()
                    .frame(width: 22, height: 7)
                    .offset(y: 7)
            }
            .overlay(alignment: .bottom) {
                Capsule()
                    .frame(width: 32, height: 2)
                    .offset(y: -7)
            }
            .overlay {
                let isSwipe = effect == .verticalSwipe || effect == .horizontalSwipe
                let isPinch = effect == .pinch
                let circleSize: CGFloat = 20
                
                Circle()
                    .fill(.fill)
                    .frame(width: circleSize, height: circleSize)
                    .offset(y: isPinch ? animate ? -40 : 0 : 0)
                    .overlay {
                        if isPinch {
                            Circle()
                                .fill(.fill)
                                .frame(width: circleSize, height: circleSize)
                                .offset(y: isPinch ? animate ? 40 : 0  : 0)
                        }
                    }
                    .opacity(showsTouch ? 1 : 0)
                    .blur(radius: showsTouch ? 0 : 5)
                    .offset(
                        x: effect == .horizontalSwipe ? (animate ? -20 : 25) : 0,
                        y: effect == .verticalSwipe ? (animate ? -50 : 50) : 0
                    )
                    .scaleEffect(isSwipe ? 1 : (isPinch ? 0.8 : (animate ? 0.8 : 1.1)))
            }
            .onAppear {
                guard !isStarted else { return }
                isStarted = true
                
                Task {
                    await animationEffect()
                }
            }
            .onDisappear {
                isStarted = false
            }
    }
    
    private func animationEffect() async {
        guard isStarted else { return }
        
        let isSwipe = effect == .verticalSwipe || effect == .horizontalSwipe
        let isPinch = effect == .pinch
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showsTouch = true
        }
        try? await Task.sleep(for: .seconds(0.5))
        
        if effect == .tap {
            withAnimation(.snappy(duration: 0.25)) {
                animate = true
            }
            
            try? await Task.sleep(for: .seconds(0.25))
        } else {
            withAnimation(.snappy(duration: 1)) {
                animate = true
            }
            
            try? await Task.sleep(for: .seconds(effect == .longPress ? 1.3 : 1.0))
        }
        
        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
            if isSwipe || isPinch {
                showsTouch = false
            } else {
                animate = false
            }
        } completion: {
            if isSwipe {
                animate = false
            }
            
            if isPinch {
                withAnimation(.linear(duration: 0.2)) {
                    animate = false
                }
            }
        }
        
        
        try? await Task.sleep(for: .seconds(effect == .tap ? 0.3 : (isPinch ? 1.0 : 0.6)))
            
        await animationEffect()
    }
}

enum InteractionEffect: CaseIterable {
    case tap
    case longPress
    case verticalSwipe
    case horizontalSwipe
    case pinch
    
    var name: String {
        switch self {
        case .tap:
            "点击手势"
        case .longPress:
            "长按手势"
        case .verticalSwipe:
            "上下滑动"
        case .horizontalSwipe:
            "左右滑动"
        case .pinch:
            "捏合手势"
        }
    }
}

#Preview {
    ContentView()
}
