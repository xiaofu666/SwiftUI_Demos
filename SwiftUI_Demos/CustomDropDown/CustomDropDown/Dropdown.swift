//
//  Dropdown.swift
//  CustomDropDown
//
//  Created by Xiaofu666 on 2024/7/15.
//

import SwiftUI

extension View {
    @ViewBuilder
    func dropdownOverlay(_ config: Binding<DropdownConfig>, values: [String], allShow: Bool = false) -> some View {
        self
            .overlay {
                if config.wrappedValue.show {
                    DropDownView(values: values, maxShow: allShow ? values.count : min(values.count, 5), config: config)
                        .transition(.identity)
                }
            }
    }
}

struct DropDownView: View {
    var values: [String]
    var maxShow: Int
    @Binding var config: DropdownConfig
    @State private var activeItem: String?
    
    var body: some View {
        let contentHeight = CGFloat(maxShow) * config.anchor.height
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ItemView(config.activeText)
                    .id(config.activeText)
                
                ForEach(filteredValues, id: \.self) { item in
                    ItemView(item)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $activeItem, anchor: .top)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .scrollIndicators(.hidden)
        .frame(width: config.anchor.width, height: contentHeight)
        .background(.background)
        .mask(alignment: .top) {
            Rectangle()
                .frame(height: config.showContent ? contentHeight : config.anchor.height, alignment: .top)
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "chevron.down")
                .rotationEffect(.init(degrees: config.showContent ? 180 : 0))
                .padding(.trailing, 15)
                .frame(height: config.anchor.height)
        }
        .clipShape(.rect(cornerRadius: config.cornerRadius))
        .offset(x: config.anchor.minX, y: config.anchor.minY)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            if config.showContent {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .reverseMask(.topLeading) {
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .frame(width: config.anchor.width, height: contentHeight)
                            .offset(x: config.anchor.minX, y: config.anchor.minY)
                    }
                    .transition(.opacity)
                    .onTapGesture {
                        closeDropdown(activeItem ?? config.activeText)
                    }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func ItemView(_ item: String) -> some View {
        HStack {
            Text(item)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .frame(height: config.anchor.height)
        .contentShape(.rect)
        .onTapGesture {
            closeDropdown(item)
        }
    }
    
    func closeDropdown(_ item: String) {
        withAnimation(.easeInOut(duration: 0.35), completionCriteria: .logicallyComplete) {
            activeItem = item
            config.showContent = false
        } completion: {
            config.activeText = item
            config.show = false
        }

    }
    
    var filteredValues: [String] {
        values.filter({ $0 != config.activeText })
    }
}

extension View {
    @ViewBuilder
    func reverseMask<Content: View>(_ alignment: Alignment, @ViewBuilder content: () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}

struct SourceDropdownView: View {
    @Binding var config: DropdownConfig
    
    var body: some View {
        HStack {
            Text(config.activeText)
            
            Spacer(minLength: 0)
            
            Image(systemName: config.show ? "chevron.up" : "chevron.down")
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.background, in: .rect(cornerRadius: config.cornerRadius))
        .contentShape(.rect(cornerRadius: config.cornerRadius))
        .onTapGesture {
            config.show = true
            withAnimation(.snappy(duration: 0.35)) {
                config.showContent = true
            }
        }
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { newValue in
            config.anchor = newValue
        }

    }
}
struct DropdownConfig {
    var activeText: String
    var show: Bool = false
    var showContent: Bool = false
    var anchor: CGRect = .zero
    var cornerRadius: CGFloat = 10
}

#Preview {
    ContentView()
}
