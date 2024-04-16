//
//  Date++.swift
//  CustomScrollAnimation
//
//  Created by Lurich on 2023/11/19.
//

import SwiftUI

extension Date {
    static var CurrentMonth: Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(from: Calendar.current.dateComponents([.month, .year], from: .now)) else {
            return .now
        }
        return currentMonth
    }
}

struct Day: Identifiable {
    var id: UUID = .init()
    var shortSymbol: String
    var date: Date
    var ignored: Bool = false
}
