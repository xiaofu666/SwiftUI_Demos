//
//  DummyControlControl.swift
//  DummyControl
//
//  Created by Lurich on 2024/6/16.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DummyControlControl: ControlWidget {
    static let kind: String = "con.lurich.ControlWidgetDemo.DummyControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetToggle(isOn: ShareManager.shared.isTurnedOn, action: DummyControlIntent()) { isTurnedOn in
                Image(systemName: isTurnedOn ? "fan.fill" : "fan")
                Text(isTurnedOn ? "Turned On" : "Turned Off")
            } label: {
                Text("Living Room")
            }
        }
    }
}

struct DummyControlIntent: SetValueIntent {
    static var title: LocalizedStringResource {
        return "Turn on living room fan"
    }
    
    @Parameter(title: "is Turned On")
    var value: Bool
    
    func perform() async throws -> some IntentResult {
        ShareManager.shared.isTurnedOn = value
        return .result()
    }
}
