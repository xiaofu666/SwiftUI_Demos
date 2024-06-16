//
//  ShareManager.swift
//  ControlWidgetDemo
//
//  Created by Lurich on 2024/6/16.
//

import SwiftUI

class ShareManager {
    static let shared = ShareManager()
    var isTurnedOn: Bool = false
    var caffeineInTake: CGFloat = 0
}
