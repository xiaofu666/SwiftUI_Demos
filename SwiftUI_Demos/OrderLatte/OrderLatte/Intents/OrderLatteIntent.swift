//
//  OrderLatteIntent.swift
//  OrderLatte
//
//  Created by Xiaofu666 on 2025/6/25.
//

import SwiftUI
import AppIntents

struct OrderLatteIntent: AppIntent {
    static var title: LocalizedStringResource = "Order Latte"
    
    func perform() async throws -> some IntentResult {
        let choices = try await requestChoice(between: Self.choices, dialog: .init("Select Latte Size")).title
        try await requestConfirmation(actionName: .set, snippetIntent: MilkPercentageConfirmationIntent())
        return .result()
    }
    
    static var choices: [IntentChoiceOption] {
        [
            .init(title: "Small"),
            .init(title: "Medium"),
            .init(title: "Large")
        ]
    }
}

struct MilkPercentageConfirmationIntent: SnippetIntent{
    static var title: LocalizedStringResource = "Milk Percentage in Latte"
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        return .result(view: LatteOrderView())
    }
}
