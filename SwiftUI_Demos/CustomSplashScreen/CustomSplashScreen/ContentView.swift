//
//  ContentView.swift
//  CustomSplashScreen
//
//  Created by Xiaofu666 on 2024/9/18.
//

import SwiftUI

struct ContentView: View {
    @State private var showsSplashScreen: Bool = true
    
    var body: some View {
        ZStack {
            if showsSplashScreen {
                SplashScreenView()
                    .transition(CustomSplashTransition(isRoot: false))
            } else {
                RootView()
                    .transition(CustomSplashTransition(isRoot: true))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .ignoresSafeArea()
        .task {
            guard showsSplashScreen else { return }
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.smooth(duration: 0.55)) {
                showsSplashScreen = false
            }
        }
    }
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
}

struct CustomSplashTransition1: Transition {
    var isRoot: Bool
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: phase.isIdentity ? 0 : isRoot ? screenSize.height : -screenSize.height)
    }
    
    var screenSize: CGSize {
        if let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return size
        }
        return .zero
    }
}

struct CustomSplashTransition: Transition {
    var isRoot: Bool
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .rotation3DEffect(
                .degrees(
                    phase.isIdentity ? 0 : isRoot ? 70 : -70
                ),
                axis: (
                    x: 0,
                    y: 1,
                    z: 0
                ),
                anchor: isRoot ? .leading : .trailing
            )
            .offset(x: phase.isIdentity ? 0 : isRoot ? screenSize.width : -screenSize.width)
    }
    
    var screenSize: CGSize {
        if let size = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return size
        }
        return .zero
    }
}

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.splashBackground)
            
            Image(.appLogo)
        }
        .ignoresSafeArea()
    }
}

struct RootView: View {
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house") {
                Text("Home")
            }
            Tab.init("Search", systemImage: "magnifyingglass") {
                Text("Search")
            }
            Tab.init("Settings", systemImage: "gearshape") {
                Text("Settings")
            }
        }
    }
}

#Preview {
    ContentView()
}
