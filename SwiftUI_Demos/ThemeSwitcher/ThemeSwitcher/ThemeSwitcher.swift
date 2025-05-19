//
//  ThemeSwitcher.swift
//  ThemeSwitcher
//
//  Created by Xiaofu666 on 2025/5/19.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case systemDefault = "Default"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
                .light
        case .dark:
                .dark
        case .systemDefault:
                nil
        }
    }
}

struct ThemeSwitcher<Content: View>: View {
    @ViewBuilder var content: Content
    @AppStorage("AppTheme") private var appTheme: AppTheme = .systemDefault
    
    var body: some View {
        content
            .preferredColorScheme(appTheme.colorScheme)
    }
}

#Preview {
    ContentView()
}
