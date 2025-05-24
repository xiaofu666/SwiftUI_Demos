//
//  Date+Extension.swift
//  CalendarScrollEffect
//
//  Created by Xiaofu666 on 2025/5/24.
//

import SwiftUI

extension Date {
    // 提供当前周的日期
    static var currentWeek: [Day] {
        let calendar = Calendar.current
        guard let firstWeekDay = calendar.dateInterval(of: .weekOfMonth, for: .now)?.start else {
            return []
        }
        var week: [Day] = []
        for index in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: index, to: firstWeekDay) {
                week.append(.init(date: day))
            }
        }
        return week
    }
    
    // 将日期转换为给定格式的字符串
    func string(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    // 检查两个日期是否相同
    func isSame(_ date: Date?) -> Bool {
        guard let date else { return false }
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    struct Day: Identifiable {
        var id: String = UUID().uuidString
        var date: Date
        // 根据您的需求提供其他附加属性！
    }
}
