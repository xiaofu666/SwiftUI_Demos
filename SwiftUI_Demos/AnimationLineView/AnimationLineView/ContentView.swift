//
//  ContentView.swift
//  AnimationLineView
//
//  Created by Xiaofu666 on 2024/7/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            AnimationLineView(size: CGSize(width: size.width, height: size.height))
        }
        .background(.black)
    }
}
struct AnimationLineView: View {
    var size: CGSize
    let count: Int = 30
    @State private var points: [Point] = []
    @State private var linePoints: [(Point, Point)] = []
    
    var body: some View {
        VStack {
            if !points.isEmpty {
                TimelineView(.animation) { _ in
                    Canvas { content, size in
                        content
                            .fill(.init(roundedRect: .init(origin: .zero, size: size), cornerRadius: 0), with: .color(.black))
                        
                        content.drawLayer { ctx in
                            for point in points {
                                point.drawPoint()
                                if let resolvedView = content.resolveSymbol(id: point.id) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width / 2.0, y: size.height / 2.0))
                                }
                            }
                            for index in 0..<linePoints.count {
                                if let lineView = content.resolveSymbol(id: index) {
                                    ctx.draw(lineView, at: CGPoint(x: size.width, y: size.height))
                                }
                            }
                        }
                    } symbols: {
                        ForEach(points) { point in
                            CircleView(point)
                                .tag(point.id)
                        }
                        ForEach(0..<linePoints.count, id: \.self) { i in
                            LineView(linePoints[i].0, linePoints[i].1)
                                .tag(i)
                        }
                    }
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear() {
            guard points.isEmpty else { return }
            for _ in 0...count {
                points.append(.init(size: size))
            }
            for i in 0...count {
                for j in i...count {
                    linePoints.append((points[i], points[j]))
                }
            }
        }
    }
    
    @ViewBuilder
    func CircleView(_ point: Point) -> some View {
        Circle()
            .fill(.white)
            .frame(width: 3)
            .offset(x: point.x, y: point.y)
    }
    
    @ViewBuilder
    func LineView(_ point1: Point, _ point2: Point) -> some View {
        drawLine(point1, point2)
            .trim(from: 0, to: 1)
            .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round))
            .fill(.white.opacity(opacity(point1, point2)))
    }
    
    func opacity(_ point1: Point, _ point2: Point) -> Double {
        let space: Double = 150.0
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let length = sqrt(dx * dx + dy * dy)
        switch length {
        case space...:
            return 0
        case ...0:
            return 1
        default:
            return Double(1 - length / space)
        }
    }
    
    func drawLine(_ point1: Point, _ point2: Point) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            path.addLine(to: CGPoint(x: point2.x, y: point2.y))
        }
    }
    
    class Point: Identifiable {
        let id: UUID = .init()
        var r: CGFloat
        var x: CGFloat
        var y: CGFloat
        var xSpeed: CGFloat
        var ySpeed: CGFloat
        var size: CGSize
        
        init(r: CGFloat = 3, size: CGSize) {
            self.r = r
            self.size = size
            self.x = CGFloat.random(in: -size.width...size.width) / 2.0
            self.y = CGFloat.random(in: -size.height...size.height) / 2.0
            self.xSpeed = CGFloat((-1...1).randomElement() ?? 1)
            self.ySpeed = CGFloat((-1...1).randomElement() ?? 1)
        }
        
        func drawPoint() {
            x += xSpeed
            y += ySpeed
            if x > size.width/2.0 || x < -size.width/2.0 {
                xSpeed = -xSpeed
            }
            if y > size.height/2.0 || y < -size.height/2.0 {
                ySpeed = -ySpeed
            }
        }
    }
}

#Preview {
    ContentView()
}
