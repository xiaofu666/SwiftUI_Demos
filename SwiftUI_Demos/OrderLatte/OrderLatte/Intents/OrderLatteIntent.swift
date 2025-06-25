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
    @Dependency var manager: LatteOrderManager
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        manager.choices = try await requestChoice(between: Self.choices, dialog: .init("Select Latte Size")).title
        try await requestConfirmation(actionName: .set, snippetIntent: MilkPercentageConfirmationIntent())
        try await requestConfirmation(actionName: .order, snippetIntent: LatteCountConfirmationIntent())
        try await manager.orderLatte()
        return .result(
            view: LatteOrderView(
                choices: manager.choices,
                count: manager.count,
                milkPercentage: manager.milkPercentage,
                page: .page3
            )
            .padding(.horizontal, 15)
        )
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
    @Dependency var manager: LatteOrderManager
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        return .result(
            view: LatteOrderView(
                choices: manager.choices,
                count: manager.count,
                milkPercentage: manager.milkPercentage,
                page: .page1
            )
        )
    }
}

struct LatteCountConfirmationIntent: SnippetIntent{
    static var title: LocalizedStringResource = "Latte Count"
    @Dependency var manager: LatteOrderManager
    
    func perform() async throws -> some IntentResult & ShowsSnippetView {
        return .result(
            view: LatteOrderView(
                choices: manager.choices,
                count: manager.count,
                milkPercentage: manager.milkPercentage,
                page: .page2
            )
        )
    }
}
