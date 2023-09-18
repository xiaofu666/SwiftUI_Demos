//
//  TabModel.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/18.
//

import SwiftUI

// MARK: Tab Model And Sample Data
struct TabModel: Identifiable {
    var id: String = UUID().uuidString
    var tabImage: String
    var tabName: String
    var tabOffset: CGSize
}

var tabModels: [TabModel] = [
    .init(tabImage:"Burger", tabName:"Coffee", tabOffset: CGSize(width: 0, height: -40)),
    .init(tabImage:"Shake", tabName:"Frappo", tabOffset: CGSize(width: 0, height: -38)),
    .init(tabImage:"Burger", tabName:"Ice Cream", tabOffset: CGSize(width: 0, height: -25)),
    .init(tabImage:"Shake", tabName:"Waffles", tabOffset: CGSize(width: -12, height: 28))
    ]
