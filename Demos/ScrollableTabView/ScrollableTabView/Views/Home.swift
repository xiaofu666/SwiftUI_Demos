//
//  Home.swift
//  ScrollableTabView
//
//  Created by Lurich on 2023/11/13.
//

import SwiftUI

struct Home: View {
    @State private var selectedTab: Tab?
    @State private var tabProgress: CGFloat = 0
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "bell.badge")
                })
            }
            .font(.title2)
            .overlay {
                Text("Messages")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            CustomTabBar()
            
            GeometryReader(content: { geometry in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0, content: {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            SampleView(tab.systemColor)
                                .id(tab)
                                .containerRelativeFrame(.horizontal)
                        }
                    })
                    .scrollTargetLayout()
                    .offsetX { value in
                        let progress = -value / (geometry.size.width * CGFloat(Tab.allCases.count - 1))
                        tabProgress = min(max(progress, 0), 1)
                    }
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10, content: {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                })
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    // 点击
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress)
        .background() {
            GeometryReader { proxy in
                let size = proxy.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? Color.black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...10, id:\.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .leading, content: {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 6, content: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                })
                                
                                Spacer(minLength: 0)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 80, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            })
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                        }
                }
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
}

#Preview {
    ContentView()
}
