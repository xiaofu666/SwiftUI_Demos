//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Lurich on 2024/6/29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.light)
            .modelContainer(for: RecentModel.self)
        
    }
}

#Preview {
    ContentView()
}
