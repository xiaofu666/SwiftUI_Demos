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
    .init(date:.createDate(1, 1, 2023), value: 2508),
    .init(date:.createDate(1, 2, 2023), value: 3500),
    .init(date:.createDate(1, 3, 2023), value: 1500),
    .init(date:.createDate(1, 4, 2023), value: 9500),
    .init(date:.createDate(1, 5, 2023), value: 1950),
    .init(date:.createDate(1, 6, 2023), value: 5100)
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

extension [Download] {
    func findDownloads(_ on: String) -> Double? {
        if let download = self.first(where: {
            $0.month == on
        }) {
            return download.value
        }
        return nil
    }
    
    func index(_ on: String) -> Int {
        if let index = self.firstIndex(where: {
            $0.month == on
        }) {
            return index
        }
        return 0
    }
}
