//
//  Home.swift
//  CustomScrollAnimation
//
//  Created by Lurich on 2023/11/19.
//

import SwiftUI

struct Home: View {
    let safeArea: EdgeInsets
    
    @State private var selectedMonth: Date = .CurrentMonth
    @State private var selectedDate: Date = .now
    
    var body: some View {
        let maxHeight = calendarHeight - (safeArea.top + topPadding + calendarTitleViewHeight + weekLabelHeight + bottomPadding)
        ScrollView(.vertical) {
            VStack(spacing: 0, content: {
                CalendarView()
                
                VStack(spacing: 15, content: {
                    ForEach(1...15, id: \.self) { _ in
                        CardView()
                    }
                })
                .padding(15)
            })
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(CustomScrollBehavior(maxHeight: maxHeight))
    }
    
    @ViewBuilder
    func CardView() -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.blue.gradient)
            .frame(height: 70)
            .overlay(alignment: .leading) {
                HStack(spacing: 12, content: {
                    Circle()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 100, height: 5)
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 70, height: 5)
                    })
                })
                .foregroundStyle(.white.opacity(0.25))
                .padding(15)
            }
    }
    
    @ViewBuilder
    func CalendarView() -> some View {
        GeometryReader {
            let size = $0.size
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let maxHeight = size.height - (safeArea.top + topPadding + calendarTitleViewHeight + weekLabelHeight + bottomPadding)
            let progress = max(min((-minY/maxHeight), 1), 0)
            
            VStack(alignment: .leading, spacing: 0, content: {
                Text(currentMonth)
                    .font(.system(size: 35 - 10 * progress))
                    .offset(y: -50 * progress)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .overlay(alignment: .topLeading, content: {
                        GeometryReader(content: { geometry in
                            let size = geometry.size
                            Text(year)
                                .font(.system(size: 25 - 10 * progress))
                                .offset(x: (size.width + 5) * progress, y: 3 * progress)
                        })
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .topTrailing, content: {
                        HStack(spacing: 15, content: {
                            Button("", systemImage: "chevron.left") {
                                monthUpdate(false)
                            }
                            .contentShape(.rect)
                            Button("", systemImage: "chevron.right") {
                                monthUpdate(true)
                            }
                            .contentShape(.rect)
                        })
                        .offset(x: 150 * progress)
                    })
                    .frame(height: calendarTitleViewHeight)
                
                VStack(spacing: 0, content: {
                    HStack(spacing: 0, content: {
                        ForEach(calendar.weekdaySymbols, id: \.self) { week in
                            Text(week.prefix(3))
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.secondary)
                        }
                    })
                    .frame(height: weekLabelHeight, alignment: .bottom)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0, content: {
                        ForEach(selectedMonthDates) { day in
                            Text(day.shortSymbol)
                                .foregroundStyle(day.ignored ? .secondary : .primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay(alignment: .bottom, content: {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 5, height: 5)
                                        .opacity(calendar.isDate(day.date, inSameDayAs: selectedDate) ? 1 : 0)
                                        .offset(y: progress * -5)
                                })
                                .contentShape(.rect)
                                .onTapGesture {
                                    selectedDate = day.date
                                }
                        }
                    })
                    .frame(height: calendarGridHeight - (calendarGridHeight - 50) * progress, alignment: .top)
                    .offset(y: (monthProgress * -50) * progress)
                    .contentShape(.rect)
                    .clipped()
                })
                .offset(y: -50 * progress)
            })
            .foregroundStyle(.white)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.top, safeArea.top)
            .padding(.bottom, bottomPadding)
            .frame(maxHeight: .infinity)
            .frame(height: size.height - (maxHeight * progress), alignment: .top )
            .background(.red.gradient)
            .clipped()
            .contentShape(.rect)
            .offset(y: -minY)
        }
        .frame(height: calendarHeight)
        .zIndex(100)
    }
    
    func monthUpdate(_ increment: Bool) {
        guard let month = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedMonth) else {
            return
        }
        selectedMonth = month
    }
    
    var selectedMonthDates: [Day] {
        return extractDates(selectedMonth)
    }
}

#Preview {
    ContentView()
}

extension Home {
    var calendarTitleViewHeight: CGFloat {
        return 75.0
    }
    
    var horizontalPadding: CGFloat {
        return 15.0
    }
    
    var topPadding: CGFloat {
        return 15
    }
    
    var bottomPadding: CGFloat {
        return 5.0
    }
    
    var weekLabelHeight: CGFloat {
        return 30.0
    }
    
    var calendarGridHeight: CGFloat {
        return CGFloat(selectedMonthDates.count / 7) * 50
    }
    
    var calendarHeight: CGFloat {
        return safeArea.top + topPadding + calendarTitleViewHeight + weekLabelHeight + calendarGridHeight + bottomPadding
    }
    
    var monthProgress: CGFloat {
        if let index = selectedMonthDates.firstIndex(where: { day in
            calendar.isDate(day.date, inSameDayAs: selectedDate)
        }) {
            return CGFloat(index / 7).rounded()
        }
        return 1.0
    }
}

extension Home {
    var calendar: Calendar {
        let calendar = Calendar.current
        return calendar
    }
    
    var currentMonth: String {
        return format("MMMM")
    }
    
    var year: String {
        return format("YYYY")
    }
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: selectedMonth)
    }
}
extension View {
    func extractDates(_ month: Date) -> [Day] {
        var days: [Day] = []
        let calendar = Calendar.current
        let format = DateFormatter()
        format.dateFormat = "dd"
        guard let range = calendar.range(of: .day, in: .month, for: month)?.compactMap({ value -> Date? in
            return calendar.date(byAdding: .day, value: value - 1, to: month)
        }) else {
            return days
        }
        if let firstDate = range.first {
            let firstWeekDay = calendar.component(.weekday, from: firstDate)
            for index in Array(0..<firstWeekDay-1).reversed() {
                guard let date = calendar.date(byAdding: .day, value: -index - 1, to: firstDate) else { return days }
                let shortSymbol = format.string(from: date)
                days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
            }
        }
        range.forEach { date in
            let format = format.string(from: date)
            days.append(.init(shortSymbol: format, date: date))
        }
        if let lastDate = range.last {
            let lastWeekDay = 7 - calendar.component(.weekday, from: lastDate)
            for index in 0..<lastWeekDay {
                guard let date = calendar.date(byAdding: .day, value: index + 1, to: lastDate) else { return days }
                let shortSymbol = format.string(from: date)
                days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
            }
        }
        return days
    }
}

struct CustomScrollBehavior: ScrollTargetBehavior {
    var maxHeight: CGFloat
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < maxHeight {
            target.rect = .zero
        }
    }
}
