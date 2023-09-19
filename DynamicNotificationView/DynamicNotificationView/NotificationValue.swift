//
//  NotificationValue.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/18.
//

import SwiftUI

struct NotificationValue: Identifiable {
    var id: String = UUID().uuidString
    var content: UNNotificationContent
    var dateCreated: Date = Date()
    var showNotifacation: Bool = false
}

