//
//  FilterTransactionsView.swift
//  Expense Tracker
//
//  Created by Lurich on 2023/12/18.
//

import SwiftUI
import SwiftData

struct FilterTransactionsView<Content: View>: View {
    var content: ([Transaction]) -> Content
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    init(category: Category?, searchText: String, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.title.localizedStandardContains(searchText) || transaction.remarks.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true : rawValue == transaction.category)
        }
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transaction.dateAdded, order: .reverse)
        ], animation: .snappy)
        self.content = content
    }
    
    init(startDate: Date, endDate: Date, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        let predicate = #Predicate<Transaction> { transaction in
            return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
        }
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transaction.dateAdded, order: .reverse)
        ], animation: .snappy)
        self.content = content
    }
    
    init(startDate: Date, endDate: Date, category: Category?, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.dateAdded >= startDate && transaction.dateAdded <= endDate) && (rawValue.isEmpty ? true : rawValue == transaction.category)
        }
        _transactions = Query(filter: predicate, sort: [
            SortDescriptor(\Transaction.dateAdded, order: .reverse)
        ], animation: .snappy)
        self.content = content
    }
    
    var body: some View {
        content(transactions)
    }
}
