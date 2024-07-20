//
//  ShareData.swift
//  iOS18PhotosAppUI
//
//  Created by Xiaofu666 on 2024/7/21.
//

import SwiftUI

@Observable
class ShareData {
    var activePage: Int = 3
    var isExpanded: Bool = false
    var mainOffset: CGFloat = .zero
    var photosScreenOffset: CGFloat = .zero
    var selectedCategory: String = "年"
    var canPullUp: Bool = false
    var canPullDown: Bool = false
    var progress: CGFloat = 0
}
