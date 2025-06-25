//
//  LatteOrderManager.swift
//  OrderLatte
//
//  Created by Xiaofu666 on 2025/6/25.
//

import SwiftUI

class LatteOrderManager {
    var choices: LocalizedStringResource = ""
    var count: Int = 1
    var milkPercentage: Int = 20
    
    func orderLatte() async throws {
        /// YOUR CODE HERE
        /// This is a dummy delay for tutorial purpose!
        try? await Task.sleep(for:.seconds(1))
        print("Orderer Latte with (\(count) cup(s), (\(milkPercentage)% milk, \(choices)")
    }
}
