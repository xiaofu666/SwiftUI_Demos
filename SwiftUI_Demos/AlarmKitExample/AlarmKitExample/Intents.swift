//
//  Intents.swift
//  AlarmKitExample
//
//  Created by Xiaofu666 on 2025/6/28.
//

import SwiftUI
import AppIntents
import AlarmKit

struct AlarmActionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Alarm Action"
    static var isDiscoverable: Bool = false
    
    @Parameter
    var id: String
    
    @Parameter
    var isCancel: Bool
    
    @Parameter
    var isResume: Bool
    
    init(id: UUID, isCancel: Bool = false, isResume: Bool = false) {
        self.id = id.uuidString
        self.isCancel = isCancel
        self.isResume = isResume
    }
    
    init() {
    }
    
    func perform() async throws -> some IntentResult {
        if let alarmID = UUID(uuidString: id) {
            if isCancel {
                /// Cancel Alarm
                try AlarmManager.shared.cancel(id: alarmID)
            } else {
                if isResume {
                    /// Resume Alarm
                    try AlarmManager.shared.resume(id: alarmID)
                } else {
                    /// Pause Alarm
                    try AlarmManager.shared.pause(id: alarmID)
                }
            }
        }
        return .result()
    }
}
