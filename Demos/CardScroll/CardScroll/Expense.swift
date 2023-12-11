//
//  Expense.swift
//  CardScroll
//
//  Created by Lurich on 2023/11/4.
//

import SwiftUI

struct Expense: Identifiable {
    var id: UUID = UUID()
    var amountSpent: String
    var product: String
    var spendType: String
}

var expenses_test: [Expense] = [
    Expense(amountSpent: "$128", product: "Amazon Purchase",     spendType: "Groceries"),
    Expense(amountSpent: "$10",  product: "Youtube Premium",     spendType: "Streaming"),
    Expense(amountSpent: "$10",  product: "Dribble",             spendType: "Membership"),
    Expense(amountSpent: "$99",  product: "Magic Keyboard",      spendType: "Products"),
    Expense(amountSpent: "$9",   product: "Pattern",             spendType: "Membership"),
    Expense(amountSpent: "$108", product: "Instagram",           spendType: "Ad Publish"),
    Expense(amountSpent: "$15",  product: "Netflix",             spendType: "Streaming"),
    Expense(amountSpent: "$348", product: "Photoshop",           spendType: "Editing"),
    Expense(amountSpent: "$99",  product: "Sigma",               spendType: "ProMember"),
    Expense(amountSpent: "$89",  product: "Magic Mouse",         spendType: "Products"),
    Expense(amountSpent: "$120", product: "Studio Display",      spendType: "Products"),
    Expense(amountSpent: "$39",  product: "Sketch Subscription", spendType: "Membership")
]
