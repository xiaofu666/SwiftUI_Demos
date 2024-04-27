//
//  ContentView.swift
//  RangeSlider
//
//  Created by Lurich on 2024/4/27.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: ClosedRange<CGFloat> = 40...70
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("选择范围：\(Int(selection.lowerBound)) - \(Int(selection.upperBound))")
                    .font(.largeTitle.bold())
                    .padding()
                
                RangeSliderView(selection: $selection, range: 10...100, minimumDistance: 10)
            }
            .padding()
            .navigationTitle("Range Slider")
        }
    }
}

#Preview {
    ContentView()
}
