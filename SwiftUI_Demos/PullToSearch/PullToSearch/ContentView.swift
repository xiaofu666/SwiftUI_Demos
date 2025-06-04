//
//  ContentView.swift
//  PullToSearch
//
//  Created by Xiaofu666 on 2025/6/4.
//

import SwiftUI

struct ContentView: View {
    @State private var offsetY: CGFloat = 0
    @FocusState private var isExpanded: Bool

    var body: some View {
        ScrollView(.vertical) {
            DummyScrollContent()
                .offset(y: isExpanded ? -offsetY : 0)
                // Attach this to the Root Scroll Content!
                .onGeometryChange(for: CGFloat.self) {
                    $0.frame(in: .scrollView(axis: .vertical)).minY
                } action:{ newValue in
                    offsetY = newValue
                }
        }
        .overlay {
            Rectangle()
                .fill(.ultraThinMaterial)
                .background(.background.opacity(0.25))
                .ignoresSafeArea()
                .overlay {
                    ExpandedSearchView(isExpanded: isExpanded)
                        .offset(y:isExpanded ? 0 : 70)
                        .opacity(isExpanded ? 1 : 0)
                        .allowsHitTesting(isExpanded)
                }
                .opacity(isExpanded ? 1 : progress)
        }
        .safeAreaInset(edge: .top) {
            HeaderView()
        }
        .scrollTargetBehavior(onScrollEnd { dy in
            if offsetY > 100 || (-dy > 1.5 && offsetY > 0) {
                isExpanded = true
            }
        })
        // 如果你不想等待弹性动画完成，可以使用非弹性动画，如easeIn、Out等！
        .animation(.interpolatingSpring(duration: 0.2), value: isExpanded)
    }
    
    //Converting offset into Progress
    var progress: CGFloat {
        return max(min(offsetY / 100, 1), 0)
    }
    
    // Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            if !isExpanded {
                Button {
                } label: {
                    Image(systemName: "slider.horizontal.below.square.filled.and.square")
                        .font(.title3)
                }
            }
            
            // Search Bar
            TextField("Search App", text: .constant(""))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                        
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                }
                .clipShape(.rect(cornerRadius: 15))
                .focused($isExpanded)
            
            Button {
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
            }
            .opacity(isExpanded ? 0 : 1)
            .overlay(alignment: .trailing) {
                Button("Cancel") {
                    isExpanded = false
                }
                .fixedSize()
                .opacity(isExpanded ? 1 : 0)
            }
            .padding(.leading, isExpanded ? 20 : 0)
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background {
            Rectangle()
                // 使用与滚动视图背景相同的背景！
                .fill(.background)
                .ignoresSafeArea()
                // 展开搜索栏时隐藏背景！
                .opacity(progress == 0 && !isExpanded ? 1 : 0)
        }
    }
    
    /// Dummy Scroll Content
    @ViewBuilder
    func DummyScrollContent() -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                
                RoundedRectangle(cornerRadius:15)
                    .fill(.blue.gradient)
                
                RoundedRectangle(cornerRadius:15)
                    .fill(.green.gradient)
                
                RoundedRectangle(cornerRadius:15)
                    .fill(.yellow.gradient)
            }
            .frame(height: 60)
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Favourites")
                    .foregroundStyle(.gray)
                
                Text("Start adding your favourites\nto show up here!")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 30)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
}

#Preview {
    ContentView()
}

struct onScrollEnd: ScrollTargetBehavior {
    /// Return Velocity
    var onEnd: (CGFloat)->()
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let dy = context.velocity.dy
        DispatchQueue.main.async {
            onEnd(dy)
        }
    }
}

/// Dummy Search View using List View
struct ExpandedSearchView: View {
    var isExpanded: Bool
    
    var body: some View {
        List {
            let colors: [Color] = [.black, .indigo, .cyan]
            if isExpanded {
                ForEach(colors, id: \.self) { color in
                    Section(String.init(describing: color).capitalized) {
                        ForEach(1...5, id: \.self) { index in
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(color.gradient)
                                    .frame(width: 40, height: 40)
                                
                                Text("Search Item No:\(index)")
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .clipped()
    }
}
