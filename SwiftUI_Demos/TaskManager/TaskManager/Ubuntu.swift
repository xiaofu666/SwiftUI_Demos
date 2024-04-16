//
//  Ubuntu.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI

enum Ubuntu {
    case light
    case bold
    case medium
    case regular
    
    var weight: Font.Weight {
        switch self {
            case .light:
                return .light
            case .bold:
                return.bold
            case .medium:
                return .medium
            case.regular:
                return .regular
        }
    }
}

@available(iOS 16.0, *)
extension View {
    func ubuntu(_ size: CGFloat, _ weight: Ubuntu) -> some View {
        self.font(.custom("", size: size))
            .fontWeight(weight.weight)
    }
    
    func hAligm(_ aligment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: aligment)
    }
    
    func vAligm(_ aligment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: aligment)
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toDate(_ format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}

extension Calendar {
    var hours: [Date] {
        let starOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for index in 0..<24 {
            if let date = self.date(byAdding: .hour, value: index, to: starOfDay) {
                hours.append(date)
            }
        }
        return hours
    }
    var currentWeek: [WeekDay] {
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else {
            return []
        }
        var week: [WeekDay] = []
        for index in 0 ..< 7 {
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
                let weekDaySymbol: String = day.toString("EEEE")
                let isToday = self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
            }
        }
        return week
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var string: String
        var date: Date
        var isToday: Bool = false
    }
}
