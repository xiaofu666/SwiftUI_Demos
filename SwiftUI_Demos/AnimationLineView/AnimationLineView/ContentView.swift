//
//  ContentView.swift
//  AnimationLineView
//
//  Created by Xiaofu666 on 2024/7/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            AnimationLineView(size: size)
        }
    }
}

struct AnimationLineView: View {
    var size: CGSize
    let count: Int = 30
    let maxDistance: CGFloat = 150
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
                                point.reloadPoint()
                                if let ciecleView = content.resolveSymbol(id: point.id) {
                                    ctx.draw(ciecleView, at: CGPoint(x: size.width / 2.0, y: size.height / 2.0))
                                }
                            }
                            for index in 0..<linePoints.count {
                                if let lineView = content.resolveSymbol(id: index) {
                                    ctx.draw(lineView, at: CGPoint(x: size.width / 2.0, y: size.height / 2.0))
                                }
                            }
                        }
                    } symbols: {
                        ForEach(points) { point in
                            CircleView(point)
                                .tag(point.id)
                        }
                        ForEach(0..<linePoints.count, id: \.self) { i in
                            let point1 = linePoints[i].0.point
                            let point2 = linePoints[i].1.point
                            let distance = distance(point1, point2)
                            if distance < maxDistance {
                                LineView(point1, point2, distance)
                                    .tag(i)
                            }
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
        Path { path in
            path.addArc(center: point.point, radius: point.r, startAngle: .init(degrees: 0), endAngle: .init(degrees: 360), clockwise: true)
        }
        .fill(.white)
    }
    
    @ViewBuilder
    func LineView(_ point1: CGPoint, _ point2: CGPoint, _ distance: CGFloat) -> some View {
        Path { path in
            path.move(to: point1)
            path.addLine(to: point2)
        }
        .stroke(.white.opacity(opacity(distance, maxDistance)), lineWidth: 1.0)
    }
    
    func distance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let length = sqrt(dx * dx + dy * dy)
        return length
    }
    func opacity(_ length: CGFloat, _ maxDis: CGFloat = 150) -> CGFloat {
        switch length {
        case maxDis...:
            return 0
        case ...0:
            return 1
        default:
            return 1 - length / maxDis
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
        
        var point: CGPoint {
            return .init(x: x, y: y)
        }
        
        init(r: CGFloat = 3, size: CGSize) {
            self.r = r
            self.size = size
            self.x = CGFloat.random(in: 0...size.width)
            self.y = CGFloat.random(in: 0...size.height)
            self.xSpeed = CGFloat((-1...1).randomElement() ?? 1)
            self.ySpeed = CGFloat((-1...1).randomElement() ?? 1)
        }
        
        func reloadPoint() {
            x += xSpeed
            y += ySpeed
            if x > size.width - r || x < r {
                xSpeed = -xSpeed
            }
            if y > size.height - r || y < r {
                ySpeed = -ySpeed
            }
        }
    }
}

#Preview {
    ContentView()
}
