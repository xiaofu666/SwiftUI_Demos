//
//  ContentView.swift
//  AnimatedStateButton
//
//  Created by Xiaofu666 on 2025/3/22.
//

import SwiftUI

enum TransactionState: String {
    case idle = "Click to pay"
    case analyzing = "Analyzing Transaction"
    case processing = "Processing Transaction"
    case completed = "Transaction Completed"
    case failed = "Transaction Failed"
    
    var color: Color {
        switch self {
        case .idle:
            return .black
        case .analyzing:
            return .blue
        case .processing:
            return Color(red: 0.8, green: 0.35, blue: 0.2)
        case .completed:
            return .green
        case .failed:
            return .red
        }
    }
    
    var image: String? {
        switch self {
        case .idle: "apple.logo"
        case .analyzing: nil
        case .processing: nil
        case .completed: "checkmark.circle.fill"
        case .failed: "xmark.circle.fill"
        }
    }
}

struct ContentView: View {
    @State private var transactionState: TransactionState = .idle
    
    var body: some View {
        NavigationStack {
            VStack {
                let config = AnimatedButton.Config(
                    symbolImage: transactionState.image,
                    title: transactionState.rawValue,
                    foregroundColor: .white,
                    background: transactionState.color
                )
                
                AnimatedButton(config: config) {
                    transactionState = .analyzing
                    try? await Task.sleep(for: .seconds(3))
                    transactionState = .processing
                    try? await Task.sleep(for: .seconds(3))
                    transactionState = .completed
                    try? await Task.sleep(for: .seconds(2))
                    transactionState = .idle
                }
            }
            .navigationTitle("Custom Button")
        }
    }
}

#Preview {
    ContentView()
}
