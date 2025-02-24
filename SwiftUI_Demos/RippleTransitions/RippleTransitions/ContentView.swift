//
//  ContentView.swift
//  RippleTransitions
//
//  Created by Xiaofu666 on 2025/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var page: Int = 0
    @State private var rippleLocation: CGPoint = .zero
    @State private var isAnimate: Bool = false
    @State private var showOverlayView: Bool = false
    @State private var overlayRippleLocation: CGPoint = .zero
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ForEach(0...1, id: \.self) { index in
                        if page == index {
                            ImageView(index, size)
                                .transition(.ripple(location: rippleLocation))
                        }
                    }
                }
                .frame(width: 350, height: 500)
                .coordinateSpace(.named("VIEW"))
                .onTapGesture(count: 1, coordinateSpace: .named("VIEW")) { point in
                    rippleLocation = point
                    isAnimate = true
                    withAnimation(.linear(duration: 1), completionCriteria: .logicallyComplete) {
                        page = (page + 1) % 2
                    } completion: {
                        isAnimate = false
                    }
                }
            }
            .disabled(isAnimate)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                GeometryReader {
                    let frame = $0.frame(in: .global)
                    
                    Button {
                        overlayRippleLocation = .init(x: frame.midX, y: frame.midY)
                        
                        withAnimation(.linear(duration: 1)) {
                            showOverlayView = true
                        }
                    } label: {
                        Image(systemName:"square.and.arrow.up.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(.indigo.gradient, in: .circle)
                        .contentShape(.rect)

                    }

                }
                .frame(width: 50, height: 50)
                .padding(15)
            }
            .navigationTitle("Ripple Transition")
        }
        .overlay {
            if showOverlayView {
                ZStack {
                    Rectangle()
                        .fill(.indigo.gradient)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.55)) {
                                showOverlayView = false
                            }
                        }
                    
                    Text("Tap anywhere to dismiss!")
                }
                .transition(.reverseRipple(location: overlayRippleLocation))
            }
        }
    }
    
    @ViewBuilder
    func ImageView(_ index: Int, _ size: CGSize) -> some View {
        Image("Profile \(index + 1)")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(.rect(cornerRadius: 30))
    }
}

#Preview {
    ContentView()
}
