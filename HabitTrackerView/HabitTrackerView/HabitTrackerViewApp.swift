//
//  HabitTrackerViewApp.swift
//  HabitTrackerView
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

@main
struct HabitTrackerViewApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HabitTrackerView()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
