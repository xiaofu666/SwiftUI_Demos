//
//  DataSource.swift
//  ColorThemeMenu
//
//  Created by Raphael Cerqueira on 16/06/21.
//

import SwiftUI

protocol Theme {
    var backgroundColor: Color { get }
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var tertiaryColor: Color { get }
    var quaternaryColor: Color { get }
    var name: String { get }
}


struct BlueTheme: Theme {
    var backgroundColor: Color = Color("blue-background")
    var primaryColor: Color = Color("blue-primary")
    var secondaryColor: Color = Color("blue-secondary")
    var tertiaryColor: Color = Color("blue-tertiary")
    var quaternaryColor: Color = Color("blue-quaternary")
    var name: String = "Blue Theme"
}

struct BlackTheme: Theme {
    var backgroundColor: Color = Color("black-background")
    var primaryColor: Color = Color("black-primary")
    var secondaryColor: Color = Color("black-secondary")
    var tertiaryColor: Color = Color("black-tertiary")
    var quaternaryColor: Color = Color("black-quaternary")
    var name: String = "Black Theme"
}

struct WhiteTheme: Theme {
    var backgroundColor: Color = Color("white-background")
    var primaryColor: Color = Color("white-primary")
    var secondaryColor: Color = Color("white-secondary")
    var tertiaryColor: Color = Color("white-tertiary")
    var quaternaryColor: Color = Color("white-quaternary")
    var name: String = "White Theme"
}

struct DraculaTheme: Theme {
    var backgroundColor: Color = Color("dracula-background")
    var primaryColor: Color = Color("dracula-purple")
    var secondaryColor: Color = Color("dracula-orange")
    var tertiaryColor: Color = Color("dracula-current")
    var quaternaryColor: Color = Color("dracula-current")
    var name: String = "Dracula Theme"
}

enum ThemeManager {
    static let themes: [Theme] = [BlueTheme(), BlackTheme(), WhiteTheme(), DraculaTheme()]
    
    static func getTheme(_ theme: Int) -> Theme {
        Self.themes[theme]
    }
}

class DataSource: ObservableObject {
    @Published var selectedTheme: Theme = BlackTheme()
    @AppStorage("currentTheme") var currentTheme = 1 {
        didSet {
            updateTheme()
        }
    }
    
    init() {
        updateTheme()
    }
    
    func updateTheme() {
        selectedTheme = ThemeManager.getTheme(currentTheme)
    }
}

struct MenuItem: Identifiable {
    let id = UUID().uuidString
    var image: String
    var title: String
    var badge: Int?
}

let items = [
    MenuItem(image: "chart.pie.fill", title: "Dashboard"),
    MenuItem(image: "chart.bar.xaxis", title: "Overview"),
    MenuItem(image: "ellipsis.bubble.fill", title: "Chat", badge: 5),
    MenuItem(image: "person.fill", title: "Team"),
    MenuItem(image: "chart.bar.doc.horizontal.fill", title: "Tasks"),
    MenuItem(image: "exclamationmark.triangle.fill", title: "Reports"),
    MenuItem(image: "gearshape.fill", title: "Settings")
]
