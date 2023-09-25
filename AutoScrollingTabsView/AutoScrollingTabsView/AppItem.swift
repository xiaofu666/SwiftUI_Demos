//
//  AppItem.swift
//  AutoScrollingTabsView
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

struct AppItem : Identifiable, Hashable{
    
    var id = UUID().uuidString
    var name : String
    var source : String = "Apple"
    var color : Color = .white
    var num: Int = 1
}

var apps = [

    AppItem(name: "App Store"),
    AppItem(name: "Calculator"),
    AppItem(name: "Calendar"),
    AppItem(name: "Clock"),
    AppItem(name: "Facetime"),
    AppItem(name: "Health"),
    AppItem(name: "Mail"),
    AppItem(name: "Maps"),
    AppItem(name: "Messages"),
    AppItem(name: "News"),
    AppItem(name: "Phone"),
    AppItem(name: "Photos"),
    AppItem(name: "Safari"),
    
]
