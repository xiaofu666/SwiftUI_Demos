//
//  Home.swift
//  CustomDragAndDrop
//
//  Created by Xiaofu666 on 2024/9/2.
//

import SwiftUI

struct Home: View {
    var safeArea: EdgeInsets
    @State private var controls: [Control] = controlList
    @State private var selectedControl: Control?
    @State private var selectedControlFrame: CGRect = .zero
    @State private var selectedControlScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = .zero
    @State private var lastActiveScrollOffset: CGFloat = .zero
    @State private var topRegion: CGRect = .zero
    @State private var bottomRegion: CGRect = .zero
    @State private var hapticsTrigger: Bool = false
    @State private var scrollTimer: Timer?
    @State private var maximumScrollSize: CGFloat = 0
    @State private var count: Int = 1
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: count), spacing: 20) {
                ForEach($controls) { $control in
                    ControlView(control: control)
                        .opacity(selectedControl?.id == control.id ? 0 : 1)
                        .onGeometryChange(for: CGRect.self) { proxy in
                            proxy.frame(in: .global)
                        } action: { newValue in
                            if selectedControl?.id == control.id {
                                selectedControlFrame = newValue
                            }
                            control.frame = newValue
                        }
                        .gesture(customCombinedGesture(control))

                }
            }
            .padding(25)
        }
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.contentInsets.top + proxy.contentOffset.y
        }, action: { oldValue, newValue in
            currentScrollOffset = newValue
        })
        .onScrollGeometryChange(for: CGFloat.self, of: { proxy in
            proxy.contentSize.height - proxy.containerSize.height
        }, action: { oldValue, newValue in
            maximumScrollSize = newValue
        })
        .overlay(alignment: .topLeading) {
            if let selectedControl {
                ControlView(control: selectedControl)
                    .frame(width: selectedControl.frame.width, height: selectedControl.frame.height)
                    .scaleEffect(selectedControlScale)
                    .offset(x: selectedControl.frame.minX, y: selectedControl.frame.minY)
                    .offset(offset)
                    .ignoresSafeArea()
                    .transition(.identity)
            }
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.clear)
                .frame(height: 20 + safeArea.top)
                .onGeometryChange(for: CGRect.self, of: { proxy in
                    proxy.frame(in: .global)
                }, action: { newValue in
                    topRegion = newValue
                })
                .offset(y: -safeArea.top)
                .allowsTightening(false)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.clear)
                .frame(height: 20 + safeArea.bottom)
                .onGeometryChange(for: CGRect.self, of: { proxy in
                    proxy.frame(in: .global)
                }, action: { newValue in
                    bottomRegion = newValue
                })
                .offset(y: safeArea.bottom)
                .allowsTightening(false)
        }
        .overlay(alignment: .topTrailing, content: {
            Button {
                count = 2
            } label: {
                Text("2 列")
            }
            .offset(y: -10)
            .padding(.horizontal, 30)
        })
        .overlay(alignment: .topLeading, content: {
            Button {
                count = 1
            } label: {
                Text("1 列")
            }
            .offset(y: -10)
            .padding(.horizontal, 30)
        })
        .allowsTightening(selectedControl == nil )
        .sensoryFeedback(.impact, trigger: hapticsTrigger)
    }
    
    func customCombinedGesture(_ control: Control) -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))
            .onChanged { value in
                switch value {
                case .second(let status, let value):
                    if status {
                        if selectedControl == nil {
                            selectedControl = control
                            selectedControlFrame = control.frame
                            lastActiveScrollOffset = currentScrollOffset
                            hapticsTrigger.toggle()
                            
                            withAnimation(.snappy(duration: 0.25)) {
                                selectedControlScale = 1.05
                            }
                        }
                        
                        if let value {
                            offset = value.translation
                            let location = value.location
                            checkAndScroll(location)
                        }
                    }
                    
                default:
                    break
                }
            }
            .onEnded { _ in
                scrollTimer?.invalidate()
                
                withAnimation(.snappy(duration: 0.25), completionCriteria: .logicallyComplete) {
                    selectedControl?.frame = selectedControlFrame
                    selectedControlScale = 1.0
                    offset = .zero
                } completion: {
                    selectedControl = nil
                    scrollTimer = nil
                    lastActiveScrollOffset = 0
                }

            }
    }
    
    private func checkAndScroll(_ location: CGPoint) {
        let topStatus = topRegion.contains(location)
        let bottomStatus = bottomRegion.contains(location)
        if topStatus || bottomStatus {
            guard scrollTimer == nil else { return }
            scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                if topStatus {
                    lastActiveScrollOffset = max(lastActiveScrollOffset - 10, 0)
                } else {
                    lastActiveScrollOffset = min(lastActiveScrollOffset + 10, maximumScrollSize)
                }
                scrollPosition.scrollTo(y: lastActiveScrollOffset)
                checkAndSwapItems(location)
            })
        } else {
            scrollTimer?.invalidate()
            scrollTimer = nil
            
            checkAndSwapItems(location)
        }
    }
    
    private func checkAndSwapItems(_ location: CGPoint) {
        if let currentIndex = controls.firstIndex(where: { $0.id == selectedControl?.id }),
           let fallingIndex = controls.firstIndex(where: { $0.frame.contains(location) }) {
            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                (controls[currentIndex], controls[fallingIndex]) = (controls[fallingIndex], controls[currentIndex])
            }
        }
    }
}

struct ControlView: View {
    var control: Control
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: control.symbol)
                .font(.title3)
                .frame(width: 35, height: 35)
            
            Text(control.title)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 15)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        }
    }
}

#Preview {
    ContentView()
}
