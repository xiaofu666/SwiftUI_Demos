//
//  ContentView.swift
//  StretchySlider
//
//  Created by Lurich on 2024/2/19.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: CGFloat = 0.6
    @State private var axis: CustomSlider.SliderAxis = .vertical
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $axis) {
                    Text("Vertical")
                        .tag(CustomSlider.SliderAxis.vertical)
                    
                    Text("Horizontal")
                        .tag(CustomSlider.SliderAxis.horizontal)
                }
                .pickerStyle(.segmented)
                
                CustomSlider(
                    sliderProgress: $progress,
                    symbol: .init(
                        icon: "airpodspro",
                        tint: .gray,
                        font: .system(size: 25),
                        padding: 20,
                        display: axis == .vertical,
                        alignment: .bottom
                    ),
                    axis: axis,
                    tint: .white
                )
                .frame(width: axis == .horizontal ? 220 : 60, height: axis == .horizontal ? 30 : 180)
                .frame(maxHeight: .infinity)
                .animation(.snappy, value: axis)
                
                Button("Update To 20%") {
                    progress = 0.2
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .top)
            .navigationTitle("Stretchy Slider")
            .background(.fill)
        }
    }
}

#Preview {
    ContentView()
}
