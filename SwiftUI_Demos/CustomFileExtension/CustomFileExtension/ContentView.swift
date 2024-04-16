//
//  ContentView.swift
//  CustomFileExtension
//
//  Created by Lurich on 2024/1/10.
//

import SwiftUI

struct ContentView: View {
    @State private var transactions: [Transaction] = []
    @State private var importTransactions: Bool = false
    
    var body: some View {
        NavigationStack {
            List(transactions) { transaction in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text(transaction.title)
                        
                        Text(transaction.date.formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    })
                    
                    Spacer(minLength: 0)
                    
                    Text("$ \(Int(transaction.amount))")
                        .font(.callout.bold())
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ShareLink(item: Transactions(transactions: transactions), preview: SharePreview("Share", image: "square.and.arrow.up.fill"))
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "square.and.arrow.down.fill") {
                        importTransactions.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "plus") {
                        transactions.append(.init())
                    }
                }
            }
        }
        .fileImporter(isPresented: $importTransactions, allowedContentTypes: [.richTransaction]) { result in
            switch result {
            case .success(let URL):
                do {
                    self.transactions = try Transactions.decodedTransactions(URL)
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
