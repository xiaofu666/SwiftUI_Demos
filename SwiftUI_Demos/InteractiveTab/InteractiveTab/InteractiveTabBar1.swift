//
//  ContentView.swift
//  InteractiveTab
//
//  Created by Xiaofu666 on 2024/12/27.
//

import SwiftUI

struct InteractiveTabBar1: View {
    @Binding var activeTab: TabItem
    @Namespace private var animation
    private let coordinateId: String = "TAB_BAR"
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    @State private var activeDraggingTab: TabItem?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background {
            Rectangle()
                .fill(.background.shadow(.drop(color: .primary.opacity(0.2), radius: 5)))
                .ignoresSafeArea()
                .padding(.top, 20)
        }
        .coordinateSpace(.named(coordinateId))
    }
    
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = tab == (activeDraggingTab ?? activeTab)
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(.fill)
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.blue.gradient)
                            .matchedGeometryEffect(id: "ACTIVE_BG", in: animation)
                    }
                }
                .frame(width: 25, height: 25, alignment: .bottom)
                .foregroundStyle(isActive ? .white : .primary)
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(isActive ? .blue : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .contentShape(.rect)
        .padding(.top, isActive ? 0 : 20)
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named(coordinateId))
        }, action: { newValue in
            tabButtonLocations[tab.index] = newValue
        })
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named(coordinateId))
                .onChanged { value in
                    let location = value.location
                    if let index = tabButtonLocations.firstIndex(where: { $0.contains(location) }) {
                        withAnimation(.snappy(duration: 0.25)) {
                            activeDraggingTab = TabItem.allCases[index]
                        }
                    }
                }
                .onEnded { _ in
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                    }
                    activeDraggingTab = nil
                },
            isEnabled: activeTab == tab
        )
    }
}

#Preview {
    ContentView()
}
