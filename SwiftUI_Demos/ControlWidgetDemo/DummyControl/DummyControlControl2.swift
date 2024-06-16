//
//  DummyControlControl2.swift
//  DummyControlExtension
//
//  Created by Lurich on 2024/6/16.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DummyControlControl2: ControlWidget {
    static let kind: String = "con.lurich.ControlWidgetDemo.DummyControl2"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: CaffeineUpdateIntent(amount: 10.0)) {
                Image(systemName: "cup.and.saucer.fill")
                Text("Caffeine In Take")
                let amount = ShareManager.shared.caffeineInTake
                Text("\(String(format: "%.1f", amount)) mgs")
            }
        }
    }
}

struct CaffeineUpdateIntent: AppIntent {
    static var title: LocalizedStringResource { "Update Caffeine In Take" }
    
    init() {
        
    }
    
    init(amount: Double) {
        self.amount = amount
    }
    
    @Parameter(title: "Amount Take")
    var amount: Double
    
    func perform() async throws -> some IntentResult {
        ShareManager.shared.caffeineInTake += amount
        return .result()
    }
}
