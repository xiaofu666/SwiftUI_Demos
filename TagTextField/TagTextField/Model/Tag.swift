//
//  Tag.swift
//  TagTextField
//
//  Created by Lurich on 2023/9/14.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    var id: UUID = .init()
    var value: String
    var isInitial: Bool = false
}
