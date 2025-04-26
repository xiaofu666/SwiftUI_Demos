//
//  ContentView.swift
//  LiquidAnimation
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct CircleData: Identifiable {
    let id: UUID
    let size: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    let speed: Double
}

struct ContentView: View {
    @State private var currentColor: Color = .red
    @State private var circles: [CircleData] = []
    let frameWidth: CGFloat = 100
    let frameHeight: CGFloat = 200
    let maxCircles: Int = 200
    let animationInterval: TimeInterval = 0.02
    
    var body: some View {
        ZStack {
            currentColor
                .mask {
                    Canvas { context, size in
                        let rectangleRect = CGRect(
                            x: size.width / 2 - 100,
                            y: size.height / 2 + 100,
                            width: 200,
                            height: 50
                        )
                        context.addFilter(.alphaThreshold(min: 0.4))
                        context.addFilter(.blur(radius: 10))
                        context.drawLayer { drawingContext in
                            for circle in circles {
                                let circleRect = CGRect(
                                    x: circle.xOffset + size.width / 2 - circle.size / 2,
                                    y: circle.yOffset + size.height / 2 - circle.size / 2,
                                    width: circle.size,
                                    height: circle.size
                                )
                                drawingContext.fill(Path(ellipseIn: circleRect), with: .color(.black))
                            }
                            drawingContext.fill(Path(rectangleRect), with: .color(.black))
                        }
                    }
                }
                .onTapGesture {
                    currentColor = randomColor()
                }
        }
        .ignoresSafeArea()
        .onAppear() {
            setupAnimation()
        }
    }
    
    func randomColor() -> Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
    
    func setupAnimation() {
        // 第一计时器：每0.2秒运行一次以生成新的圆圈
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            // 随机决定在这个循环中生成多少个圆（2-3）。
            let circlesToGenerate = Int.random(in: 2...3)
            // 循环以创建指定数量的新圆。
            for _ in 0..<circlesToGenerate {
                // 如果圈数超过允许的最大值，请删除最旧的圈
                if circles.count >= maxCircles {
                    circles.removeFirst()
                }
                // Create a new circle with random properties
                let newCircle = CircleData(
                    id: UUID(),
                    size: CGFloat.random(in: 10...30),
                    xOffset: CGFloat.random(in: -frameWidth / 2 ... frameWidth / 2),
                    yOffset: frameHeight / 2,
                    speed: Double.random(in: 1...2)
                )
                // 将新圆圈添加到“圆圈”数组中。
                circles.append(newCircle)
            }
        }
        // 第二计时器：频繁运行（animationInterval）以更新动画的圆圈位置。
        Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true){ _ in
            // 更新必须在主线程上进行，因为它涉及Ul更改。
            DispatchQueue.main.async {
                // 遍历“circles”数组中的所有圆。
                circles.indices.forEach { index in
                    // 逐渐减小每个圆圈的偏移量，使其向上移动。
                    circles[index].yOffset -= CGFloat(circles[index].speed)
                    // 这是动画机制：通过减少yoffset，圆圈在UI中平滑地向上移动。
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
