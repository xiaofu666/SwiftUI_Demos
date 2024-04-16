//
//  HoldDownButton.swift
//  HoldDownView
//
//  Created by Lurich on 2024/3/20.
//

import SwiftUI

struct HoldDownButton: View {
    var text: String
    var paddingHorizontal: CGFloat = 25
    var paddingVertical: CGFloat = 15
    var duration: CGFloat = 1
    var scale: CGFloat = 0.95
    var background: Color
    var loadingTint: Color
    var shape: AnyShape = .init(.capsule)
    var action: () -> ()
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State private var timeCount: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var isHolding: Bool = false
    @State private var isCompleted: Bool = false
    
    var body: some View {
        Text(text)
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(background.gradient)
                    
                    if !isCompleted {
                        GeometryReader {
                            let size = $0.size
                            Rectangle()
                                .fill(loadingTint)
                                .frame(width: size.width * progress)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .clipShape(shape)
            .contentShape(shape)
            .scaleEffect(isHolding ? scale : 1)
            .animation(.snappy, value: isHolding)
            .gesture(longPressGesture)
            .simultaneousGesture(dragGesture)
            .onReceive(timer) { _ in
                if isHolding && progress != 1 {
                    timeCount += 0.01
                    progress = max(min(timeCount / duration, 1.0), 0.0)
                }
            }
            .onAppear(perform: cancelTimer)
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { _ in
                guard !isCompleted else { return }
                cancelTimer()
                withAnimation(.snappy) {
                    reset()
                }
            }
    }
    
    var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: duration)
            .onChanged { status in
                isCompleted = false
                reset()
                
                isHolding = status
                addTimer()
            }
            .onEnded { status in
                isHolding = false
                cancelTimer()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCompleted = status
                }
                action()
            }
    }
    
    func addTimer() {
        timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    
    func cancelTimer() {
        timer.upstream.connect().cancel()
    }
    
    func reset() {
        isHolding = false
        progress = 0
        timeCount = 0
    }
}

#Preview {
    ContentView()
}
