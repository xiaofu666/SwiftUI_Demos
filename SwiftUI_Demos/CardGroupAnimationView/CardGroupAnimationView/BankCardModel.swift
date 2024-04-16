//
//  BankCardModel.swift
//  CardGroupAnimationView
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

struct BankCardModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var cardName: String
    var cardColor: Color
    var cardBalance: String
    var isFirstBlankCard: Bool = false
    var expenses: [ExpenseModel] = []
}

struct ExpenseModel: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}

/// Sample Cards
var sampleCards: [BankCardModel] = [
    .init (cardName: "", cardColor: .clear, cardBalance: "", isFirstBlankCard: true),
    .init(cardName: "iJustine", cardColor: Color ("albumColor1"), cardBalance: "$1024.9", expenses: [
        ExpenseModel(amountSpent: "$18", product: "Youtube", productIcon: "album1", spendType: "Streaming"),
        ExpenseModel(amountSpent : "$128", product: "Amazon", productIcon: "album2", spendType: "Groceries"),
        ExpenseModel(amountSpent: "$28", product: "Apple", productIcon: "album2", spendType: "Apple Pay"),
    ]),
    .init (cardName: "Justine", cardColor: Color ("albumColor2"), cardBalance: "$2439.5", expenses: [
        ExpenseModel(amountSpent: "$9", product: "Patreon", productIcon: "user1", spendType: "Membership"),
        ExpenseModel(amountSpent : "$10", product: "Dribbble", productIcon: "user2", spendType: "Membership"),
        ExpenseModel(amountSpent : "$100", product: "Instagram", productIcon: "user3", spendType: "Ad Publish"),
    ]),
    .init (cardName: "Justine", cardColor: Color ("albumColor3"), cardBalance: "$459.78", expenses: [
        ExpenseModel(amountSpent: "$55", product: "Netflix", productIcon: "user4", spendType: "Movies"),
        ExpenseModel(amountSpent: "348", product: "Photoshop", productIcon: "user5", spendType: "Editing"),
        ExpenseModel(amountSpent: "$99", product: "Figma", productIcon: "user6", spendType: "Pro Member"),
    ]),
    .init (cardName: "Lurich", cardColor: Color("MyGreen"), cardBalance: "$52013.14"),
]
