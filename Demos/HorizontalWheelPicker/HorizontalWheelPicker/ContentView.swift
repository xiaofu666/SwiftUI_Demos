//
//  ContentView.swift
//  HorizontalWheelPicker
//
//  Created by Lurich on 2024/3/18.
//

import SwiftUI

struct ContentView: View {
    @State private var value: CGFloat = 0
    
    @State private var count: Int = 10
    @State private var steps: Int = 10
    @State private var multiplier: Int = 1
    @State private var spacing: CGFloat = 10
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                    Text(verbatim: String(format: "%.1f", value))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .contentTransition(.numericText(value: value))
                        .animation(.snappy, value: value)
                    
                    Text("lbs")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                })
                WheelPicker(config: .init(count: count, steps: steps, spacing: spacing, multiplier: multiplier), value: $value)
                    .frame(height: 60)
                
                List {
                    Section {
                        Picker("Count", selection: $count) {
                            ForEach(1...3, id: \.self) { index in
                                Text("\(index * 10)")
                                    .tag(index * 10)
                            }
                        }
                        .pickerStyle(.segmented)

                    } header: {
                        Text("Count")
                    }
                    Section {
                        Picker("steps", selection: $steps) {
                            ForEach(1...2, id: \.self) { index in
                                Text("\(index * 5)")
                                    .tag(index * 5)
                            }
                        }
                        .pickerStyle(.segmented)

                    } header: {
                        Text("steps")
                    }
                    Section {
                        Picker("Multiplier", selection: $multiplier) {
                            Text("\(1)")
                                .tag(1)
                            Text("\(10)")
                                .tag(10)
                        }
                        .pickerStyle(.segmented)

                    } header: {
                        Text("Multiplier")
                    }
                    Section {
                        Slider(value: $spacing, in: 5...20)
                    } header: {
                        Text("spacing")
                    }
                }
                
                NavigationLink {
                    StatureControlView()
                } label: {
                    Text("身高控件")
                }

            }
            .navigationTitle("Wheel Picker")
        }
    }
}

#Preview {
    ContentView()
}
