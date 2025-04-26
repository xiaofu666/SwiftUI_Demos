//
//  ColorMultiCirclePicker.swift
//  CustomColorPickers
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct ColorMultiCirclePicker: View {
    let circleSize: CGFloat = 300
    let circleCount: Int = 4
    
    @State private var circlePositions: [CGPoint] = []
    @State private var colors: [Color] = []
    
    var body: some View {
        VStack(spacing: 40) {
            HStack(spacing: 10) {
                ForEach(colors.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(colors[index])
                        .frame(width: 80, height: 80)
                }
            }
            
            ZStack {
                Canvas { context, size in
                    let rect = CGRect(origin: .zero, size: size)
                    let path = Path(ellipseIn: rect)
                    context.fill(path, with: .conicGradient(Gradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .red]), center: CGPoint(x: size.width / 2, y: size.height / 2)))
                }
            
                ForEach(circlePositions.indices, id: \.self) { index in
                    Circle()
                        .stroke(.white, lineWidth: 2)
                        .background(Circle().fill(colors[index]))
                        .frame(width: 40, height: 40)
                        .position(circlePositions[index])
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
                                        circlePositions[index] = CGPoint(x: constrainedX, y: constrainedY)
                                    } else {
                                        circlePositions[index] = value.location
                                    }
                                    
                                    colors[index] = getColor(at: circlePositions[index], center: center, radius: adjustedRadius)
                                }
                        )
                }
            }
            .frame(width: circleSize, height: circleSize)
        }
        .padding()
        .onAppear(perform: setupInitialPositionsAndColors)
    }
    
    private func setupInitialPositionsAndColors() {
        let center = CGPoint(x: circleSize / 2, y: circleSize / 2)
        let radius = (circleSize / 2) - 20
        let angleStep = (2 * .pi) / Double(circleCount)
        
        for i in 0..<circleCount {
            let angle = angleStep * Double(i)
            let x = center.x + radius * CGFloat(cos(angle))
            let y = center.y - radius * CGFloat(sin(angle))
            
            let position = CGPoint(x: x, y: y)
            circlePositions.append(position)
            colors.append(getColor(at: position, center: center, radius: radius))
        }
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
    ColorMultiCirclePicker()
}
