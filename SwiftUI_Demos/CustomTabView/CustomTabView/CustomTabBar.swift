//
//  CustomTabBar.swift
//  CustomTabView
//
//  Created by Lurich on 2024/7/4.
//

import SwiftUI

struct CustomTabBar: View {
    @Environment(TabProperties.self) private var properties
    
    var body: some View {
        @Bindable var binding = properties
        HStack(spacing: 0) {
            ForEach($binding.tabs) { $tab in
                TabBarButton(tab: $tab)
            }
        }
        .padding(.horizontal, 10)
        .background(.bar)
        .overlay(alignment: .topLeading) {
            if let id = properties.movingTab, let tab = properties.tabs.first(where: { $0.id == id }) {
                Image(systemName: tab.symbolImage)
                    .font(.title2)
                    .offset(x: properties.initialTabLocation.minX, y: properties.initialTabLocation.minY)
                    .offset(properties.moveOffset)
            }
        }
        .coordinateSpace(.named("CUSTOM_TABBAR"))
        .onChange(of: properties.moveLocation) { oldValue, newValue in
            if let droppingIndex = properties.tabs.firstIndex(where: { $0.rect.contains(newValue) }), let activeIndex = properties.tabs.firstIndex(where: { $0.id == properties.movingTab }), droppingIndex != activeIndex {
                withAnimation(.snappy(duration: 0.3)) {
                    (properties.tabs[droppingIndex], properties.tabs[activeIndex]) = (properties.tabs[activeIndex], properties.tabs[droppingIndex])
                }
                saveOrder()
            }
        }
        .sensoryFeedback(.success, trigger: properties.haptics)
    }
    
    private func saveOrder() {
        let order: [Int] = properties.tabs.reduce([]) { partialResult, model in
            return partialResult + [model.id]
        }
        UserDefaults.standard.setValue(order, forKey: "CustomTabOrder")
    }
}

struct TabBarButton: View {
    @Binding var tab: TabModel
    @Environment(TabProperties.self) private var properties
    @State private var tabRect: CGRect = .zero
    
    var body: some View {
        @Bindable var binding = properties
        Image(systemName: tab.symbolImage)
            .font(.title2)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .named("CUSTOM_TABBAR"))
            } action: { newValue in
                tabRect = newValue
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(properties.activeTab == tab.id ? .primary : properties.editMode ? .primary : .secondary)
            .opacity(properties.movingTab == tab.id ? 0 : 1)
            .overlay {
                if !properties.editMode {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(.rect)
                        .onTapGesture {
                            properties.activeTab = tab.id
                        }
                } else {
                    Rectangle()
                        .fill(.clear)
                        .contentShape(.rect)
                        .gesture(
                            CustomGesture(isEnabled: $binding.editMode, trigger: { status in
                                if status {
                                    properties.initialTabLocation = tabRect
                                    properties.movingTab = tab.id
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
                                        properties.initialTabLocation = tabRect
                                        properties.moveOffset = .zero
                                    } completion: {
                                        properties.moveLocation = .zero
                                        properties.movingTab = nil
                                    }

                                }
                            }, onChanged: { offset, location in
                                properties.moveOffset = offset
                                properties.moveLocation = location
                            })
                        )
                }
            }
            .loopingWiggle(properties.editMode)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                tab.rect = newValue
            }

    }
}

#Preview {
    ContentView()
}
