//
//  PhaseAnimatorExample.swift
//  CTabBar
//
//  Created by Xiaofu666 on 2025/5/6.
//

import SwiftUI

enum OSInfo: String, CaseIterable {
    case iOS = "iOS"
    case appleWatch = "watchOS"
    case iPad = "iPadOS"
    case macBook = "macOS"
    case visionOS = "visionOS"
    
    var symbolImage: String {
        switch self {
        case .iOS:
            "iphone"
        case .appleWatch:
            "applewatch"
        case .iPad:
            "ipad"
        case .macBook:
            "macbook"
        case .visionOS:
            "vision.pro"
        }
    }
}

struct PhaseAnimatorExample: View {
    @State private var isAnimationEnabled: Bool = false
    
    var body: some View {
        ZStack {
            if isAnimationEnabled {
                PhaseAnimator(OSInfo.allCases) { info in
                    VStack(spacing: 20) {
                        ZStack {
                            ForEach(OSInfo.allCases, id: \.rawValue) { osInfo in
                                let isSame = osInfo == info
                                
                                if isSame {
                                    Image(systemName: osInfo.symbolImage)
                                        .font(.system(size:100, weight: .ultraLight, design: .rounded))
                                        .transition(.blurReplace(.upUp))
                                }
                            }
                        }
                        .frame(height: 120)
                        
                        VStack(spacing: 6) {
                            Text("Available on")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            
                            ZStack {
                                ForEach(OSInfo.allCases, id: \.rawValue) { osInfo in
                                    let isSame = osInfo == info
                                    
                                    if isSame {
                                        Text(osInfo.rawValue)
                                            .font(.largeTitle)
                                            .fontWeight(.semibold)
                                            .fontDesign(.rounded)
                                            .transition(.push(from: .bottom))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .clipped()
                        }
                    }
                } animation: { _ in
                        /// 每张幻灯片之间的延迟
                        .interpolatingSpring(.bouncy(duration: 1, extraBounce: 0)).delay(1.5)
                }
                .padding(30)
                .background(.white, in: .rect(cornerRadius: 15, style: .continuous))
                .padding(.horizontal, 80)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.15))
        .ignoresSafeArea()
        .task {
            isAnimationEnabled = true
        }
    }
}

#Preview {
    PhaseAnimatorExample()
}
