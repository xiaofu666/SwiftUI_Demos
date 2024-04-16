//
//  CustomTabBar.swift
//  NetflixUI
//
//  Created by Lurich on 2024/4/13.
//

import SwiftUI

struct CustomTabBar: View {
    @Environment(AppData.self) private var appData
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button {
                    appData.activeTab = tab
                } label: {
                    VStack(spacing: 2) {
                        Group {
                            if tab.icon == "Profile" {
                                GeometryReader { proxy in
                                    let rect = proxy.frame(in: .named("MAIN_SCREEN"))
                                    
                                    if let profile = appData.watchingProfile, !appData.animateProfile {
                                        Image(profile.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 25, height: 25)
                                            .clipShape(.rect(cornerRadius: 5))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    
                                    Color.clear
                                        .preference(key: RectKey.self, value: rect)
                                        .onPreferenceChange(RectKey.self) { value in
                                            appData.tabProfileRect = value
                                        }
                                }
                                .frame(width: 35, height: 35)
                            } else {
                                Image(systemName: tab.icon)
                                    .font(.title3)
                                    .frame(width: 35, height: 35)
                            }
                        }
                        .keyframeAnimator(initialValue: 1, trigger: appData.activeTab) { content, scale in
                            content
                                .scaleEffect(appData.activeTab == tab ? scale : 1.0)
                        } keyframes: { _ in
                            CubicKeyframe(1.2, duration: 0.2)
                            CubicKeyframe(1.0, duration: 0.2)
                        }

                        
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .animation(.snappy) { content in
                        content
                            .opacity(appData.activeTab == tab ? 1.0 : 0.6)
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(NoAnimationButtonStyle())
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded { _ in
                            guard tab == .account else { return }
                            withAnimation(.snappy(duration: 0.3)) {
                                appData.showProfileView = true
                                appData.hideMainView = true
                                appData.fromTabBar = true
                            }
                        }
                )
            }
        }
        .padding(.bottom, 10)
        .padding(.top, 5)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppData())
        .preferredColorScheme(.dark)
}
