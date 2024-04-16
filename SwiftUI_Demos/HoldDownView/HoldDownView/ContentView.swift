//
//  ContentView.swift
//  HoldDownView
//
//  Created by Lurich on 2024/3/20.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int = 0
    
    @State private var scale: Float = 0.8
    @State private var duration: Float = 1
    @State private var shapeStyle: Shape = .capsule
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(count)")
                    .font(.largeTitle.bold())
                    .padding(.top, 50)
                
                HoldDownButton(
                    text: "Hold To Increase",
                    paddingHorizontal: 25,
                    paddingVertical: 15,
                    duration: CGFloat(duration),
                    scale: CGFloat(scale),
                    background: .black,
                    loadingTint: .white.opacity(0.3),
                    shape: shapeStyle.shape
                ) {
                    count += 1
                }
                .foregroundStyle(.white)
                .padding(.vertical, 60)
                
                List {
                    Section {
                        Picker("shape", selection: $shapeStyle) {
                            ForEach(Shape.allCases, id: \.self) { shape in
                                Text(shape.rawValue)
                                    .tag(shape)
                            }
                        }
                        .pickerStyle(.segmented)

                    } header: {
                        Text("shape")
                    }
                    Section {
                        Picker("scale", selection: $scale) {
                            Text("0.8")
                                .tag(Float(0.8))
                            Text("0.9")
                                .tag(Float(0.9))
                        }
                        .pickerStyle(.segmented)

                    } header: {
                        Text("scale")
                    }
                    Section {
                        Picker("duration", selection: $duration) {
                            Text("0.5")
                                .tag(Float(0.5))
                            Text("1")
                                .tag(Float(1))
                            Text("2")
                                .tag(Float(2))
                        }
                        .pickerStyle(.segmented)

                    } header: {
                        Text("duration")
                    }
                }
            }
            .padding()
            .navigationTitle("Hold Down Button")
        }
    }
    
    enum Shape: String, CaseIterable {
        case rounded = "Rounded"
        case capsule = "Capsule"
        case ellipse = "Ellipse"
        
        var shape: AnyShape {
            switch self {
            case .rounded:
                    .init(.rect(cornerRadius: 10))
            case .capsule:
                    .init(.capsule)
            case .ellipse:
                    .init(.ellipse)
            }
        }
    }
}

#Preview {
    ContentView()
}
