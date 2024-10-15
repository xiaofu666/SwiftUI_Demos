//
//  Item.swift
//  DragToSelect
//
//  Created by Xiaofu666 on 2024/10/13.
//

import SwiftUI

struct Item: Identifiable {
    var id: String = UUID().uuidString
    var location: CGRect = .zero
    var color: Color
}
