//
//  ContentView.swift
//  ResizableHeaderScroll
//
//  Created by Xiaofu666 on 2025/5/18.
//

import SwiftUI

let types: [String] = ["iPhone", "iPad", "MacBook", "Apple Watch", "AirPods", "HomePod", "VisionPro"]

struct ContentView: View {
    @State private var selectedType: String = types.first!
    @Namespace private var animation
    
    var body: some View {
        ResizableHeViewScrollView(spacing: 10) {
            HStack(spacing: 15) {
                Button {
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                
                Spacer(minLength: 0)
                
                Button {
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                
                Button {
                } label:{
                    Image(systemName: "bubble")
                        .font(.title3)
                }
            }
            .overlay {
                Text("Apple Store")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(Color.primary)
            .padding(.horizontal, 15)
            .padding(.top, 15)
        } stickyHeader: {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(types, id:\.self) { type in
                        Text(type)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)
                            .foregroundStyle(selectedType == type ? .white : .gray)
                            .frame(height: 30)
                            .background {
                                if selectedType == type {
                                    Capsule()
                                        .fill(.blue.gradient)
                                        .matchedGeometryEffect(id: "ACTIVE", in: animation)
                                }
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    selectedType = type
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollPosition(
                id: .init(
                    get: {
                        return selectedType
                    },
                    set: { _ in
                    }),
                anchor: .center
            )
            .safeAreaPadding(15)
            .padding(.top, 10)
        } background: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(alignment: .bottom) {
                    Divider()
                }
        } content: {
            VStack(spacing: 15) {
                ForEach(1...100, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.35))
                        .frame(height: 50)
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    ContentView()
}
