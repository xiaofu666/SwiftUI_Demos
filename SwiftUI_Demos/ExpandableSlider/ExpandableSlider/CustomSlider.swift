//
//  CustomSlider.swift
//  ExpandableSlider
//
//  Created by Xiaofu666 on 2024/11/10.
//

import SwiftUI

struct CustomSlider<Overlay: View>: View {
    @Binding private var value: CGFloat
    private var range: ClosedRange<CGFloat>
    private var config: Config
    private var overlay: Overlay
    @State private var lastStoredValue: CGFloat
    @GestureState private var isActive: Bool = false
    
    init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, config: Config = .init(), @ViewBuilder overlay: @escaping () -> Overlay) {
        self._value = value
        self.range = range
        self.config = config
        self.overlay = overlay()
        self.lastStoredValue = value.wrappedValue
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let width = (value / range.upperBound) * size.width
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(config.inActiveTint)
                
                Rectangle()
                    .fill(config.activeTint)
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                    }
                
                ZStackLayout(alignment: .leading) {
                    overlay
                        .foregroundStyle(config.overlayInActiveTint)
                    
                    overlay
                        .foregroundStyle(config.overlayActiveTint)
                        .mask(alignment: .leading) {
                            Rectangle()
                                .frame(width: width)
                        }
                }
                .compositingGroup()
                .animation(.easeInOut(duration: 0.3).delay(isActive ? 0.12 : 0).speed(isActive ? 1 : 2)) { content in
                    content
                        .opacity(isActive ? 1 : 0)
                }
            }
            .contentShape(.rect)
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isActive) { _, out, _ in
                        out = true
                    }
                    .onChanged { value in
                        let progress = (value.translation.width / size.width) * range.upperBound + self.lastStoredValue
                        self.value = max(min(progress, range.upperBound), range.lowerBound)
                    }
                    .onEnded { _ in
                        lastStoredValue = value
                    }
            )
        }
        .frame(height: 20 + config.extraHeight)
        .mask {
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .frame(height: 20 + (isActive ? config.extraHeight : 0))
        }
        .animation(.snappy, value: isActive)
    }
    
    struct Config {
        var inActiveTint: Color = .black.opacity(0.06)
        var activeTint: Color = Color.primary
        var cornerRadius: CGFloat = 15
        var extraHeight: CGFloat = 25
        var overlayInActiveTint: Color = .black
        var overlayActiveTint: Color = .white
    }
}

#Preview {
    ContentView()
}
