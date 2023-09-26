//
//  Product.swift
//  ShoeUI0903
//
//  Created by Lurich on 2021/9/3.
//

import SwiftUI

struct Product: Identifiable {
    
    var id = UUID().uuidString
    var productImage: String
    var productTitle: String
    var productPrice: String
    var productBG: Color
    var isLiked: Bool = false
    var productRating: Int
}


var ProductsData = [

    Product(productImage: "user1", productTitle: "Nike Air Max20", productPrice: "$240.0", productBG: Color("Card-1"), productRating: 4),
    Product(productImage: "user2", productTitle: "Excee Sneakers", productPrice: "$290.0", productBG: Color("Card-2"), productRating: 3),
    Product(productImage: "user3", productTitle: "Air Max Motion 2", productPrice: "$180.0", productBG: Color("Card-3"), productRating: 2),
    Product(productImage: "user4", productTitle: "To be No.1", productPrice: "$99.0", productBG: Color("Card-4"), isLiked: true, productRating: 5),
    Product(productImage: "user5", productTitle: "Nike Pro Max20", productPrice: "$290.0", productBG: Color("Card-5"), productRating: 3),
    Product(productImage: "user6", productTitle: "Lurich Plus Fu20", productPrice: "$399.0", productBG: Color("Card-6"), productRating: 3),
]
