//
//  ContentView.swift
//  BackdropCarousel
//
//  Created by Xiaofu666 on 2025/1/8.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                HeaderView()
                
                CarouselView()
                    .zIndex(-1)
            }
        }
        .safeAreaPadding(15)
        .background {
            Rectangle()
                .fill(backgroundColor.gradient)
                .scaleEffect(y: -1)
                .ignoresSafeArea()
        }
        .onScrollGeometryChange(for: ScrollGeometry.self, of: { $0 }) { oldValue, newValue in
            topInset = newValue.contentInsets.top + 100
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }

    }
    
    var backgroundColor: Color {
        isDark ? Color.black : Color.white
    }
    
    var isDark: Bool {
        scheme == .dark
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(systemName: "xbox.logo")
                .font(.system(size: 35))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Xiaofu666")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                HStack(spacing: 6) {
                    Image(systemName: "g.circle.fill")
                    
                    Text("36,988")
                        .font(.caption)
                }
            }
            
            Spacer(minLength: 0)
            
            Group {
                Image(systemName: "square.and.arrow.up.circle.fill")
                
                Image(systemName: "bell.circle.fill")
            }
            .font(.largeTitle)
            .foregroundStyle(.primary, .fill)
        }
    }
    
    @ViewBuilder
    func CarouselView() -> some View {
        let spacing: CGFloat = 6
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                ForEach(images) { model in
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 380)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: backgroundColor.opacity(0.5), radius: 5, x: 5, y: 5)
                    
                }
            }
            .scrollTargetLayout()
        }
        .frame(height: 380)
        .background(BackdropCarouselView())
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .onScrollGeometryChange(for: CGFloat.self) { proxy in
            let offsetX = proxy.contentOffset.x + proxy.contentInsets.leading
            let width = proxy.containerSize.width + spacing
            return offsetX / width
        } action: { oldValue, newValue in
            let maxValue = CGFloat(images.count - 1)
            scrollProgressX = max(min(newValue, maxValue), 0.0)
        }

    }
    
    @ViewBuilder
    func BackdropCarouselView() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(images.reversed()) { model in
                    let index = CGFloat(images.firstIndex(where: { $0.id == model.id }) ?? 0) + 1
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .opacity(index - scrollProgressX)
                }
            }
            .compositingGroup()
            .blur(radius: 30, opaque: true)
            .overlay {
                Rectangle()
                    .fill(backgroundColor.opacity(0.35))
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(colors: [
                        backgroundColor,
                        backgroundColor,
                        backgroundColor,
                        backgroundColor,
                        backgroundColor.opacity(0.5),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
            }
        }
        .containerRelativeFrame(.horizontal)
        .padding(.bottom, -60)
        .padding(.top, -topInset)
        .offset(y: min(scrollOffsetY, 0))
    }
}

#Preview {
    ContentView()
}
