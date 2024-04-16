//
//  Message.swift
//  iMessageCardSwipe1213
//
//  Created by Lurich on 2022/12/13.
//

import SwiftUI

struct Message: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var imageFile: String
}

