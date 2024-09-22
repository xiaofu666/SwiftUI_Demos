//
//  ContentView.swift
//  ChipsUI
//
//  Created by Xiaofu666 on 2024/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var viewWidth: CGFloat = 300
    
    var body: some View {
        NavigationStack {
            VStack {
                ChipsView(width: viewWidth) {
                    ForEach(mockChips) { chip in
                        let horizontalSpace: CGFloat = 10
                        let viewWidth = chip.name.size(.preferredFont(forTextStyle: .body)).width + horizontalSpace * 2
                        
                        Text(chip.name)
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, horizontalSpace)
                            .background(.red.gradient, in: .capsule)
                            .containerValue(\.viewWidth, viewWidth)
                    }
                }
                .frame(width: viewWidth)
                .padding(15)
                .background(Color.primary.opacity(0.08), in: .rect(cornerRadius: 10))
                Spacer(minLength: 0)
                
                Slider(value: $viewWidth, in: 100...350) {
                    Text("\(viewWidth)")
                } minimumValueLabel: {
                    Text("100")
                } maximumValueLabel: {
                    Text("350")
                }

            }
            .padding(15)
            .navigationTitle("Chip's UI")
        }
    }
}

extension String {
    func size(_ font: UIFont) -> CGSize {
        size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

extension ContainerValues {
    @Entry var viewWidth: CGFloat = 0
}

#Preview {
    ContentView()
}
