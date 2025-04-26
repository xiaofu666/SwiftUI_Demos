//
//  ContentView.swift
//  CustomCalendarPlus
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct ContentView: View {
    @State var selectionMode: CalendarSelectionMode = .range
    @State var showsOverflowDates: Bool = true
    @State var allowsToSelect: Bool = true
    
    var body: some View {
        VStack {
            CustomCalendarView(config: .init(selectionMode: selectionMode, showsOverflowDates: showsOverflowDates, allowsToSelect: allowsToSelect)) { dates in
                print("************")
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone.current
                print(dates.map({ formatter.string(from: $0) }))
            }
            
            VStack(spacing: 30) {
                Picker("selectionMode", selection: $selectionMode) {
                    ForEach(CalendarSelectionMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                
                Toggle("showsOverflowDates", isOn: $showsOverflowDates)
                
                Toggle("allowsToSelect", isOn: $allowsToSelect)
            }
            .padding(15)
            .background(.cyan.opacity(0.1), in: .rect(cornerRadius: 10, style: .continuous))
            
            Spacer(minLength: 0)
        }
        .padding(15)
    }
}

enum CalendarSelectionMode: String, CaseIterable {
    case single = "Single"
    case range = "Range"
    case multiple = "Multiple"
}

struct CalendarConfig {
    var selectionMode: CalendarSelectionMode = .range
    var showsOverflowDates: Bool = true
    var allowsToSelect: Bool = true
}
    
struct CustomCalendarView: View {
    var config: CalendarConfig = CalendarConfig()
    var completed: ([Date]) -> ()
    @State var displayedMonth: Date = Date()
    @State var selectedDates: Set<Date> = []
    @State var selectedRange: (start: Date?, end: Date?) = (nil, nil)
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 16) {
            WeekdayHeaderView()
            
            let days: [Date] = generateMonthGrid()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 6) {
                ForEach(days, id: \.self) { date in
                    let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
                    if config.showsOverflowDates || isCurrentMonth {
                        let isSelected = isDateSelected(date)
                        let isStart = calendar.isDate(date, inSameDayAs: selectedRange.start ?? Date.distantPast)
                        let isEnd = calendar.isDate(date, inSameDayAs: selectedRange.end ?? Date.distantFuture)
                        
                        ZStack {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .foregroundColor(colorForDate(isSelected: isSelected, isStart: isStart, isEnd: isEnd, isCurrentMonth: isCurrentMonth))
                                .opacity(isPastAndNotAllowed(date) ? 0.3 : 1.0)
                                .strikethrough(isPastAndNotAllowed(date), color: Color.primary)
                            
                            Circle()
                                .frame(width: 6, height: 6)
                                .opacity(calendar.isDateInToday(date) ? 1 : 0)
                                .offset(y: 20)
                        }
                        .background(selectionBackground(for: config.selectionMode, isSelected: isSelected, isStart: isStart, isEnd: isEnd))
                        .onTapGesture {
                            handleSelection(date)
                        }
                    } else {
                        Color.clear.frame(minHeight: 40)
                    }
                }
            }
        }
        .onChange(of: selectedDates) { oldValue, newValue in
            completed(selectedDates.sorted(by: <))
        }
        .onChange(of: config.selectionMode) { oldValue, newValue in
            selectedDates = []
            selectedRange = (nil, nil)
        }
        .onChange(of: config.allowsToSelect) { oldValue, newValue in
            if !newValue {
                let today = calendar.startOfDay(for: Date())
                switch config.selectionMode {
                case .single, .multiple:
                    selectedDates = selectedDates.filter({ $0 < today })
                    selectedRange = (nil, nil)
                case .range:
                    if let end = selectedRange.end, end < today {
                        selectedDates = []
                        selectedRange = (nil, nil)
                    } else if let start = selectedRange.start, let end = selectedRange.end, start < today {
                        selectedRange = (start: today, end: end)
                        var currentDate = today
                        selectedDates = []
                        while currentDate <= end {
                            selectedDates.insert(currentDate)
                            // 增加 1 天
                            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                            currentDate = nextDate
                        }
                    }
                }
            }
        }
    }
    
    func colorForDate(isSelected: Bool, isStart: Bool, isEnd:Bool, isCurrentMonth: Bool) -> Color {
        if config.selectionMode == .range {
            if isStart || isEnd {
                return Color("Se")
            } else if isSelected {
                return Color.primary
            } else {
                return isCurrentMonth ? Color.primary : .gray
            }
        } else {
            return isSelected ? Color("Se") : (isCurrentMonth ? Color.primary : .gray)
        }
    }
    
    func generateMonthGrid() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1) else {
            return []
        }
        return stride(from: firstWeek.start, through: lastWeek.end, by: 24 * 60 * 60).map { $0 }
    }
    
    func handleSelection(_ date: Date) {
        let today = calendar.startOfDay(for: Date())
        let tappedDay = calendar.startOfDay(for: date)
        
        if !config.allowsToSelect && tappedDay < today {
            return
        }
        switch config.selectionMode {
        case .single:
            if selectedDates.contains(where:{ calendar.isDate($0, inSameDayAs: date)}) {
                selectedDates = selectedDates.filter { !calendar.isDate($0, inSameDayAs: date) }
            } else {
                selectedDates = [date]
            }
        case .multiple:
            if selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: date)}) {
                selectedDates = selectedDates.filter { !calendar.isDate($0, inSameDayAs: date) }
            } else {
                selectedDates.insert(date)
            }
        case .range:
            if selectedRange.start == nil, selectedRange.end == nil {
                selectedRange = (start: date, end: nil)
            } else if let start = selectedRange.start {
                if calendar.isDate(start, inSameDayAs: date) {
                    selectedRange = (start: nil, end: nil)
                    selectedDates = []
                } else {
                    let newStart = min(start, date)
                    let newEnd = max(start, date)
                    selectedRange = (start: newStart, end: newEnd)
                    selectedDates = []
                    var currentDate = newStart
                    while currentDate <= newEnd {
                        selectedDates.insert(currentDate)
                        // 增加 1 天
                        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                        currentDate = nextDate
                    }
                }
            }
        }
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        switch config.selectionMode {
        case .single, .multiple:
            return selectedDates.contains(where:{ calendar.isDate($0, inSameDayAs: date) })
        case .range:
            guard let start = selectedRange.start else { return false }
            if let end = selectedRange.end {
                return date >= start && date <= end
            }
            return calendar.isDate(date, inSameDayAs: start)
        }
    }
    
    func isPastAndNotAllowed(_ date: Date) -> Bool {
        let today = calendar.startOfDay(for: Date())
        let thisDay = calendar.startOfDay(for: date)
        return !config.allowsToSelect && thisDay < today
    }
    
    @ViewBuilder
    func selectionBackground(for mode: CalendarSelectionMode, isSelected: Bool, isStart: Bool, isEnd: Bool) -> some View {
        if isSelected {
            switch mode {
            case .range:
                if isStart {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0)
                } else if isEnd {
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10)
                } else {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.15))
                }
            case .single, .multiple:
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 48)
            }
        }
    }

    @ViewBuilder
    func WeekdayHeaderView() -> some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { changeMonth(by: -1)}){ Image(systemName:"chevron.left") }
                Spacer()
                Text(dateTitle).font(.headline)
                Spacer()
                Button(action: { changeMonth(by: 1)}){ Image(systemName:"chevron.right") }
            }
            .tint(.primary)
            .padding(.horizontal)
            
            HStack(spacing: 2) {
                ForEach(weekdays.indices, id: \.self) { index in
                    Text(weekdays[index])
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(index == todayWeekdayIndex ? Color.primary : Color.gray)
                        .padding(.vertical, 3)
                        .background(index == todayWeekdayIndex ? .gray.opacity(0.4) : .gray.opacity(0.2), in: .rect(cornerRadius: 8))
                }
            }
        }
    }
    
    var dateTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: displayedMonth)
    }

    var weekdays: [String] {
        return calendar.shortStandaloneWeekdaySymbols
    }

    var todayWeekdayIndex: Int {
        let originalIndex = calendar.component(.weekday, from: Date())
        return (originalIndex + 6 ) % 7
    }

    func changeMonth(by value: Int) {
        displayedMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
    }
}


#Preview {
    ContentView()
}
