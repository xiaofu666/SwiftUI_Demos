//
//  InlineToast.swift
//  InlineToasts
//
//  Created by Xiaofu666 on 2025/4/28.
//

import SwiftUI

extension View {
    func inlineToast(
        alignment: Alignment,
        config: InlineToastConfig,
        isPresented: Bool
    ) -> some View {
        VStack(spacing: 10) {
            if config.anchor == .bottom {
                self
                    .compositingGroup()
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
            
            // Inline Toast View
            if isPresented {
                InlineToastView(config: config)
                    .transition(CustomTransition(anchor: config.animationAnchor))
            }

            if config.anchor == .top {
                self
                    .compositingGroup()
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
        .clipped()
    }
}

fileprivate struct CustomTransition: Transition {
    var anchor: InlineToastConfig.InlineToastAnchor
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .visualEffect { [phase] content, proxy in
                content
                    .offset(y: offset(proxy, phase: phase))
            }
            .clipped()
    }
    
    
    nonisolated func offset(_ proxy: GeometryProxy, phase: TransitionPhase) -> CGFloat {
        let height = proxy.size.height + 10
        return anchor == .top ? (phase.isIdentity ? 0 : -height) : (phase.isIdentity ? 0 : height)
    }
}
/// Inline Toast Config
struct InlineToastConfig {
    var icon: String
    var title: String
    var subTitle: String
    var tint: Color
    var anchor: InlineToastAnchor = .top
    var animationAnchor: InlineToastAnchor = .top
    var actionIcon: String
    var actionHandler: () -> () = { }
    
    enum InlineToastAnchor {
        case top
        case bottom
        
        // Transition Edges
        var edge: Edge {
            self == .top ? .top : .bottom
        }
        
        var reverseEdge: Edge {
            self != .top ? .top : .bottom
        }

    }
}

/// Custom Inline Toast View
struct InlineToastView: View{
    var config: InlineToastConfig
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: config.icon)
                .font(.title2)
                .foregroundStyle(config.tint)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(config.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                if !config.subTitle.isEmpty {
                    Text(config.subTitle)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer(minLength: 0)
            // Action Button
            Button(action: config.actionHandler) {
                Image(systemName: config.actionIcon)
                    .foregroundStyle(.gray)
                    .contentShape(.rect)
            }
        }
        .padding()
        .background {
            ZStack{
                Rectangle()
                    .fill(.background)
                
                HStack(spacing:0) {
                    Rectangle()
                        .fill(config.tint)
                        .frame(width: 5)
                    
                    Rectangle()
                        .fill(config.tint.opacity(0.15))
                }
            }
        }
        .contentShape(.rect)
    }
}
