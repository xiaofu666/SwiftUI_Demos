//
//  Downloads.swift
//  WidgetsDemo
//
//  Created by Lurich on 2023/12/11.
//

import SwiftUI

struct Downloads: Identifiable, Equatable {
    var id: UUID = .init()
    var date: Date
    var value: Int
}

extension Date {
    static func day(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day,value: value,to: .now) ?? .now
    }
}
var appDownloads: [Downloads] = [
    .init(date: .day(0 ), value: 100),
    .init(date: .day(-1), value: 180),
    .init(date: .day(-2), value: 60),
    .init(date: .day(-3), value: 120),
    .init(date: .day(-4), value: 370),
    .init(date: .day(-5), value: 48),
    .init(date: .day(-6), value: 77),
]
var appDownloads1: [Downloads] = [
    .init(date: .day(0 ), value: 180),
    .init(date: .day(-1), value: 100),
    .init(date: .day(-2), value: 58),
    .init(date: .day(-3), value: 220),
    .init(date: .day(-4), value: 170),
    .init(date: .day(-5), value: 148),
    .init(date: .day(-6), value: 37),
]
var appDownloads2: [Downloads] = [
    .init(date: .day(0 ), value: 190),
    .init(date: .day(-1), value: 80),
    .init(date: .day(-2), value: 160),
    .init(date: .day(-3), value: 20),
    .init(date: .day(-4), value: 70),
    .init(date: .day(-5), value: 148),
    .init(date: .day(-6), value: 137),
]

