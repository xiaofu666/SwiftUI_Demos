//
//  ContentView.swift
//  CharRain
//
//  Created by Lurich on 2024/3/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.1)) { timeline in
            CharRainView(date: timeline.date)
                .ignoresSafeArea()
        }
    }
}

struct CharRainView: View {
    let date: Date
    var columnSize: CGFloat = 24
    @State private var nextIdx: [Int] = []
    @State private var row: [SavedChar] = []
    @State private var rows: [[SavedChar]] = []
    
    var body: some View {
        Canvas { context, size in
            context
                .fill(.init(roundedRect: .init(origin: .zero, size: size), cornerRadius: 0), with: .color(.black))
            
            for row in rows {
                for char in row {
                    context.draw(char.textView, in: char.pos)
                    char.opacity -= 0.1
                }
            }
        }
        .onAppear() {
            let columnCount = Int(UIScreen.main.bounds.width / columnSize) + 1
            nextIdx = Array(repeating: 0, count: columnCount)
        }
        .onChange(of: date) { oldValue, newValue in
            row = []
            for e in nextIdx.enumerated() {
                let pos = CGRect(x: columnSize * CGFloat(e.offset), y: columnSize *
                                 CGFloat(e.element), width: columnSize, height: columnSize)
                row.append(
                    SavedChar(text: getRandomChar(), pos: pos, color: getRandomColor(), opacity: 1)
                )
            }
            rows.append(row)
            rows = rows.filter { row in
                row.filter { char in
                    char.opacity > 0
                }.count > 0
            }
            nextIdx = nextIdx.map { x in
                if CGFloat(x) * columnSize > UIScreen.main.bounds.height && Double.random(in: 0...1) > 0.95 {
                    return 0
                } else {
                    return x + 1
                }
            }

        }
    }
    
    func getRandomChar() -> String {
        return String("abcdefghijklmnopqrstuvwxyz0123456789".randomElement() ?? "a")
    }
    func getRandomColor() -> Color {
        return Color(uiColor: UIColor(red: Double.random(in: 0.3...1), green: Double.random(in: 0.3...1), blue: Double.random(in: 0.3...1), alpha: 1.0))
    }
}

#Preview {
    ContentView()
}

class SavedChar {
    let text: String
    let pos: CGRect
    let color: Color
    var opacity: CGFloat = 1.0
    init(text: String,pos: CGRect, color: Color,opacity: CGFloat) {
        self.text = text
        self.pos = pos
        self.color = color
        self.opacity = opacity
    }
    var textView: Text {
        Text(text)
            .font(.system(size:16))
            .foregroundStyle(color.opacity(opacity))
    }
}
