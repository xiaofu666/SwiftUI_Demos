//
//  PageViewModel.swift
//  GoogleWebTabView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

class WebPageViewModel: ObservableObject {
    
    @Published var selectedTab = "tabs"
    
    @Published var urls = [
        
        WebPage(url: URL(string: "https://b23.tv/StB9qfD")!),
        WebPage(url: URL(string: "https://www.baidu.com/s?wd=SwiftUI")!),
        WebPage(url: URL(string: "https://github.com/xiaofu666")!)
        
    ]
    
    
    @Published var currentPage: WebPage?
    
}
