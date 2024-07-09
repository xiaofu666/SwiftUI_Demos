//
//  CustomPicker.swift
//  Custom3DPicker
//
//  Created by Lurich on 2024/7/9.
//

import SwiftUI

extension View {
    @ViewBuilder
    func customPicker(_ config: Binding<PickerConfig>, items: [String]) -> some View {
        self
            .overlay {
                if config.wrappedValue.show {
                    CustomPickerView(texts: items, config: config)
                        .transition(.identity)
                }
            }
    }
}
struct PickerConfig {
    var text: String
    init(text: String) {
        self.text = text
    }
    
    var show: Bool = false
    var sourceFrame: CGRect = .zero
}
fileprivate struct CustomPickerView: View {
    var texts: [String]
    @Binding var config: PickerConfig
    @State private var activeText: String?
    
    @State private var showContents: Bool = false
    @State private var showScrollView: Bool = false
    @State private var expandItems: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(showContents ? 1 : 0)
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(texts, id: \.self) { text in
                        CardView(text, size)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.top, size.height * 0.5 - 20)
            .safeAreaPadding(.bottom, size.height * 0.5)
            .scrollPosition(id: $activeText, anchor: .center)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
            .opacity(showScrollView ? 1 : 0)
            .allowsHitTesting(expandItems && showScrollView)
            
            let offset: CGSize = .init(
                width: showContents ? size.width * -0.3 : config.sourceFrame.minX,
                height: showContents ? -10 : config.sourceFrame.minY
            )
            Text(config.text)
                .fontWeight(showContents ? .semibold : .regular)
                .foregroundStyle(.blue)
                .frame(height: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: showContents ? .trailing : .topLeading)
                .offset(offset)
                .opacity(showContents ? 0 : 1)
                .ignoresSafeArea(.all, edges: showContents ? [] : .all)
            
            CloseButton()
        }
        .task {
            guard activeText == nil else { return }
            activeText = config.text
            withAnimation(.easeInOut(duration: 0.3)) {
                showContents = true
            }
            try? await Task.sleep(for: .seconds(0.3))
            showScrollView = true
            withAnimation(.snappy(duration: 0.3)) {
                expandItems = true
            }
        }
        .onChange(of: activeText, initial: true) { oldValue, newValue in
            if let newValue {
                config.text = newValue
            }
        }
    }
    
    @ViewBuilder
    func CardView(_ text: String, _ size: CGSize, axes: Alignment = .trailing) -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            Text(text)
                .fontWeight(.semibold)
                .foregroundStyle(text == config.text ? .blue : .gray)
                .offset(y: offset(proxy, size))
                .opacity((expandItems || config.text == text) ? 1 : 0)
                .clipped()
                .offset(x: (axes == .leading ? 1.0 : -1.0) * width * 0.3)
                .rotationEffect(.init(degrees: (axes == .leading ? 1.0 : -1.0) * (expandItems ? rotation(proxy, size) : 0)), anchor: axes == .leading ? .topLeading : .topTrailing)
                .opacity(opacity(proxy, size))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: axes)
        }
        .frame(height: 20)
        .lineLimit(1)
    }
    
    @ViewBuilder
    func CloseButton() -> some View {
        Button {
            Task {
                withAnimation(.snappy) {
                    expandItems = false
                }
                try? await Task.sleep(for: .seconds(0.2))
                showScrollView = false
                withAnimation(.easeInOut(duration: 0.3)) {
                    showContents = false
                }
                try? await Task.sleep(for: .seconds(0.3))
                config.show = false
            }
        } label: {
            Image(systemName: "xmark")
                .font(.title3)
                .foregroundStyle(.primary)
                .frame(width: 45, height: 45)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .offset(x: expandItems ? -50 : 50, y: -10)
    }
    
    private func rotation(_ proxy: GeometryProxy, _ size: CGSize) -> CGFloat {
        let height = size.height * 0.5
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let maxRotation: CGFloat = 220
        let progress = minY / height
        return progress * maxRotation
    }
    
    private func offset(_ proxy: GeometryProxy, _ size: CGSize) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        return expandItems ? 0 : -minY
    }
    
    private func opacity(_ proxy: GeometryProxy, _ size: CGSize) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = size.height * 0.5
        let progress = (minY / height) * 2.8
        let opacity = progress < 0 ? 1 + progress : 1 - progress
        return opacity
    }
}

struct SourcePickerView: View {
    @Binding var config: PickerConfig
    
    var body: some View {
        Text(config.text)
            .fontWeight(.semibold)
            .foregroundStyle(.blue)
            .frame(height: 20)
            .opacity(config.show ? 0 : 1)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                config.sourceFrame = newValue
            }

    }
}

#Preview {
    @Previewable
    @State var config = PickerConfig(text: "UIKit")
    let texts: [String] = ["SwiftUI", "UIKit", "iOS", "macOS", "Xcode", "WWDC"]
    
    VStack {
        SourcePickerView(config: $config)
            .onTapGesture {
                config.show.toggle()
            }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(15)
    .customPicker($config, items: texts)
}
