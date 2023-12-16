//
//  UserDefaults+Extensions.swift
//  Expense Tracker
//
//  Created by Lurich on 2023/12/16.
//

import SwiftUI

extension UserDefaults {
    enum Key: String {
        case isFirstTime
        case userName
        case isAppLockEnabled
        case lockWhenAppGoesBackground
    }
}
