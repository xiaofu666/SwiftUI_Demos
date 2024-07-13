//
//  ContentView.swift
//  MagicDividingLineView
//
//  Created by Xiaofu666 on 2024/7/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            Color.secondary
            
            MagicDividingLineView(size: size)
        }
        .ignoresSafeArea()
    }
}

struct MagicDividingLineView: View {
    var size: CGSize
    
    @GestureState private var isDragging: Bool = false
    @State private var redOffset: CGSize = .zero
    @State private var lastRedOdOffset: CGSize = .zero
    @State private var greenOffset: CGSize = .zero
    @State private var lastGreenOdOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.clear)
                            .background {
                                Image(.b)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(width: 200, height: 281)
                            .offset(redOffset)
                            .gesture(
                                DragGesture()
                                    .updating($isDragging) { _, state, _ in
                                        state = true
                                    }
                                    .onChanged { value in
                                        if isDragging {
                                            redOffset = value.translation + lastRedOdOffset
                                            greenOffset = redOffset - CGSize(width: 0, height: size.height * 0.5)
                                        }
                                    }
                                    .onEnded { value in
                                        redOffset = value.translation + lastRedOdOffset
                                        lastRedOdOffset = redOffset
                                        greenOffset = redOffset - CGSize(width: 0, height: size.height * 0.5)
                                        lastGreenOdOffset = greenOffset
                                    }
                            )
                    }
                    .clipped()
                    .onAppear() {
                        redOffset = CGSizeMake(0, size.height * 0.25)
                        lastRedOdOffset = redOffset
                    }
                
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill(.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.clear)
                            .background {
                                Image(.a)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .frame(width: 200, height: 281)
                            .offset(greenOffset)
                            .gesture(
                                DragGesture()
                                    .updating($isDragging) { _, state, _ in
                                        state = true
                                    }
                                    .onChanged { value in
                                        if isDragging {
                                            greenOffset = value.translation + lastGreenOdOffset
                                            redOffset = greenOffset + CGSize(width: 0, height: size.height * 0.5)
                                        }
                                    }
                                    .onEnded { value in
                                        greenOffset = value.translation + lastGreenOdOffset
                                        lastGreenOdOffset = greenOffset
                                        redOffset = greenOffset + CGSize(width: 0, height: size.height * 0.5)
                                        lastRedOdOffset = redOffset
                                    }
                            )
                    }
                    .clipped()
                    .onAppear() {
                        greenOffset = CGSizeMake(0, -size.height * 0.25)
                        lastGreenOdOffset = greenOffset
                    }
            }
        }
        .frame(width: size.width, height: size.height)
    }
}

extension CGSize {
    static func +(_ lhs: Self, _ rhs: Self) -> Self {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func -(_ lhs: Self, _ rhs: Self) -> Self {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}


#Preview {
    ContentView()
}
