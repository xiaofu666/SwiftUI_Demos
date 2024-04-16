//
//  Transaction.swift
//  CustomFileExtension
//
//  Created by Lurich on 2024/1/10.
//

import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers
import CryptoKit

struct Transaction: Identifiable,Codable {
    var id: UUID = .init()
    var title: String
    var date: Date
    var amount:Double
    /// FOR VIDEO PURPOSE
    init() {
        self.title = "Sample Text"
        self.amount = .random(in: 5000...10000)
        let calendar = Calendar.current
        self.date = calendar.date(byAdding: .day, value: .random(in: 1...100), to: .now) ?? .now
    }
}

struct Transactions: Codable, Transferable {
    var transactions: [Transaction]
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .richTransaction) { transferableData in
            let data = try JSONEncoder().encode(transferableData)
            guard let encryptedData = try AES.GCM.seal(data, using: .richKey).combined else {
                throw EncryptionError.failed
            }
            return encryptedData
        }
        .suggestedFileName("Transactions \(Date())")
    }
    
    enum EncryptionError: Error {
        case failed
    }
    
    static func decodedTransactions(_ url: URL) throws -> [Transaction] {
        let encryptedData = try Data(contentsOf: url)
        let decryptedData = try AES.GCM.open(.init(combined: encryptedData), using: .richKey)
        let decryptedTransactions = try JSONDecoder().decode(Transactions.self, from: decryptedData)
        return decryptedTransactions.transactions
    }
}


extension SymmetricKey {
    static var richKey: SymmetricKey {
        let key = "rich".data(using: .utf8)!
        let sha256 = SHA256.hash(data: key)
        return .init(data: sha256)
    }
}

extension UTType {
    static let richTransaction = UTType(exportedAs: "con.rich.CustomFileExtension.rich")
}
