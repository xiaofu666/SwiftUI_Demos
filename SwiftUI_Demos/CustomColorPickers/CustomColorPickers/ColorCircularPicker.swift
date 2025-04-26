//
//  CircularCP.swift
//  CustomColorPickers
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct ColorCircularPicker: View {
    let circleSize: CGFloat = 300
    
    @State private var currentColor: Color = .white
    @State private var dragPosition: CGPoint = CGPoint(x: 150, y: 150)
    @State private var selectedColor: Color = .white
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(0..<11, id: \.self) { index in
                    let brightness = Double(index) / 11.0 + 0.05
                    
                    Rectangle()
                        .fill(currentColor.opacity(brightness))
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            print(brightness)
                            selectedColor = currentColor.opacity(brightness)
                        }
                }
            }
            .padding(.horizontal)

            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(selectedColor)
                .frame(height: 100)
                .padding()
            
            ZStack {
                Canvas { context, size in
                    let rect = CGRect(origin: .zero, size: size)
                    let path = Path(ellipseIn: rect)
                    context.fill(path, with: .conicGradient(Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .red]), center: CGPoint(x: size.width / 2, y: size.height / 2)))
                }
                
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .background(Circle().fill(currentColor))
                    .frame(width: 40, height: 40)
                    .position(dragPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let center = CGPoint(x: circleSize / 2, y: circleSize / 2)
                                let adjustedRadius = (circleSize / 2) - 20
                                let offsetX = value.location.x - center.x
                                let offsetY = value.location.y - center.y
                                let distance = sqrt(offsetX * offsetX + offsetY * offsetY)
                                
                                if distance > adjustedRadius {
                                    let scale = adjustedRadius / distance
                                    let constrainedX = center.x + offsetX * scale
                                    let constrainedY = center.y + offsetY * scale
                                    dragPosition = CGPoint(x: constrainedX, y: constrainedY)
                                } else {
                                    dragPosition = value.location
                                }
                                
                                currentColor = getColor(at: dragPosition, center: center, radius: adjustedRadius)
                                selectedColor = currentColor
                            }
                    )
            }
            .frame(width: circleSize, height: circleSize)
        }
        .padding()
    }
    
    private func getColor(at point: CGPoint, center: CGPoint, radius: CGFloat) -> Color {
        let dx = point.x - center.x
        let dy = point.y - center.y
        var angle = atan2(dy, dx)
        if angle < 0 {
            angle += 2 * .pi
        }
        let hue = angle / (2 * .pi)
        let distance = sqrt(dx * dx + dy * dy)
        let saturation = min(distance / radius, 1.0)
        
        return Color(hue: hue, saturation: saturation, brightness: 1.0)
    }
}

#Preview {
    ColorCircularPicker()
}
