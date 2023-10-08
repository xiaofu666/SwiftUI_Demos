//
//  CartViewModel.swift
//  Cart
//
//  Created by Lurich on 2021/1/22.
//

import SwiftUI

class CartViewModel: ObservableObject {
    
    
    @Published var items = [
        
        Item(name: "name about pic 1", details: "details", image: "user6", price: 20.09, quantity: 1, offset: 0, isSwiped: false),
        
        Item(name: "name about pic 1", details: "details", image: "user5", price: 13.04, quantity: 2, offset: 0, isSwiped: false),
        
        Item(name: "name about pic 1", details: "details", image: "user4", price: 21.09, quantity: 1, offset: 0, isSwiped: false),
        
        Item(name: "name about pic 1", details: "details", image: "user3", price: 23.33, quantity: 1, offset: 0, isSwiped: false),
        
        Item(name: "name about pic 1", details: "details", image: "user2", price: 17.77, quantity: 1, offset: 0, isSwiped: false),
    
    
    
    ]
    
    
    
}
