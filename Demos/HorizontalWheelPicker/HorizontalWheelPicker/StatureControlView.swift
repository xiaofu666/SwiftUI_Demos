//
//  StatureControlView.swift
//  HorizontalWheelPicker
//
//  Created by Lurich on 2024/3/21.
//

import SwiftUI

struct StatureControlView: View {
    @State private var height: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                Text("您的身高")
                    .font(.title)
                HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                    Text("\(height)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .contentTransition(.numericText(value: Double(height)))
                    
                    Text("cm")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                })
            }
            
            StatureControl(height: $height)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct StatureControl: View {
    @Binding var height: Int
    @State private var value: Int? = nil
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment:.trailing) {
                ScrollView(.vertical,showsIndicators: true){
                    LazyVStack(alignment:.trailing, spacing:10){
                        ForEach(0...280, id:\.self) { num in
                            let isLong = num % 10==0
                            Rectangle()
                                .frame(width: isLong ? 60 : 40, height: 2)
                                .clipShape(.rect(topLeadingRadius: 2, bottomLeadingRadius: 2))
                                .overlay(alignment:.leading) {
                                    if isLong {
                                        Text("\(num)")
                                            .frame(width: 100,alignment:.trailing)
                                            .offset(x: -110)
                                    }
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding(.vertical, proxy.size.height / 2.0)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $value, anchor: .trailing)
                
                Rectangle()
                    .fill(.red)
                    .frame(width: 62, height: 4)
                    .clipShape(.rect(topLeadingRadius: 4, bottomLeadingRadius: 4))
            }
        }
        .onAppear() {
            value = height
        }
        .onChange(of: value) { oldValue, newValue in
            withAnimation(.bouncy) {
                height = value ?? 0
            }
        }
        .sensoryFeedback(trigger: value) { oldValue, newValue in
            return SensoryFeedback.impact(weight: .light, intensity: 0.5)
        }
    }
}

#Preview {
    StatureControlView()
}
