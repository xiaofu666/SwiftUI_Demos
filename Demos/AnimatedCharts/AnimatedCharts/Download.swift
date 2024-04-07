//
//  Download.swift
//  AnimatedCharts
//
//  Created by Lurich on 2024/4/7.
//

import SwiftUI

struct Download: Identifiable {
    var id: UUID = .init()
    var date: Date
    var value: Double
    var isAnimated: Bool = false
    
    var month: String {
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string (from: date)
    }
}

var sampleDownloads: [Download] = [
    .init(date: .createDate(1, 08, 2023), value: 2500),
    .init(date: .createDate(1, 09, 2023), value: 3500),
    .init(date: .createDate(1, 10, 2023), value: 1500),
    .init(date: .createDate(1, 11, 2023), value: 5500),
    .init(date: .createDate(1, 12, 2023), value: 1950),
]

extension Date {
    static func createDate(_ day: Int, _ month: Int, _ year: Int) -> Date {
        var components = DateComponents ()
        components.day = day
        components.month = month
        components.year = year
        let calendar = Calendar.current
        let date = calendar.date(from: components) ?? .init()
        return date
    }
}
