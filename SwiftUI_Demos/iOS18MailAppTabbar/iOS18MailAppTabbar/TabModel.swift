//
//  TabModel.swift
//  iOS18MailAppTabbar
//
//  Created by Xiaofu666 on 2024/11/24.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case primary = "Primary"
    case transactions = "Transactions"
    case update = "Updates"
    case promotions = "Promotions"
    case allMails = "All Mails"
    
    var color: Color {
        switch self {
        case .primary:
                .blue
        case .transactions:
                .green
        case .update:
                .indigo
        case .promotions:
                .purple
        case .allMails:
                .black
        }
    }
    
    var symbolImage: String {
        switch self {
        case .primary:
            "person"
        case .transactions:
            "cart"
        case .update:
            "text.bubble"
        case .promotions:
            "megaphone"
        case .allMails:
            "tray"
        }
    }
}
