//
//  ColorBarPicker.swift
//  CustomColorPickers
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct ColorBarPicker: View {
    @State private var currentColor: Color = .red
    @State private var dragPosition: CGFloat = 20
    let barWidth: CGFloat = 280
    let circleWidth: CGFloat = 40
    let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .pink]
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(currentColor)
                .frame(height: 100)
                .padding()
            
            ZStack {
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                    .frame(width: barWidth, height: 50)
                    .clipShape(.capsule)
                    .overlay(alignment: .leading) {
                        Circle()
                            .stroke(lineWidth: 2)
                            .background(Circle().fill(currentColor))
                            .frame(width: circleWidth, height: circleWidth)
                            .offset(x: dragPosition - 15)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        withAnimation {
                                            dragPosition = max(20, min(value.location.x, barWidth - 30))
                                            currentColor = getColor(at: (dragPosition - 20) / (barWidth - circleWidth))
                                        }
                                    }
                            )
                    }
            }
        }
    }
    
    private func getColor(at position: CGFloat) -> Color {
        let segment: CGFloat = 1.0 / CGFloat(colors.count - 1)
        let index: Int = Int(position / segment)
        let progress = (position - CGFloat(index) * segment) / segment
        
        if index < colors.count - 1 {
            let startColor = UIColor(colors[index])
            let endColor = UIColor(colors[index + 1])
            
            var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
            var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
            
            startColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            endColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
            
            let r = r1 + (r2 - r1) * progress
            let g = g1 + (g2 - g1) * progress
            let b = b1 + (b2 - b1) * progress
            
            return Color(red: Double(r), green: Double(g), blue: Double(b))
        }
        
        return colors.last ?? .white
    }
}

#Preview {
    ColorBarPicker()
}
