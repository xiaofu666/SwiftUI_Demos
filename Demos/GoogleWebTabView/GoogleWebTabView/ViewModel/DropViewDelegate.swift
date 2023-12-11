//
//  DropViewDelegate.swift
//  GoogleWebTabView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    
    var page : WebPage
    var pageData : WebPageViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
    
        //From Index
        let fromIndex = pageData.urls.firstIndex { (page) -> Bool in
            return page.id == pageData.currentPage?.id
        } ?? 0
        
        //To Index
        let toIndex = pageData.urls.firstIndex { (page) -> Bool in
            return page.id == self.page.id
        } ?? 0
        
        print(page.url)
        print(pageData.currentPage?.url ?? "-----")
        print("\(fromIndex)   ++++ \(toIndex)")
        
        // safe check if both are not same...
        if fromIndex != toIndex {
            // Swapping Data ...
            
            withAnimation(.default) {
                let fromPage = pageData.urls[fromIndex]
                pageData.urls[fromIndex] = pageData.urls[toIndex]
                pageData.urls[toIndex] = fromPage
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        
        return DropProposal(operation: .move)
    }
    
}

