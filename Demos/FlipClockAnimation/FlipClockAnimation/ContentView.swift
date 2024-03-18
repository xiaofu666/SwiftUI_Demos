//
//  ContentView.swift
//  FlipClockAnimation
//
//  Created by Lurich on 2024/3/10.
//

import SwiftUI

let clockColor: Color = Color.bg
let time: TimeInterval = 0.2

struct ContentView: View {
    @State private var hour = 0
    @State private var minute = 0
    @State private var second = 0
    @State private var AmOrPm: String = "AM"
    @State private var animationDone: Bool = false
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        ZStack {
            Color.primary
                .ignoresSafeArea()
            let layout = (verticalSizeClass == .compact) ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
            layout {
                FlipNumberView(current: hour)
                    .overlay(alignment: .topLeading) {
                        Text(AmOrPm)
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.background)
                            .padding(15)
                    }
                FlipNumberView(current: minute)
                FlipNumberView(current: second)
            }
            .padding(15)
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { date in
            hour = currentCalendar.component(.hour, from: date + 1)
            minute = currentCalendar.component(.minute, from: date + 1)
            second = currentCalendar.component(.second, from: date + 1)
        })
        .onAppear() {
            let date = Date.now
            hour = currentCalendar.component(.hour, from: date + 1)
            minute = currentCalendar.component(.minute, from: date + 1)
            second = currentCalendar.component(.second, from: date + 1)
        }
    }
    
    var currentCalendar: Calendar {
        return Calendar.current
    }
}
extension Int {
    func toDisplay() -> String {
        if self >= 0 && self < 10{
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}
struct FlipAnimate {
    var flip1: Double = 0
    var flip2: Double = 90
}
struct FlipNumberView: View {
    var current: Int = 0
    
    var body: some View {
        let cur = current.toDisplay()
        let prev = ((current - 1 + 60) % 60).toDisplay()
        
        KeyframeAnimator(initialValue: FlipAnimate(), trigger: current) { values in
            ZStack {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(clockColor)
                    .overlay {
                        Text(cur)
                            .font(.system(size: 120))
                            .foregroundStyle(.background)
                    }
                    .frame(height: 240)
                    .mask {
                        Rectangle()
                            .frame(height:120)
                            .offset(y: -60)
                    }
                
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(clockColor)
                    .overlay {
                        Text(prev)
                            .font(.system(size:120))
                            .foregroundStyle(.background)
                    }
                    .frame(height:240)
                    .mask {
                        Rectangle()
                            .frame(height:120)
                            .offset(y: 60)
                    }
                
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(clockColor)
                    .overlay {
                        Text(prev)
                            .font(.system(size: 120))
                            .foregroundStyle(.background)
                    }
                    .frame(height: 240)
                    .mask {
                        Rectangle()
                            .frame(height:120)
                            .offset(y: -60)
                    }
                    .rotation3DEffect(
                        .degrees(values.flip1),
                        axis: (x: -1.0, y: 0.0, z: 0.0)
                    )
                
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(clockColor)
                    .overlay {
                        Text(cur)
                            .font(.system(size:120))
                            .foregroundStyle(.background)
                    }
                    .frame(height:240)
                    .mask {
                        Rectangle()
                            .frame(height:120)
                            .offset(y: 60)
                    }
                    .rotation3DEffect(
                        .degrees(values.flip2),
                        axis: (x: 1.0, y: 0.0,z: 0.0)
                    )
            }
            .overlay {
                Rectangle()
                    .fill(clockColor)
                    .frame(height: 3)
            }
        } keyframes: { _ in
            KeyframeTrack(\.flip1) {
                LinearKeyframe(0, duration: time)
                LinearKeyframe(90, duration: time)
                LinearKeyframe(90, duration: time)
            }
            KeyframeTrack(\.flip2) {
                LinearKeyframe(90, duration: time)
                LinearKeyframe(90, duration: time)
                LinearKeyframe(0, duration: time)
            }
        }
        
    }
}


#Preview {
    ContentView()
}
