//
//  MilkShake.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/18.
//

import SwiftUI

struct MilkShake: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var price: String
    var image: String
}

var milkShakes: [MilkShake] = [
    .init(title:"Milk Frappe", price: "$26.99", image: "Shake"),
    .init(title:"Milk & Chocalate\nFrappe", price: "$29.99", image:"Burger"),
    .init(title:"Frappuccino", price:"$49.99", image: "Shake"),
    .init(title:"Espresso", price: "$19.99", image: "Burger"),
    .init(title:"Creme Frappuccino", price:"$39.99", image: "Shake")
    ]
