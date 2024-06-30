//
//  RecentModel.swift
//  PomodoroTimer
//
//  Created by Lurich on 2024/6/29.
//

import SwiftUI
import SwiftData

@Model
class RecentModel {
    var hour: Int
    var minute: Int
    var seconds: Int
    var date: Date = Date()
    
    init(hour: Int, minute: Int, seconds: Int) {
        self.hour = hour
        self.minute = minute
        self.seconds = seconds
    }
    
    var totalInSeconds: Int {
        return (hour * 60 * 60) + (minute * 60) + seconds
    }
}
