//
//  Home.swift
//  PomodoroTimer
//
//  Created by Lurich on 2024/6/29.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var background: Color = .red
    @State private var flipClockTime: TimeModel = .init()
    @State private var pickerTime: TimeModel = .init()
    @State private var isStart: Bool = false
    @State private var totalTimeInSeconds: Int = 0
    @State private var timerCount: Int = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Query(sort: [SortDescriptor(\RecentModel.date, order: .reverse)], animation: .snappy) private var recents: [RecentModel]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pomodoro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.top, 15)
            
            TimeView()
                .padding(.top, 35)
            
            TimePicker(
                style: .init(.gray.opacity(0.15)),
                hour: $pickerTime.hour,
                minutes: $pickerTime.minutes,
                seconds: $pickerTime.seconds
            )
            .padding(15)
            .background(.white, in: .rect(cornerRadius: 15))
            .onChange(of: pickerTime, { oldValue, newValue in
                flipClockTime = newValue
            })
            .disabledWithOpacity(isStart)
            
            TimerButton()
            
            RecentsView()
                .disabledWithOpacity(isStart)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background.gradient)
        .onReceive(timer) { _ in
            if isStart {
                if timerCount > 0 {
                    timerCount -= 1
                    updateFlipClock()
                } else {
                    stopTimer()
                }
            } else {
                timer.upstream.connect().cancel()
            }
        }
    }
    
    func updateFlipClock() {
        let hour = (timerCount / 3600) % 24
        let minute = (timerCount / 60) % 60
        let seconds = (timerCount) % 60
        
        flipClockTime = .init(hour: hour, minutes: minute, seconds: seconds)
    }
    
    @ViewBuilder
    func RecentsView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recents")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.8))
                .opacity(recents.isEmpty ? 0 : 1)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(recents) { value in
                        let isHour = value.hour > 0
                        let isSeconds = value.hour == 0 && value.minute == 0 && value.seconds != 0
                        HStack(spacing: 0) {
                            Text(isHour ? "\(value.hour)" : isSeconds ? "\(value.seconds)" : "\(value.minute)")
                            Text(isHour ? "时" : isSeconds ? "秒" : "分")
                        }
                        .font(.callout)
                        .foregroundStyle(.black)
                        .frame(width: 50, height: 50)
                        .background(.white, in: .circle)
                        .contentShape(.contextMenuPreview, .circle)
                        .contextMenu {
                            Button("删除", role: .destructive) {
                                context.delete(value)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.snappy) {
                                pickerTime = .init(hour: value.hour, minutes: value.minute, seconds: value.seconds)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
    
    @ViewBuilder
    func TimerButton() -> some View {
        Button {
            isStart.toggle()
            if isStart {
                startTimer()
            } else {
                stopTimer()
            }
        } label: {
            Text(!isStart ? "Start Timer" : "Stop Timer")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.white, in: .rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
        }
        .disabledWithOpacity(flipClockTime.isZero && !isStart)
    }
    func startTimer() {
        totalTimeInSeconds = flipClockTime.totalInSeconds
        if !recents.contains(where: { $0.totalInSeconds == totalTimeInSeconds }) {
            let recent = RecentModel(hour: flipClockTime.hour, minute: flipClockTime.minutes, seconds: flipClockTime.seconds)
            context.insert(recent)
        }
        timerCount = totalTimeInSeconds - 1
        updateFlipClock()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    func stopTimer() {
        isStart = false
        totalTimeInSeconds = 0
        timerCount = 0
        flipClockTime = .init()
        withAnimation(.linear) {
            pickerTime = .init()
        }
        timer.upstream.connect().cancel()
    }
    
    @ViewBuilder
    func TimeView() -> some View {
        let size = CGSize(width: 100, height: 120)
        HStack(spacing: 10) {
            TimeViewHelper("时", $flipClockTime.hour, size)
            TimeViewHelper("分", $flipClockTime.minutes, size)
            TimeViewHelper("秒", $flipClockTime.seconds, size, true)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func TimeViewHelper(_ title: String, _ value: Binding<Int>, _ size: CGSize, _ isLast: Bool = false) -> some View {
        VStack(spacing: 10) {
            HStack {
                FlipClockTextEffect(
                    value: value,
                    size: size,
                    fontSize: 60,
                    cornerRadius: 18,
                    foreground: .black,
                    background: .white,
                    animationDuration: 0.8
                )
                
                if !isLast {
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.white)
                            .frame(width: 10, height: 10)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .fixedSize()
        }
    }
}

extension View {
    @ViewBuilder
    func disabledWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: condition)
    }
}

#Preview {
    ContentView()
}
