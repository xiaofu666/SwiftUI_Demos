//
//  ContentView.swift
//  CustomCalendar
//
//  Created by Xiaofu666 on 2025/4/13.
//

import SwiftUI

let calendar = Calendar.current

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var title: String
}
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

extension String {
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self) ?? .now
    }
}

let tasks: [TaskModel] = [
    TaskModel(date: "2025-04-01".toDate, title: "Team meeting"),
    TaskModel(date: "2025-04-01".toDate, title: "Write blog post"),
    TaskModel(date: "2025-04-01".toDate, title: "Code review"),
    TaskModel(date: "2025-04-01".toDate, title: "Submit report"),
    TaskModel(date: "2025-04-01".toDate, title: "Buy groceries"),
    TaskModel(date: "2025-04-01".toDate, title: "Gym session"),
    TaskModel(date: "2025-04-15".toDate, title: "Prepare slides"),
    TaskModel(date: "2025-04-21".toDate, title: "Call client"),
    TaskModel(date: "2025-04-24".toDate, title: "Dentist appointment"),
    TaskModel(date: "2025-04-24".toDate, title: "Submit taxes'"),
    TaskModel(date: "2025-04-27".toDate, title: "Update resume"),
    TaskModel(date: "2025-04-27".toDate, title: "Dinner with friends")
]


struct ContentView: View {
    @State private var displayedMonth: Date = .now
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                WeekdayHeaderView(displayedMonth: $displayedMonth)
                
                let days = generateMonthGrid()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), alignment: .center, spacing: 2) {
                    ForEach(days, id: \.self) { date in
                        let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity:.month)
                        let tasksForDay = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
                        let isSelected = selectedDate != nil && calendar.isDate(selectedDate!,
                        inSameDayAs: date)

                        VStack(spacing: 4) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, minHeight: 45)
                                .foregroundColor( isSelected ? .SE : (isCurrentMonth ? .primary : .gray ))
                                .background(isSelected ? Color.primary : isCurrentMonth ? .BG : .gray.opacity(0.2))
                                .clipShape(.rect(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(Calendar.current.isDateInToday(date) ? Color.primary : .clear)
                                        .padding(1)
                                }
                                .overlay(alignment: .bottom) {
                                    HStack(spacing: 3) {
                                        ForEach(0..<min(tasksForDay.count, 5), id: \.self) { _ in
                                            Circle()
                                                .frame(width: 4, height: 4)
                                                .padding(.bottom, 5)
                                                .foregroundStyle(isSelected ? .SE : .primary)
                                        }
                                    }
                                }
                        }
                        .onTapGesture {
                            if let selected = selectedDate, calendar.isDate(selected, inSameDayAs: date) {
                                selectedDate = nil
                            } else {
                                selectedDate = date
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    let visibleTasks = selectedDate != nil ? tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate!)} : tasks
                    if visibleTasks.isEmpty {
                        Text("No tasks for this day.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(visibleTasks) { task in
                            HStack {
                                Text(task.title)
                                    .frame(height: 55)
                                
                                Spacer()
                                
                                Image(systemName: "circle")
                            }
                            .padding(.horizontal, 12)
                            .background(.BG, in: .rect(cornerRadius:12))
                        }
                    }
                }
                
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
    }
    
    func generateMonthGrid() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1) else { return [] }
        return stride(from: firstWeek.start, to: lastWeek.end, by: 24 * 60 * 60).map { $0 }
    }
}

struct WeekdayHeaderView: View {
    @Binding var displayedMonth: Date
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { changeMonth(by: -1)}){ Image(systemName:"chevron.left") }
                Spacer()
                Text(formatter.string(from: displayedMonth)).font(.headline)
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
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy MMMM"
        return f
    }()
    
    var weekdays: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        return symbols
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
