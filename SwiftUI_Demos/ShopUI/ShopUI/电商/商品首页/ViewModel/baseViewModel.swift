//
//  baseViewModel.swift
//  ShoeUI0903
//
//  Created by Lurich on 2021/9/3.
//

import SwiftUI

class baseViewModel: ObservableObject{
   
    // Tab Bar...
    @Published var currentTab: Tab = .Home
    
    @Published var homeTab = "Sneakers"
    
    //detail view properties
    @Published var currentProduct: Product?
    @Published var showDetail = false
}
